import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/api/api_client.dart';
import '../../core/api/endpoints.dart';
import '../../data/models/receipt_scan.dart';
import '../../l10n/app_localizations.dart';

class ReceiptProvider extends ChangeNotifier {
  final ApiClient api;
  final ImagePicker _picker = ImagePicker();

  bool _isProcessing = false;
  ReceiptScanResult? _lastScan;

  bool get isProcessing => _isProcessing;
  ReceiptScanResult? get lastScan => _lastScan;

  ReceiptProvider(this.api);

  Future<ReceiptScanResult?> scanAndUploadReceipt(BuildContext context) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
      );

      if (image == null) {
        return null;
      }

      _isProcessing = true;
      notifyListeners();

      final fileName = image.name;
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(image.path, filename: fileName),
      });

      final response = await api.dio.post(
        Endpoints.processReceipt,
        data: formData,
      );

      final raw = response.data as Map<String, dynamic>? ?? const {};
      final data =
          raw['receipt'] as Map<String, dynamic>? ??
          raw['data'] as Map<String, dynamic>? ??
          raw;

      if (data.isEmpty) {
        return null;
      }

      _lastScan = ReceiptScanResult.fromJson(data, sourceImagePath: image.path);
      notifyListeners();
      return _lastScan;
    } catch (e) {
      debugPrint("OCR Upload Error: $e");
      if (context.mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.receiptProcessingFailed)));
      }
      return null;
    } finally {
      _isProcessing = false;
      notifyListeners();
    }
  }

  void clear() {
    _lastScan = null;
    _isProcessing = false;
    notifyListeners();
  }
}
