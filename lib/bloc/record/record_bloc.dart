import 'dart:async';

import 'package:birds_museum/bloc/record/record_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'record_event.dart';
part 'record_state.dart';

class RecordBloc extends Bloc<RecordEvent, RecordState> {
  final RecordRepository _recordRepository;
  String? recordedSongPath;
  bool isRecording = false;

  RecordBloc({required recordRepository})
      : _recordRepository = recordRepository,
        super(RecordInitialState()) {
    on<StartRecordingEvent>(_recordHandler);
  }

  FutureOr<void> _recordHandler(event, emit) async {
    try {
      emit(RecordGetPermissionsState());
      await _recordRepository.getPermissions();
      isRecording = true;
      emit(RecordingState());
      recordedSongPath = await _recordRepository.recordSong();
      emit(RecordingSuccessfulState());
      isRecording = true;
    } catch (error) {
      emit(RecordErrorState());
    }
  }
}
