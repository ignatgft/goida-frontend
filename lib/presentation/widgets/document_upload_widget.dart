import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../core/api/api_client.dart';
import '../../core/api/endpoints.dart';
import '../../l10n/app_localizations.dart';
import 'package:dio/dio.dart' as dio;

/// Виджет для загрузки и анализа документов (чеки, квитанции, скриншоты)
class DocumentUploadWidget extends StatefulWidget {
  final String chatId;

  const DocumentUploadWidget({
    super.key,
    required this.chatId,
  });

  @override
  State<DocumentUploadWidget> createState() => _DocumentUploadWidgetState();
}

class _DocumentUploadWidgetState extends State<DocumentUploadWidget> {
  final ImagePicker _picker = ImagePicker();
  bool _isUploading = false;
  DocumentAnalysisResult? _analysisResult;

  Future<void> _pickAndUploadDocument(ImageSource source) async {
    try {
      final XFile? file = await _picker.pickImage(
        source: source,
        maxWidth: 2048,
        maxHeight: 2048,
        imageQuality: 85,
      );

      if (file == null) return;

      setState(() {
        _isUploading = true;
      });

      // Загружаем файл на анализ
      final api = context.read<ApiClient>();
      final response = await api.postMultipart(
        '${Endpoints.aiChatHistory}/chats/${widget.chatId}/messages-with-file',
        files: {'file': await dio.MultipartFile.fromFile(file.path)},
        data: {'message': 'Проанализируй этот документ'},
      );

      if (response.statusCode == 200) {
        setState(() {
          _analysisResult = DocumentAnalysisResult.fromJson(response.data);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUploading = false;
        });
      }
    }
  }

  void _showUploadOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Сделать фото'),
              onTap: () {
                Navigator.pop(context);
                _pickAndUploadDocument(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Выбрать из галереи'),
              onTap: () {
                Navigator.pop(context);
                _pickAndUploadDocument(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.picture_as_pdf),
              title: const Text('Выбрать PDF'),
              onTap: () {
                Navigator.pop(context);
                // Для PDF нужен отдельный picker
                _pickPdfFile();
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickPdfFile() async {
    // В production использовать file_picker пакет
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Выберите файл через файловый менеджер')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Кнопка загрузки
        InkWell(
          onTap: _isUploading ? null : _showUploadOptions,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: theme.dividerColor),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  _isUploading ? Icons.hourglass_empty : Icons.attach_file,
                  color: theme.primaryColor,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _isUploading
                        ? 'Загрузка...'
                        : 'Загрузить чек, квитанцию или скриншот',
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Результаты анализа
        if (_analysisResult != null) ...[
          const SizedBox(height: 16),
          _buildAnalysisResult(theme, l10n),
        ],
      ],
    );
  }

  Widget _buildAnalysisResult(ThemeData theme, AppLocalizations l10n) {
    final result = _analysisResult!;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.primaryColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.primaryColor.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                _getDocumentTypeIcon(result.documentType),
                color: theme.primaryColor,
              ),
              const SizedBox(width: 8),
              Text(
                _getDocumentTypeLabel(l10n, result.documentType),
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildInfoRow(
            theme,
            Icons.store,
            result.merchantName,
          ),
          if (result.documentDate != null)
            _buildInfoRow(
              theme,
              Icons.calendar_today,
              _formatDate(result.documentDate!),
            ),
          _buildInfoRow(
            theme,
            Icons.attach_money,
            '${_formatAmount(result.totalAmount)} ${result.currency}',
            isAmount: true,
          ),
          if (result.warnings.isNotEmpty) ...[
            const SizedBox(height: 12),
            ...result.warnings.map((warning) => Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Row(
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    size: 16,
                    color: Colors.amber,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      warning,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.amber,
                      ),
                    ),
                  ),
                ],
              ),
            )),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    ThemeData theme,
    IconData icon,
    String value, {
    bool isAmount = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: theme.hintColor),
          const SizedBox(width: 8),
          Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: isAmount ? FontWeight.bold : null,
              color: isAmount ? theme.primaryColor : null,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getDocumentTypeIcon(String type) {
    return switch (type) {
      'RECEIPT' => Icons.receipt_long,
      'INVOICE' => Icons.description,
      'BANK_STATEMENT' => Icons.account_balance,
      'TRANSFER' => Icons.swap_horiz,
      _ => Icons.insert_drive_file,
    };
  }

  String _getDocumentTypeLabel(AppLocalizations l10n, String type) {
    return switch (type) {
      'RECEIPT' => 'Чек',
      'INVOICE' => 'Счет/Квитанция',
      'BANK_STATEMENT' => 'Банковская выписка',
      'TRANSFER' => 'Перевод',
      _ => 'Документ',
    };
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }

  String _formatAmount(double amount) {
    return amount.toStringAsFixed(2);
  }
}

/// Модель результата анализа документа
class DocumentAnalysisResult {
  final String documentType;
  final String merchantName;
  final String? merchantAddress;
  final DateTime? documentDate;
  final String currency;
  final double totalAmount;
  final double taxAmount;
  final List<LineItem> lineItems;
  final String confidence;
  final String rawText;
  final List<String> warnings;
  final DocumentMetadata metadata;

  DocumentAnalysisResult({
    required this.documentType,
    required this.merchantName,
    this.merchantAddress,
    this.documentDate,
    required this.currency,
    required this.totalAmount,
    required this.taxAmount,
    required this.lineItems,
    required this.confidence,
    required this.rawText,
    required this.warnings,
    required this.metadata,
  });

  factory DocumentAnalysisResult.fromJson(Map<String, dynamic> json) {
    return DocumentAnalysisResult(
      documentType: json['documentType'] ?? 'UNKNOWN',
      merchantName: json['merchantName'] ?? 'Неизвестно',
      merchantAddress: json['merchantAddress'],
      documentDate: json['documentDate'] != null
          ? DateTime.parse(json['documentDate'])
          : null,
      currency: json['currency'] ?? 'USD',
      totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0.0,
      taxAmount: (json['taxAmount'] as num?)?.toDouble() ?? 0.0,
      lineItems: (json['lineItems'] as List?)
              ?.map((item) => LineItem.fromJson(item))
              .toList() ??
          [],
      confidence: json['confidence'] ?? '0.0',
      rawText: json['rawText'] ?? '',
      warnings: List<String>.from(json['warnings'] ?? []),
      metadata: DocumentMetadata.fromJson(
          json['metadata'] as Map<String, dynamic>? ?? {}),
    );
  }
}

class LineItem {
  final String name;
  final int quantity;
  final double unitPrice;
  final double totalPrice;
  final String? category;

  LineItem({
    required this.name,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
    this.category,
  });

  factory LineItem.fromJson(Map<String, dynamic> json) {
    return LineItem(
      name: json['name'] ?? '',
      quantity: json['quantity'] ?? 1,
      unitPrice: (json['unitPrice'] as num?)?.toDouble() ?? 0.0,
      totalPrice: (json['totalPrice'] as num?)?.toDouble() ?? 0.0,
      category: json['category'],
    );
  }
}

class DocumentMetadata {
  final String fileName;
  final String fileType;
  final int fileSize;
  final int? pageCount;

  DocumentMetadata({
    required this.fileName,
    required this.fileType,
    required this.fileSize,
    this.pageCount,
  });

  factory DocumentMetadata.fromJson(Map<String, dynamic> json) {
    return DocumentMetadata(
      fileName: json['fileName'] ?? '',
      fileType: json['fileType'] ?? '',
      fileSize: json['fileSize'] ?? 0,
      pageCount: json['pageCount'],
    );
  }
}
