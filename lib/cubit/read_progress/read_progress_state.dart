part of 'read_progress_cubit.dart';

abstract class ReadProgressState extends Equatable {
  final double progress;
  const ReadProgressState(this.progress);

  @override
  List<Object> get props => [progress];
}

class ReadProgressUpdate extends ReadProgressState {
  const ReadProgressUpdate(double p) : super(p);
}
