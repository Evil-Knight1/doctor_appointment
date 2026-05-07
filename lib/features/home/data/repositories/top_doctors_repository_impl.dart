import 'package:dio/dio.dart';
import 'package:doctor_appointment/core/errors/exceptions.dart';
import 'package:doctor_appointment/core/errors/failures.dart';
import 'package:doctor_appointment/core/utils/result.dart';
import 'package:doctor_appointment/features/doctors/domain/entities/specialization.dart';
import 'package:doctor_appointment/features/home/data/datasource/home_remot_data_soruce.dart';
import 'package:doctor_appointment/features/home/domain/entities/top_doctors.dart';
import 'package:doctor_appointment/features/home/domain/repositories/top_doctors_repository.dart';

class TopDoctorsRepositoryImpl implements TopDoctorsRepository {
  final HomeRemotDataSource remoteDataSource;

  TopDoctorsRepositoryImpl(this.remoteDataSource);

  @override
  Future<Result<TopDoctors>> getTopDoctors({int? count}) async {
    try {
      final response = await remoteDataSource.getTopDoctors(count: count);
      return Result.success(response);
    } on ApiException catch (exception) {
      return Result.failure(
        ServerFailure(exception.message, statusCode: exception.statusCode),
      );
    } on DioException catch (exception) {
      return Result.failure(_mapDioFailure(exception));
    } catch (_) {
      return Result.failure(const UnknownFailure('Unexpected error occurred'));
    }
  }

  @override
  Future<Result<TopDoctors>> getDoctorsBySpecialization(
    int specializationId, {
    int? count,
  }) async {
    try {
      final response = await remoteDataSource.getDoctorsBySpecialization(
        specializationId,
        count: count,
      );
      return Result.success(response);
    } on ApiException catch (exception) {
      return Result.failure(
        ServerFailure(exception.message, statusCode: exception.statusCode),
      );
    } on DioException catch (exception) {
      return Result.failure(_mapDioFailure(exception));
    } catch (_) {
      return Result.failure(const UnknownFailure('Unexpected error occurred'));
    }
  }

  @override
  Future<Result<List<Specialization>>> getSpecializations() async {
    try {
      final response = await remoteDataSource.getSpecializations();
      return Result.success(response);
    } on ApiException catch (exception) {
      return Result.failure(
        ServerFailure(exception.message, statusCode: exception.statusCode),
      );
    } on DioException catch (exception) {
      return Result.failure(_mapDioFailure(exception));
    } catch (_) {
      return Result.failure(const UnknownFailure('Unexpected error occurred'));
    }
  }

  Failure _mapDioFailure(DioException exception) {
    if (exception.type == DioExceptionType.connectionTimeout ||
        exception.type == DioExceptionType.sendTimeout ||
        exception.type == DioExceptionType.receiveTimeout ||
        exception.type == DioExceptionType.connectionError) {
      return const NetworkFailure('Please check your internet connection');
    }

    final response = exception.response;
    final statusCode = response?.statusCode;
    final message =
        _extractMessage(response?.data) ??
        exception.message ??
        'Request failed';

    return ServerFailure(message, statusCode: statusCode);
  }

  String? _extractMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      final message = data['message'];
      if (message is String && message.trim().isNotEmpty) {
        return message;
      }
      final errors = data['errors'];
      if (errors is List && errors.isNotEmpty) {
        return errors.map((e) => e.toString()).join(', ');
      }
    }
    return null;
  }
}
