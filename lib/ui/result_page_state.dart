import 'package:windows_app/models/shingle_result_model.dart';

abstract class ResultPageState {}

class ResultPageInitial extends ResultPageState {}

class ResultPageLoading extends ResultPageState {}

class ResultPageSuccess extends ResultPageState {
  final List<ShingleResult> result;
  final double filterResult;

  ResultPageSuccess(this.result, this.filterResult);
}

class ResultPageError extends ResultPageState {
  final String errorMessage;

  ResultPageError(this.errorMessage);
}
