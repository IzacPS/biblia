import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'banner_ad_state.dart';

class BannerAdCubit extends Cubit<BannerAdState> {
  BannerAdCubit() : super(BannerAdInitial());

  loaded() {
    emit(BannerAdLoadedState());
  }
}

class BannerAdPageCubit extends BannerAdCubit {}
