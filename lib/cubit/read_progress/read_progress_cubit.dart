import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'read_progress_state.dart';

class ReadProgressCubit extends Cubit<ReadProgressState> {
  ReadProgressCubit() : super(const ReadProgressUpdate(0.0));

  updateProgress(double progress) {
    emit(ReadProgressUpdate(progress));
  }
}
