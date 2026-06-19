import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:file_picker/file_picker.dart';
import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_relevo/data/providers/chat_providers.dart';
import 'package:flutter_relevo/data/providers/auth_provider.dart';
import 'package:flutter_relevo/data/services/chat_service.dart';
import 'package:flutter_relevo/data/services/socket_service.dart';
import 'package:flutter_relevo/data/models/chat_model.dart';
import 'package:flutter_relevo/data/models/message_model.dart';
import 'package:flutter_relevo/data/models/user_model.dart';
import 'package:flutter_relevo/data/models/offer_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mime/mime.dart';

class ChatRoomScreen extends ConsumerStatefulWidget {
  final String chatId;

  const ChatRoomScreen({super.key, required this.chatId});

  @override
  ConsumerState<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends ConsumerState<ChatRoomScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  
  // Grabación de Voz
  final AudioRecorder _audioRecorder = AudioRecorder();
  bool _isRecording = false;
  DateTime? _recordingStartTime;
  Timer? _recordingTimer;
  int _recordingDurationSeconds = 0;

  // Typing state local para controlar emisión
  bool _isTyping = false;
  Timer? _typingStopTimer;
  bool _hasText = false; // Control de visualización del botón enviar/grabar

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _textController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _textController.dispose();
    _audioRecorder.dispose();
    _recordingTimer?.cancel();
    _typingStopTimer?.cancel();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.hasClients) {
      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.position.pixels;
      // Si el usuario hace scroll hacia arriba (hacia mensajes antiguos), cargamos la siguiente página
      if (currentScroll >= maxScroll - 200) {
        ref.read(chatRoomMessagesProvider(widget.chatId).notifier).fetchNextPage();
      }
    }
  }

  void _onTextChanged() {
    final text = _textController.text.trim();
    final socketService = ref.read(socketServiceProvider);

    final hasText = text.isNotEmpty;
    if (hasText != _hasText) {
      setState(() {
        _hasText = hasText;
      });
    }

    if (text.isNotEmpty && !_isTyping) {
      _isTyping = true;
      socketService.sendTypingStart(widget.chatId);
    }

    _typingStopTimer?.cancel();
    if (text.isEmpty && _isTyping) {
      _isTyping = false;
      socketService.sendTypingStop(widget.chatId);
    } else if (text.isNotEmpty) {
      _typingStopTimer = Timer(const Duration(seconds: 2), () {
        if (mounted && _isTyping) {
          _isTyping = false;
          socketService.sendTypingStop(widget.chatId);
        }
      });
    }
  }

  // --- Grabación de Voz ---

  Future<void> _startRecording() async {
    try {
      if (await _audioRecorder.hasPermission()) {
        final tempDir = await getTemporaryDirectory();
        final filePath = '${tempDir.path}/voice_${DateTime.now().millisecondsSinceEpoch}.m4a';

        await _audioRecorder.start(
          const RecordConfig(
            encoder: AudioEncoder.aacLc,
            numChannels: 1,
          ),
          path: filePath,
        );

        setState(() {
          _isRecording = true;
          _recordingStartTime = DateTime.now();
          _recordingDurationSeconds = 0;
        });

        _recordingTimer?.cancel();
        _recordingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
          setState(() {
            _recordingDurationSeconds = DateTime.now().difference(_recordingStartTime!).inSeconds;
          });
        });
      }
    } catch (e) {
      _showErrorSnackBar('Error al iniciar grabación: $e');
    }
  }

  Future<void> _stopRecording() async {
    _recordingTimer?.cancel();
    if (!_isRecording) return;

    try {
      final path = await _audioRecorder.stop();
      setState(() {
        _isRecording = false;
      });

      if (path != null && _recordingDurationSeconds >= 1) {
        final file = File(path);
        final bytes = await file.readAsBytes();
        final filename = path.split('/').last;
        _uploadAndSendMessage(bytes, filename, 'audio/mp4', 'audio');
      }
    } catch (e) {
      _showErrorSnackBar('Error al detener grabación: $e');
    }
  }

  // --- Subida de archivos y mensajes ---

  bool _isPickingFile = false;

  Map<String, String> _resolveFileType(String filename, String originalType) {
    final mimeType = lookupMimeType(filename) ??
        (originalType == 'image' ? 'image/jpeg' : 'application/octet-stream');

    String messageType = 'file';
    if (mimeType.startsWith('image/')) {
      messageType = 'image';
    } else if (mimeType.startsWith('audio/')) {
      messageType = 'audio';
    } else if (mimeType.startsWith('video/')) {
      messageType = 'video';
    }

    return {
      'mimeType': mimeType,
      'messageType': messageType,
    };
  }

  Future<void> _pickAndUploadFile(String type) async {
    if (_isPickingFile) return;
    setState(() {
      _isPickingFile = true;
    });

    try {
      final FileType fileType = type == 'image' ? FileType.image : FileType.any;
      final result = await FilePicker.platform.pickFiles(type: fileType);

      if (result != null) {
        final fileInfo = result.files.single;
        
        if (fileInfo.path != null) {
          final filePath = fileInfo.path!;
          final file = File(filePath);
          final bytes = await file.readAsBytes();
          
          final resolved = _resolveFileType(fileInfo.name, type);
          final String mimeType = resolved['mimeType']!;
          final String messageType = resolved['messageType']!;

          _uploadAndSendMessage(bytes, fileInfo.name, mimeType, messageType);
        } else if (fileInfo.bytes != null) {
          final resolved = _resolveFileType(fileInfo.name, type);
          final String mimeType = resolved['mimeType']!;
          final String messageType = resolved['messageType']!;
          _uploadAndSendMessage(fileInfo.bytes!, fileInfo.name, mimeType, messageType);
        } else {
          _showErrorSnackBar('Error: El archivo no tiene una ruta local ni bytes válidos.');
        }
      }
    } catch (e) {
      _showErrorSnackBar('Error al seleccionar archivo: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isPickingFile = false;
        });
      }
    }
  }

  Future<void> _uploadAndSendMessage(
    List<int> bytes,
    String filename,
    String mimeType,
    String messageType,
  ) async {
    final chatService = ref.read(chatServiceProvider);
    final socketService = ref.read(socketServiceProvider);

    // Indicador visual de carga
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(localeText(
          ca: 'Pujant fitxer...',
          es: 'Subiendo archivo...',
          en: 'Uploading file...',
        )),
        duration: const Duration(seconds: 30),
      ),
    );

    try {
      // 1. Obtener URL pre-firmada
      final presignedData = await chatService.getPresignedUploadUrl(filename, mimeType);
      final uploadUrl = presignedData['uploadUrl'] as String;
      final s3Key = presignedData['s3Key'] as String;

      // 2. Subir directamente a S3
      await chatService.uploadFileToS3(uploadUrl, bytes, mimeType);

      // Ocultar indicador de carga
      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      // 3. Enviar mensaje por el socket
      final msg = await socketService.sendMessage(
        widget.chatId,
        messageType: messageType,
        s3Key: s3Key,
        fileName: filename,
        fileSize: bytes.length,
        mimeType: mimeType,
      );

      // Insertar localmente
      ref.read(chatRoomMessagesProvider(widget.chatId).notifier).addLocalMessage(msg);
      _scrollToBottom();
    } catch (e) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      _showErrorSnackBar('Error al subir archivo: $e');
    }
  }

  void _sendMessage() async {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    final socketService = ref.read(socketServiceProvider);
    _textController.clear();
    
    // Detener indicador de escritura
    if (_isTyping) {
      _isTyping = false;
      socketService.sendTypingStop(widget.chatId);
    }

    try {
      final msg = await socketService.sendMessage(widget.chatId, content: text, messageType: 'text');
      ref.read(chatRoomMessagesProvider(widget.chatId).notifier).addLocalMessage(msg);
      _scrollToBottom();
    } catch (e) {
      _showErrorSnackBar(e.toString());
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _showErrorSnackBar(String error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(error),
        backgroundColor: Colors.red[800],
      ),
    );
  }

  String localeText({required String ca, required String es, required String en}) {
    final locale = Localizations.localeOf(context).languageCode;
    return locale == 'ca' ? ca : locale == 'es' ? es : en;
  }

  @override
  Widget build(BuildContext context) {
    final chatsAsync = ref.watch(chatsListProvider);
    final messagesAsync = ref.watch(chatRoomMessagesProvider(widget.chatId));
    final isTyping = ref.watch(chatRoomTypingProvider(widget.chatId));
    final isOnline = ref.watch(chatRoomPresenceProvider(widget.chatId));
    final currentUser = ref.watch(authProvider).value;
    final theme = Theme.of(context);

    // Buscar chat en la lista de chats cargados
    final chat = chatsAsync.value?.firstWhere(
      (c) => c.id == widget.chatId,
      orElse: () => Chat(
        id: widget.chatId,
        oferta: Offer(id: '', region: '', sector: '', companyDescription: '', owner: ''),
        owner: User(id: '', fullName: '', email: '', roles: []),
        interested: User(id: '', fullName: '', email: '', roles: []),
        unreadOwner: 0,
        unreadInterested: 0,
        isReadOnly: false,
        status: 'APPROVED',
        closedByOwner: false,
        closedByInterested: false,
      ),
    );

    final isOwner = currentUser?.id == chat?.owner.id;
    final otherUser = isOwner ? chat?.interested : chat?.owner;
    final otherUserName = otherUser?.fullName ?? '...';
    
    final bool isPending = chat?.status == 'PENDING_APPROVAL';
    final bool isRejected = chat?.status == 'REJECTED';
    final bool isReadOnly = chat?.isReadOnly ?? false;

    // Iniciales
    final initials = otherUserName.isNotEmpty
        ? otherUserName.split(' ').map((e) => e.isEmpty ? '' : e[0]).take(2).join().toUpperCase()
        : '?';

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.1),
                  child: Text(
                    initials,
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
                if (isOnline)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 1.5),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    otherUserName,
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    chat?.oferta.sector ?? '',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.secondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Banner de Aprobación
          if (isPending)
            Container(
              color: Colors.amber.withValues(alpha: 0.15),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: isOwner
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          localeText(
                            ca: 'Aquest usuari vol iniciar un contacte directe amb tu. Aceptes la sol·licitud?',
                            es: 'Este usuario desea iniciar un contacto directo contigo. ¿Aceptas la solicitud?',
                            en: 'This user wants to start direct contact with you. Do you accept the request?',
                          ),
                          style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.amber[900]),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () {
                                ref.read(chatsListProvider.notifier).updateChatStatusInList(widget.chatId, 'REJECTED');
                              },
                              style: TextButton.styleFrom(foregroundColor: Colors.red[800]),
                              child: Text(localeText(ca: 'Denegar', es: 'Denegar', en: 'Reject')),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: () {
                                ref.read(chatsListProvider.notifier).updateChatStatusInList(widget.chatId, 'APPROVED');
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: theme.colorScheme.secondary,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              child: Text(localeText(ca: 'Aceptar', es: 'Aceptar', en: 'Accept')),
                            ),
                          ],
                        )
                      ],
                    )
                  : Row(
                      children: [
                        const Icon(Icons.hourglass_empty_rounded, color: Colors.amber, size: 18),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            localeText(
                              ca: 'Pendent d\'aprovació per part del propietari.',
                              es: 'Pendiente de aprobación por parte del propietario.',
                              en: 'Pending approval by the owner.',
                            ),
                            style: GoogleFonts.inter(fontSize: 13, color: Colors.amber[900], fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
            ),

          if (isRejected)
            Container(
              color: Colors.red.withValues(alpha: 0.1),
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  const Icon(Icons.error_outline_rounded, color: Colors.red, size: 18),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      localeText(
                        ca: 'Aquesta sol·licitud de contacte ha estat rebutjada.',
                        es: 'Esta solicitud de contacto ha sido rechazada.',
                        en: 'This contact request has been rejected.',
                      ),
                      style: GoogleFonts.inter(fontSize: 13, color: Colors.red[800], fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),

          if (isReadOnly)
            Container(
              color: theme.colorScheme.outline.withValues(alpha: 0.15),
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Icon(Icons.lock_outline_rounded, color: theme.colorScheme.onSurface.withValues(alpha: 0.5), size: 18),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      localeText(
                        ca: 'Aquest xat és de només lectura perquè l\'oferta ha estat tancada o esborrada.',
                        es: 'Este chat es de solo lectura porque la oferta ha sido cerrada o eliminada.',
                        en: 'This chat is read-only because the offer has been closed or deleted.',
                      ),
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // Historial de Mensajes
          Expanded(
            child: messagesAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text(err.toString(), style: TextStyle(color: Colors.red[800]))),
              data: (messages) {
                return ListView.builder(
                  controller: _scrollController,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final bool isMe = message.sender.id == currentUser?.id;
                    return _MessageBubble(message: message, isMe: isMe);
                  },
                );
              },
            ),
          ),

          // Indicador de Escritura
          if (isTyping)
            Padding(
              padding: const EdgeInsets.only(left: 24, bottom: 8, top: 4),
              child: Row(
                children: [
                  Text(
                    '$otherUserName ${localeText(ca: 'està escrivint...', es: 'está escribiendo...', en: 'is typing...')}',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontStyle: FontStyle.italic,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                    ),
                  ),
                ],
              ),
            ),

          // Campo de Entrada (Input)
          if (!isPending && !isRejected && !isReadOnly)
            Container(
              padding: EdgeInsets.only(
                left: 16.0,
                right: 16.0,
                top: 8.0,
                bottom: 8.0 + MediaQuery.of(context).viewInsets.bottom + (Platform.isIOS ? 16.0 : 8.0),
              ),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainer,
                border: Border(top: BorderSide(color: theme.colorScheme.outline.withValues(alpha: 0.1))),
              ),
              child: Row(
                children: [
                  // Botón Adjuntar
                  IconButton(
                    icon: Icon(Icons.attach_file_rounded, color: theme.colorScheme.primary),
                    onPressed: () {
                      _showAttachmentOptions(context);
                    },
                  ),
                  // Campo de texto / Grabador activo
                  Expanded(
                    child: _isRecording
                        ? Container(
                            height: 48,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: Colors.red.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '${_recordingDurationSeconds}s',
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red[800],
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  localeText(
                                    ca: 'Gravant nota de veu...',
                                    es: 'Grabando nota de voz...',
                                    en: 'Recording voice message...',
                                  ),
                                  style: GoogleFonts.inter(fontSize: 13, fontStyle: FontStyle.italic, color: Colors.red[800]),
                                ),
                              ],
                            ),
                          )
                        : Container(
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surface,
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.2)),
                            ),
                            child: TextField(
                              controller: _textController,
                              maxLines: 4,
                              minLines: 1,
                              decoration: InputDecoration(
                                hintText: localeText(
                                  ca: 'Escriu un missatge...',
                                  es: 'Escribe un mensaje...',
                                  en: 'Type a message...',
                                ),
                                hintStyle: GoogleFonts.inter(fontSize: 14, color: theme.colorScheme.onSurface.withValues(alpha: 0.4)),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                              ),
                            ),
                          ),
                  ),
                  const SizedBox(width: 8),
                  // Botón de Enviar o Grabar
                  GestureDetector(
                    onLongPressStart: (_) {
                      if (!_isRecording && _textController.text.trim().isEmpty) {
                        _startRecording();
                      }
                    },
                    onLongPressEnd: (_) {
                      if (_isRecording) {
                        _stopRecording();
                      }
                    },
                    child: FloatingActionButton.small(
                      onPressed: () {
                        if (_hasText) {
                          _sendMessage();
                        } else if (!_isRecording) {
                          // Si solo pulsa el micro de voz una vez, mostramos aviso
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(localeText(
                                ca: 'Manté pressionat per gravar àudio',
                                es: 'Mantén presionado para grabar audio',
                                en: 'Hold down to record audio',
                              )),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        }
                      },
                      elevation: 0,
                      backgroundColor: theme.colorScheme.primary,
                      child: Icon(
                        _hasText ? Icons.send_rounded : Icons.mic_none_rounded,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  void _showAttachmentOptions(BuildContext context) {
    final theme = Theme.of(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: theme.colorScheme.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildAttachmentOption(
                  icon: Icons.image_outlined,
                  label: localeText(ca: 'Imatge', es: 'Imagen', en: 'Image'),
                  onTap: () async {
                    Navigator.pop(context);
                    await Future.delayed(const Duration(milliseconds: 200));
                    _pickAndUploadFile('image');
                  },
                ),
                _buildAttachmentOption(
                  icon: Icons.insert_drive_file_outlined,
                  label: localeText(ca: 'Fitxer', es: 'Archivo', en: 'File'),
                  onTap: () async {
                    Navigator.pop(context);
                    await Future.delayed(const Duration(milliseconds: 200));
                    _pickAndUploadFile('file');
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAttachmentOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 80,
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.08),
              child: Icon(icon, color: theme.colorScheme.primary, size: 24),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: theme.colorScheme.onSurface),
            ),
          ],
        ),
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final Message message;
  final bool isMe;

  const _MessageBubble({required this.message, required this.isMe});

  String _localeText(BuildContext context, {required String ca, required String es, required String en}) {
    final locale = Localizations.localeOf(context).languageCode;
    return locale == 'ca' ? ca : locale == 'es' ? es : en;
  }

  Future<void> _openUrl(BuildContext context, String? url) async {
    if (url == null || url.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_localeText(
            context,
            ca: 'URL del fitxer no disponible',
            es: 'URL del archivo no disponible',
            en: 'File URL not available',
          )),
          backgroundColor: Colors.red[800],
        ),
      );
      return;
    }

    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_localeText(
              context,
              ca: 'No s\'ha pogut obrir el fitxer',
              es: 'No se pudo abrir el archivo',
              en: 'Could not open the file',
            )),
            backgroundColor: Colors.red[800],
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${_localeText(context, ca: 'Error en obrir:', es: 'Error al abrir:', en: 'Error opening:')} $e'),
          backgroundColor: Colors.red[800],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    final timeStr = message.createdAt != null
        ? '${message.createdAt!.hour.toString().padLeft(2, '0')}:${message.createdAt!.minute.toString().padLeft(2, '0')}'
        : '';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (!isMe) ...[
                CircleAvatar(
                  radius: 14,
                  backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.1),
                  child: Text(
                    message.sender.fullName.isNotEmpty ? message.sender.fullName[0].toUpperCase() : '?',
                    style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: theme.colorScheme.primary),
                  ),
                ),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                  decoration: BoxDecoration(
                    color: isMe
                        ? theme.colorScheme.primary
                        : theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft: Radius.circular(isMe ? 16 : 4),
                      bottomRight: Radius.circular(isMe ? 4 : 16),
                    ),
                  ),
                  child: _buildMessageContent(context),
                ),
              ),
            ],
          ),
          if (timeStr.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(top: 4, left: isMe ? 0 : 38, right: isMe ? 4 : 0),
              child: Text(
                timeStr,
                style: GoogleFonts.inter(
                  fontSize: 10,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMessageContent(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = isMe ? Colors.white : theme.colorScheme.onSurfaceVariant;

    if (message.isText) {
      return Text(
        message.content,
        style: GoogleFonts.inter(color: textColor, fontSize: 14, height: 1.3),
      );
    } else if (message.isImage) {
      if (message.fileUrl == null) {
        return const SizedBox(
          width: 150,
          height: 150,
          child: Center(child: CircularProgressIndicator()),
        );
      }
      return GestureDetector(
        onTap: () => _openUrl(context, message.fileUrl),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            message.fileUrl!,
            width: 200,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return const SizedBox(
                width: 200,
                height: 150,
                child: Center(child: CircularProgressIndicator()),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return SizedBox(
                width: 200,
                height: 120,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.broken_image_outlined, color: textColor),
                    const SizedBox(height: 8),
                    Text('Error de imagen', style: TextStyle(color: textColor, fontSize: 11)),
                  ],
                ),
              );
            },
          ),
        ),
      );
    } else if (message.isAudio) {
      return VoiceMessageBubble(
        url: message.fileUrl,
        isMe: isMe,
        fileSize: message.fileSize,
      );
    } else {
      // Archivo genérico
      return InkWell(
        onTap: () => _openUrl(context, message.fileUrl),
        borderRadius: BorderRadius.circular(8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.insert_drive_file_outlined, color: textColor, size: 24),
            const SizedBox(width: 10),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    message.fileName ?? 'Archivo',
                    style: GoogleFonts.inter(
                      color: textColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (message.fileSize != null)
                    Text(
                      '${(message.fileSize! / 1024).toStringAsFixed(1)} KB',
                      style: GoogleFonts.inter(
                        color: textColor.withValues(alpha: 0.7),
                        fontSize: 11,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Icon(Icons.download_rounded, color: textColor, size: 20),
          ],
        ),
      );
    }
  }
}

// Widget local para la burbuja del reproductor de voz
class VoiceMessageBubble extends StatefulWidget {
  final String? url;
  final bool isMe;
  final int? fileSize;

  const VoiceMessageBubble({super.key, required this.url, required this.isMe, this.fileSize});

  @override
  State<VoiceMessageBubble> createState() => _VoiceMessageBubbleState();
}

class _VoiceMessageBubbleState extends State<VoiceMessageBubble> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  PlayerState _playerState = PlayerState.stopped;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  late StreamSubscription _positionSub;
  late StreamSubscription _durationSub;
  late StreamSubscription _stateSub;

  @override
  void initState() {
    super.initState();

    _positionSub = _audioPlayer.onPositionChanged.listen((p) {
      if (mounted) setState(() => _position = p);
    });

    _durationSub = _audioPlayer.onDurationChanged.listen((d) {
      if (mounted) setState(() => _duration = d);
    });

    _stateSub = _audioPlayer.onPlayerStateChanged.listen((s) {
      if (mounted) setState(() => _playerState = s);
    });
  }

  @override
  void dispose() {
    _positionSub.cancel();
    _durationSub.cancel();
    _stateSub.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _playPause() async {
    if (widget.url == null) return;

    if (_playerState == PlayerState.playing) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play(UrlSource(widget.url!));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = widget.isMe ? Colors.white : theme.colorScheme.onSurface;

    final double progress = _duration.inMilliseconds > 0
        ? _position.inMilliseconds / _duration.inMilliseconds
        : 0.0;

    final timeStr = '${_position.inSeconds}s / ${_duration.inSeconds}s';

    return Container(
      width: 220,
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              _playerState == PlayerState.playing ? Icons.pause_rounded : Icons.play_arrow_rounded,
              color: color,
              size: 28,
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: _playPause,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  children: [
                    Container(
                      height: 4,
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    FractionallySizedBox(
                      widthFactor: progress.clamp(0.0, 1.0),
                      child: Container(
                        height: 4,
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      timeStr,
                      style: GoogleFonts.inter(color: color.withValues(alpha: 0.7), fontSize: 10),
                    ),
                    if (widget.fileSize != null)
                      Text(
                        '${(widget.fileSize! / 1024).toStringAsFixed(1)} KB',
                        style: GoogleFonts.inter(color: color.withValues(alpha: 0.7), fontSize: 10),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
