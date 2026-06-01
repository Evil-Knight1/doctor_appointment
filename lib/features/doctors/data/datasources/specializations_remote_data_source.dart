import 'dart:convert';
import 'dart:ui';
import 'package:api_cache_manager/api_cache_manager.dart';
import 'package:api_cache_manager/models/cache_db_model.dart';
import 'package:doctor_appointment/core/errors/exceptions.dart';
import 'package:doctor_appointment/core/services/api_service.dart';
import 'package:doctor_appointment/core/services/shared_preferences_helper.dart';
import 'package:doctor_appointment/features/doctors/data/models/specialization_model.dart';

abstract class SpecializationsRemoteDataSource {
  Future<List<SpecializationModel>> getSpecializations();
}

class SpecializationsRemoteDataSourceImpl
    implements SpecializationsRemoteDataSource {
  final ApiService apiService;
  static const String baseCacheKey = "specializations_cache";

  SpecializationsRemoteDataSourceImpl(this.apiService);

  String get _localizedCacheKey {
    String languageCode = SharedPreferencesHelper.getString('language_code') ??
        PlatformDispatcher.instance.locale.languageCode;
    if (!['en', 'ar'].contains(languageCode)) {
      languageCode = 'en';
    }
    return '${baseCacheKey}_$languageCode';
  }

  @override
  Future<List<SpecializationModel>> getSpecializations() async {
    final currentCacheKey = _localizedCacheKey;
    try {
      final response = await apiService.get('/api/Doctor/specializations');

      if (response['success'] != true) {
        final msg = response['message'] as String? ?? 'Failed to load specializations';
        throw ApiException(msg);
      }

      final data = response['data'];
      if (data is! List) throw const ApiException('Unexpected specializations payload');

      // Save to cache
      final cacheModel = APICacheDBModel(
        key: currentCacheKey,
        syncData: jsonEncode(data),
      );
      await APICacheManager().addCacheData(cacheModel);

      return data
          .whereType<Map<String, dynamic>>()
          .map(SpecializationModel.fromJson)
          .toList();
    } catch (e) {
      // Fallback to cache on error/offline
      final isCacheExist = await APICacheManager().isAPICacheKeyExist(currentCacheKey);
      if (isCacheExist) {
        final cacheData = await APICacheManager().getCacheData(currentCacheKey);
        final decodedData = jsonDecode(cacheData.syncData);
        if (decodedData is List) {
          return decodedData
              .whereType<Map<String, dynamic>>()
              .map(SpecializationModel.fromJson)
              .toList();
        }
      }
      rethrow;
    }
  }
}
