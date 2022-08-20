part of 'banner_ad_cubit.dart';

abstract class BannerAdState extends Equatable {
  const BannerAdState();

  @override
  List<Object> get props => [];
}

class BannerAdInitial extends BannerAdState {}

class BannerAdLoadingState extends BannerAdState {}

class BannerAdLoadedState extends BannerAdState {}
