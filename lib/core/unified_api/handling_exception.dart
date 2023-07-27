import 'dart:async';
import 'dart:developer';
import 'package:dartz/dartz.dart';
import '../error/exception.dart';
import '../error/failures.dart';

class HandlingExceptionManager<T> {
  static Future<Either<Failure, T>> wrapHandling<T>(
      {required Future<Right<Failure, T>> Function() tryCall}) async {
    try {
      final right = await tryCall();
      return right;
    } on ServerException catch (_) {
      log("<< ServerException >> ");
      return Left(
          ServerFailure(message: 'حدث خطأ ما بالسيرفر يرجى المحاولة لاحقا'));
    } on ApiException catch (e) {
      log("<< ApiException >> ");
      return Left(ApiFailure(message: e.message));
    } on TimeoutException catch (_) {
      log("<< TimeoutException >> ");
      return Left(TimeOutFailure(
          message: 'يرجي التحثث من الإنترنت والمحاولة مرة أخرى'));
    } catch (e) {
      log("<< catch >> error is $e");
      return Left(
          ServerFailure(message: 'حدث خطأ غير متوقع يرجى المحاولة لاحقا'));
    }
  }
}
