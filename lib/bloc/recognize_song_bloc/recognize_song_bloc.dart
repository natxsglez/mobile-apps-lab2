import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'recognize_song_event.dart';
part 'recognize_song_state.dart';

class RecognizeSongBloc extends Bloc<RecognizeSongEvent, RecognizeSongState> {
  RecognizeSongBloc() : super(RecognizeSongInitial()) {
    on<RecognizeSongEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
