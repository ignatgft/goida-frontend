import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import '../../l10n/app_localizations.dart';
import '../../core/theme/ios_design_system.dart';
import '../providers/chat_provider.dart';

/// Экран ИИ Чата в едином стиле с полноценной историей
class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _contextController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ImagePicker _imagePicker = ImagePicker();
  
  List<File> _selectedFiles = [];
  List<AttachmentItem> _attachments = [];
  bool _showContextWindow = false;
  bool _isAttachmentMenuOpen = false;

  @override
  void dispose() {
    _controller.dispose();
    _contextController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage(ChatProvider chatProvider) async {
    final text = _controller.text.trim();
    if (text.isEmpty && _attachments.isEmpty) {
      return;
    }

    final images = _attachments
        .where((a) => a.type == AttachmentType.image)
        .map((a) => File(a.path))
        .toList();

    await chatProvider.sendMessage(
      text,
      context: _contextController.text.isEmpty ? null : _contextController.text,
      images: images.isNotEmpty ? images : null,
    );

    _controller.clear();
    setState(() {
      _attachments.clear();
      _selectedFiles.clear();
      _isAttachmentMenuOpen = false;
    });
    _scrollToBottom();
  }

  Future<void> _pickImage(ImageSource source, BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 1920,
      );

      if (image != null) {
        final file = File(image.path);
        final fileSize = await file.length();
        
        // Проверка размера (макс 10MB)
        if (fileSize > 10 * 1024 * 1024) {
          _showErrorSnackBar(context, l10n.fileSizeTooLarge);
          return;
        }

        setState(() {
          _attachments.add(AttachmentItem(
            type: AttachmentType.image,
            path: image.path,
            name: source == ImageSource.camera 
                ? l10n.camera 
                : l10n.gallery,
          ));
        });
      }
    } catch (e) {
      _showErrorSnackBar(context, l10n.uploadError);
    }
  }

  Future<void> _pickFile(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        final filePath = result.files.single.path!;
        final fileSize = File(filePath).lengthSync();
        
        // Проверка размера (макс 10MB)
        if (fileSize > 10 * 1024 * 1024) {
          _showErrorSnackBar(context, l10n.fileSizeTooLarge);
          return;
        }

        setState(() {
          _attachments.add(AttachmentItem(
            type: AttachmentType.file,
            path: filePath,
            name: result.files.single.name,
          ));
        });
      }
    } catch (e) {
      _showErrorSnackBar(context, l10n.uploadError);
    }
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: IosDesignSystem.errorRed,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showAttachmentMenu() {
    final l10n = AppLocalizations.of(context)!;

    setState(() {
      _isAttachmentMenuOpen = !_isAttachmentMenuOpen;
    });

    if (_isAttachmentMenuOpen) {
      showCupertinoModalPopup(
        context: context,
        builder: (context) => CupertinoActionSheet(
          title: Text(l10n.selectSource, style: const TextStyle(fontWeight: FontWeight.w600)),
          actions: [
            CupertinoActionSheetAction(
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: IosDesignSystem.primaryAccent.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(IosDesignSystem.radiusSmall),
                    ),
                    child: const Icon(Icons.camera_alt_rounded, color: IosDesignSystem.primaryAccent, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.camera, style: const TextStyle(fontWeight: FontWeight.w500)),
                      Text(l10n.attachPhoto, style: TextStyle(fontSize: 13, color: IosDesignSystem.getLabelSecondary(context))),
                    ],
                  ),
                ],
              ),
              onPressed: () {
                Navigator.pop(context);
                setState(() => _isAttachmentMenuOpen = false);
                _pickImage(ImageSource.camera, context);
              },
            ),
            CupertinoActionSheetAction(
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: IosDesignSystem.primaryAccent.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(IosDesignSystem.radiusSmall),
                    ),
                    child: const Icon(Icons.photo_library_rounded, color: IosDesignSystem.primaryAccent, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.gallery, style: const TextStyle(fontWeight: FontWeight.w500)),
                      Text(l10n.attachPhoto, style: TextStyle(fontSize: 13, color: IosDesignSystem.getLabelSecondary(context))),
                    ],
                  ),
                ],
              ),
              onPressed: () {
                Navigator.pop(context);
                setState(() => _isAttachmentMenuOpen = false);
                _pickImage(ImageSource.gallery, context);
              },
            ),
            CupertinoActionSheetAction(
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: IosDesignSystem.primaryAccent.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(IosDesignSystem.radiusSmall),
                    ),
                    child: const Icon(Icons.insert_drive_file_rounded, color: IosDesignSystem.primaryAccent, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.fileManager, style: const TextStyle(fontWeight: FontWeight.w500)),
                      Text(l10n.attachFile, style: TextStyle(fontSize: 13, color: IosDesignSystem.getLabelSecondary(context))),
                    ],
                  ),
                ],
              ),
              onPressed: () {
                Navigator.pop(context);
                setState(() => _isAttachmentMenuOpen = false);
                _pickFile(context);
              },
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            child: Text(l10n.cancel),
            onPressed: () {
              Navigator.pop(context);
              setState(() => _isAttachmentMenuOpen = false);
            },
          ),
        ),
      ).then((_) => setState(() => _isAttachmentMenuOpen = false));
    }
  }

  void _showClearChatDialog() {
    final l10n = AppLocalizations.of(context)!;
    
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text(l10n.clearChat),
        content: Text(l10n.clearChatConfirm),
        actions: [
          CupertinoDialogAction(
            child: Text(l10n.cancel),
            onPressed: () => Navigator.pop(context),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            child: Text(l10n.clearChat),
            onPressed: () {
              Navigator.pop(context);
              context.read<ChatProvider>().clearChat();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(l10n.chatCleared),
                  backgroundColor: IosDesignSystem.successGreen,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = context.watch<ChatProvider>();
    final l10n = AppLocalizations.of(context)!;
    final messages = chatProvider.messages;

    return Scaffold(
      backgroundColor: IosDesignSystem.getSystemGroupedBackground(context),
      appBar: AppBar(
        title: Text(l10n.aiChat),
        backgroundColor: IosDesignSystem.getSystemBackground(context).withValues(alpha: 0.95),
        elevation: 0,
        foregroundColor: IosDesignSystem.getLabelPrimary(context),
        actions: [
          IconButton(
            icon: Icon(_showContextWindow ? Icons.close_rounded : Icons.history_rounded),
            onPressed: () {
              setState(() {
                _showContextWindow = !_showContextWindow;
              });
            },
            tooltip: l10n.contextWindow,
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded),
            onPressed: _showClearChatDialog,
            tooltip: l10n.clearChat,
          ),
        ],
      ),
      body: Column(
        children: [
          // Контекстное окно
          if (_showContextWindow)
            Container(
              padding: const EdgeInsets.all(16),
              color: IosDesignSystem.getSecondarySystemBackground(context),
              child: TextField(
                controller: _contextController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: l10n.enterContext,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(IosDesignSystem.radiusMedium),
                    borderSide: BorderSide(
                      color: IosDesignSystem.getSeparator(context),
                    ),
                  ),
                  filled: true,
                  fillColor: IosDesignSystem.getSystemBackground(context),
                ),
              ),
            ),
          // Сообщения
          Expanded(
            child: messages.isEmpty
                ? _buildEmptyState(l10n)
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: messages.length + (chatProvider.isLoading ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index >= messages.length) {
                        return _buildTypingIndicator(l10n);
                      }
                      final message = messages[index];
                      final isUser = message.role == MessageRole.user;

                      return _buildMessageBubble(message, isUser, l10n);
                    },
                  ),
          ),
          // Индикатор загрузки
          if (chatProvider.isLoading && messages.isEmpty)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: IosDesignSystem.primaryAccent.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(IosDesignSystem.radiusMedium),
                    ),
                    child: const Icon(
                      Icons.smart_toy_rounded,
                      color: IosDesignSystem.primaryAccent,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    l10n.aiTyping,
                    style: TextStyle(
                      color: IosDesignSystem.getLabelSecondary(context),
                      fontSize: IosDesignSystem.fontSizeBody,
                    ),
                  ),
                ],
              ),
            ),
          // Прикрепленные файлы
          if (_attachments.isNotEmpty)
            _buildAttachmentsPreview(),
          // Поле ввода
          _buildInputArea(l10n, chatProvider),
        ],
      ),
    );
  }

  Widget _buildEmptyState(AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: IosDesignSystem.primaryAccent.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(IosDesignSystem.radiusXLarge),
            ),
            child: const Icon(
              Icons.smart_toy_rounded,
              color: IosDesignSystem.primaryAccent,
              size: 40,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            l10n.startConversation,
            style: TextStyle(
              color: IosDesignSystem.getLabelPrimary(context),
              fontSize: IosDesignSystem.fontSizeTitle3,
              fontWeight: IosDesignSystem.weightBold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.startConversation,
            style: TextStyle(
              color: IosDesignSystem.getLabelSecondary(context),
              fontSize: IosDesignSystem.fontSizeBody,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypingIndicator(AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: IosDesignSystem.primaryAccent.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(IosDesignSystem.radiusMedium),
            ),
            child: const Icon(
              Icons.smart_toy_rounded,
              color: IosDesignSystem.primaryAccent,
              size: 20,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: IosDesignSystem.getSecondarySystemBackground(context),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(0),
                topRight: Radius.circular(20),
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTypingDot(0),
                const SizedBox(width: 4),
                _buildTypingDot(1),
                const SizedBox(width: 4),
                _buildTypingDot(2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypingDot(int index) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: Duration(milliseconds: 300 + (index * 150)),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, value * 3),
          child: Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: IosDesignSystem.getLabelTertiary(context),
              shape: BoxShape.circle,
            ),
          ),
        );
      },
    );
  }

  Widget _buildMessageBubble(AiChatMessage message, bool isUser, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUser) ...[
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: IosDesignSystem.primaryAccent.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(IosDesignSystem.radiusMedium),
              ),
              child: const Icon(
                Icons.smart_toy_rounded,
                color: IosDesignSystem.primaryAccent,
                size: 20,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isUser
                    ? IosDesignSystem.primaryAccent
                    : IosDesignSystem.getSecondarySystemBackground(context),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                  bottomLeft: Radius.circular(isUser ? 20 : 0),
                  bottomRight: Radius.circular(isUser ? 0 : 20),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (message.imageUrl != null) ...[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        File(message.imageUrl!),
                        width: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                  Text(
                    message.text,
                    style: TextStyle(
                      color: isUser
                          ? Colors.white
                          : IosDesignSystem.getLabelPrimary(context),
                      fontSize: IosDesignSystem.fontSizeBody,
                    ),
                  ),
                  if (message.analysisResult != null) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: IosDesignSystem.getSystemBackground(context),
                        borderRadius: BorderRadius.circular(IosDesignSystem.radiusMedium),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.analysisResult,
                            style: TextStyle(
                              color: IosDesignSystem.getLabelPrimary(context),
                              fontSize: IosDesignSystem.fontSizeFootnote,
                              fontWeight: IosDesignSystem.weightSemibold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${l10n.documentType}: ${message.analysisResult!['documentType']}',
                            style: TextStyle(
                              color: IosDesignSystem.getLabelSecondary(context),
                              fontSize: IosDesignSystem.fontSizeCaption1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          if (isUser) const SizedBox(width: 8),
        ],
      ),
    );
  }

  Widget _buildAttachmentsPreview() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: IosDesignSystem.getSecondarySystemBackground(context),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: _attachments.map((attachment) {
            return Container(
              margin: const EdgeInsets.only(right: 8),
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(IosDesignSystem.radiusSmall),
                image: attachment.type == AttachmentType.image
                    ? DecorationImage(
                        image: FileImage(File(attachment.path)),
                        fit: BoxFit.cover,
                      )
                    : null,
                color: attachment.type == AttachmentType.file
                    ? IosDesignSystem.primaryAccent.withValues(alpha: 0.15)
                    : null,
              ),
              child: Stack(
                children: [
                  if (attachment.type == AttachmentType.file)
                    Center(
                      child: Icon(
                        Icons.insert_drive_file_rounded,
                        color: IosDesignSystem.primaryAccent,
                        size: 28,
                      ),
                    ),
                  Positioned(
                    top: -6,
                    right: -6,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _attachments.remove(attachment);
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          color: IosDesignSystem.errorRed,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close,
                          size: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildInputArea(AppLocalizations l10n, ChatProvider chatProvider) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: IosDesignSystem.getSystemBackground(context),
        border: Border(
          top: BorderSide(color: IosDesignSystem.getSeparator(context)),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: l10n.askAi,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: IosDesignSystem.getSecondarySystemBackground(context),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                ),
                onSubmitted: (_) => _sendMessage(chatProvider),
              ),
            ),
            const SizedBox(width: 12),
            CircleAvatar(
              backgroundColor: IosDesignSystem.primaryAccent,
              child: IconButton(
                icon: const Icon(Icons.send, color: Colors.white, size: 20),
                onPressed: () => _sendMessage(chatProvider),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: _showAttachmentMenu,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: IosDesignSystem.primaryAccent.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(IosDesignSystem.radiusMedium),
                ),
                child: Icon(
                  Icons.add_circle_outline_rounded,
                  color: IosDesignSystem.primaryAccent,
                  size: 24,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Тип вложения
enum AttachmentType { image, file }

/// Элемент вложения
class AttachmentItem {
  final AttachmentType type;
  final String path;
  final String name;

  AttachmentItem({
    required this.type,
    required this.path,
    required this.name,
  });
}
