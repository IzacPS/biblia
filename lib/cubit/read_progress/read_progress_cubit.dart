import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'read_progress_state.dart';

class ReadProgressCubit extends Cubit<ReadProgressState> {
  ReadProgressCubit() : super(const ReadProgressUpdate(0.0));

  updateProgress(double progress) {
    emit(ReadProgressUpdate(progress));
  }
}
