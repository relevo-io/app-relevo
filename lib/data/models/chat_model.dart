import 'package:flutter_relevo/data/models/offer_model.dart';
import 'package:flutter_relevo/data/models/user_model.dart';

class ChatLastMessage {
  final String content;
  final String senderId;
  final DateTime sentAt;

  ChatLastMessage({
    required this.content,
    required this.senderId,
    required this.sentAt,
  });

  factory ChatLastMessage.fromJson(Map<String, dynamic> json) {
    return ChatLastMessage(
      content: json['content'] ?? '',
      senderId: json['senderId'] ?? '',
      sentAt: json['sentAt'] != null
          ? DateTime.parse(json['sentAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'senderId': senderId,
      'sentAt': sentAt.toIso8601String(),
    };
  }
}

class Chat {
  final String id;
  final Offer oferta;
  final User owner;
  final User interested;
  final ChatLastMessage? lastMessage;
  final int unreadOwner;
  final int unreadInterested;
  final bool isReadOnly;
  final String status; // 'PENDING_APPROVAL', 'APPROVED', 'REJECTED'
  final bool closedByOwner;
  final bool closedByInterested;
  final DateTime? closedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Chat({
    required this.id,
    required this.oferta,
    required this.owner,
    required this.interested,
    this.lastMessage,
    required this.unreadOwner,
    required this.unreadInterested,
    required this.isReadOnly,
    required this.status,
    required this.closedByOwner,
    required this.closedByInterested,
    this.closedAt,
    this.createdAt,
    this.updatedAt,
  });

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      id: json['_id'] ?? json['id'] ?? '',
      oferta: Offer.fromJson(json['oferta'] is Map ? json['oferta'] : {}),
      owner: User.fromJson(json['owner'] is Map ? json['owner'] : {}),
      interested: User.fromJson(json['interested'] is Map ? json['interested'] : {}),
      lastMessage: json['lastMessage'] != null
          ? ChatLastMessage.fromJson(json['lastMessage'])
          : null,
      unreadOwner: json['unreadOwner'] ?? 0,
      unreadInterested: json['unreadInterested'] ?? 0,
      isReadOnly: json['isReadOnly'] ?? false,
      status: json['status'] ?? 'PENDING_APPROVAL',
      closedByOwner: json['closedByOwner'] ?? false,
      closedByInterested: json['closedByInterested'] ?? false,
      closedAt: json['closedAt'] != null ? DateTime.parse(json['closedAt']) : null,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'oferta': oferta.toJson(),
      'owner': owner.toJson(),
      'interested': interested.toJson(),
      'lastMessage': lastMessage?.toJson(),
      'unreadOwner': unreadOwner,
      'unreadInterested': unreadInterested,
      'isReadOnly': isReadOnly,
      'status': status,
      'closedByOwner': closedByOwner,
      'closedByInterested': closedByInterested,
      'closedAt': closedAt?.toIso8601String(),
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}
