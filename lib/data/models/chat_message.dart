import 'dart:convert';

/// Модель сообщения мессенджера
class ChatMessage {
  final String id;
  final String senderId;
  final String senderName;
  final String? senderAvatarUrl;
  final String receiverId;
  final String receiverName;
  final String content;
  final String type;
  final String? fileUrl;
  final String? fileName;
  final String? fileContentType;
  final bool isRead;
  final DateTime sentAt;

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.senderName,
    this.senderAvatarUrl,
    required this.receiverId,
    required this.receiverName,
    required this.content,
    required this.type,
    this.fileUrl,
    this.fileName,
    this.fileContentType,
    required this.isRead,
    required this.sentAt,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'] as String,
      senderId: json['senderId'] as String,
      senderName: json['senderName'] as String,
      senderAvatarUrl: json['senderAvatarUrl'] as String?,
      receiverId: json['receiverId'] as String,
      receiverName: json['receiverName'] as String,
      content: json['content'] as String,
      type: json['type'] as String,
      fileUrl: json['fileUrl'] as String?,
      fileName: json['fileName'] as String?,
      fileContentType: json['fileContentType'] as String?,
      isRead: json['isRead'] as bool,
      sentAt: DateTime.parse(json['sentAt'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'senderId': senderId,
        'senderName': senderName,
        'senderAvatarUrl': senderAvatarUrl,
        'receiverId': receiverId,
        'receiverName': receiverName,
        'content': content,
        'type': type,
        'fileUrl': fileUrl,
        'fileName': fileName,
        'fileContentType': fileContentType,
        'isRead': isRead,
        'sentAt': sentAt.toIso8601String(),
      };

  bool get isMe => senderId == 'me';

  bool get isText => type == 'TEXT';
  bool get isImage => type == 'IMAGE';
  bool get isFile => type == 'FILE';
}

/// Модель диалога
class Conversation {
  final String userId;
  final String userName;
  final String? userAvatarUrl;
  final String? lastMessage;
  final DateTime? lastMessageAt;
  final int unreadCount;

  Conversation({
    required this.userId,
    required this.userName,
    this.userAvatarUrl,
    this.lastMessage,
    this.lastMessageAt,
    this.unreadCount = 0,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      userId: json['userId'] as String,
      userName: json['userName'] as String,
      userAvatarUrl: json['userAvatarUrl'] as String?,
      lastMessage: json['lastMessage'] as String?,
      lastMessageAt: json['lastMessageAt'] != null
          ? DateTime.parse(json['lastMessageAt'] as String)
          : null,
      unreadCount: json['unreadCount'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'userName': userName,
        'userAvatarUrl': userAvatarUrl,
        'lastMessage': lastMessage,
        'lastMessageAt': lastMessageAt?.toIso8601String(),
        'unreadCount': unreadCount,
      };
}
