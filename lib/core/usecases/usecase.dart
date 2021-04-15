import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:estudo_clean_architecture/core/error/failures.dart';
import 'package:estudo_clean_architecture/features/number_trivia/domain/entities/number_trivia.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, NumberTrivia>> call(Params params);
}

class NoParams extends Equatable {}
