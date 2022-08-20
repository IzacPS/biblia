import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'banner_ad_state.dart';

class BannerAdCubit extends Cubit<BannerAdState> {
  BannerAdCubit() : super(BannerAdInitial());

  loaded() {
    emit(BannerAdLoadedState());
  }
}

class BannerAdPageCubit extends BannerAdCubit {}
