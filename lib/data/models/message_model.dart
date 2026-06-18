import 'package:flutter_relevo/data/models/user_model.dart';

class Message {
  final String id;
  final String chatId;
  final User sender;
  final String content;
  final String messageType; // 'text', 'image', 'file', 'audio', 'video'
  final String? s3Key;
  final String? fileName;
  final int? fileSize;
  final String? mimeType;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? fileUrl;

  Message({
    required this.id,
    required this.chatId,
    required this.sender,
    required this.content,
    required this.messageType,
    this.s3Key,
    this.fileName,
    this.fileSize,
    this.mimeType,
    this.createdAt,
    this.updatedAt,
    this.fileUrl,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['_id'] ?? json['id'] ?? '',
      chatId: json['chat'] ?? '',
      sender: User.fromJson(json['sender'] is Map ? json['sender'] : {}),
      content: json['content'] ?? '',
      messageType: json['messageType'] ?? 'text',
      s3Key: json['s3Key'],
      fileName: json['fileName'],
      fileSize: json['fileSize'] != null ? (json['fileSize'] as num).toInt() : null,
      mimeType: json['mimeType'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      fileUrl: json['fileUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'chat': chatId,
      'sender': sender.toJson(),
      'content': content,
      'messageType': messageType,
      's3Key': s3Key,
      'fileName': fileName,
      'fileSize': fileSize,
      'mimeType': mimeType,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'fileUrl': fileUrl,
    };
  }

  bool get isText => messageType == 'text';
  bool get isImage => messageType == 'image';
  bool get isFile => messageType == 'file';
  bool get isAudio => messageType == 'audio';
  bool get isVideo => messageType == 'video';
}
