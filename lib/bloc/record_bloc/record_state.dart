part of 'record_bloc.dart';

abstract class RecordState extends Equatable {
  const RecordState();

  @override
  List<Object> get props => [];
}

class RecordInitialState extends RecordState {}

class RecordGetPermissionsState extends RecordState {}

class RecordingState extends RecordState {}

class RecordingSuccessfulState extends RecordState {}

class RecordErrorState extends RecordState {}
