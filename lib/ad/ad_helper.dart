import 'package:flutter/cupertino.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class BannerAdInfo {
  BannerAd? bannerAd;
  bool isReady = false;
  void Function() onReady = () {};

  BannerAdInfo() {
    bannerAd = BannerAd(
      size: AdSize.banner,
      adUnitId: AdHelper.bannerAdUnitId,
      request: const AdRequest(),
      listener: BannerAdListener(onAdLoaded: (_) {
        isReady = true;
        onReady();
      }, onAdFailedToLoad: (ad, err) {
        isReady = false;

        ad.dispose();
      }),
    );
  }
  Future<void> load() {
    return bannerAd!.load();
  }

  Future<void> dispose() {
    return bannerAd!.dispose();
  }

  setOnReadyCallback(void Function() onReadyC) {
    onReady = onReadyC;
  }
}

class AdHelper {
  static int current_banner = 0;
  static BannerAdInfo? mainMenuBannerAd;
  static BannerAdInfo? pageBannerList;
  static InterstitialAd? interstitialAd;
  static bool interstitialAdReady = false;
  static String get bannerAdUnitId {
    return 'ca-app-pub-3940256099942544/6300978111';
    //TEST
    //return 'ca-app-pub-6091645546775983/9623967670';
  }

  static String get interstitialAdUnitId {
    //TEST
    return 'ca-app-pub-3940256099942544/1033173712';
    //return 'ca-app-pub-6091645546775983/9887460048';
  }

  static void init() {
    mainMenuBannerAd = BannerAdInfo();
    pageBannerList = BannerAdInfo();
  }

  static loadMenuBanner() {
    //bannerAd?.dispose();
    return mainMenuBannerAd?.load();
    //mainMenuBannerAd?.load();
  }

  static loadPageBanner() {
    return pageBannerList?.load();
  }
  // static BannerAdInfo? getCurrentPageBannerAndNext() {
  //   if (current_banner == 6) current_banner = 0;
  //   return pageBannerList[current_banner++];
  // }

  static Future<BannerAdInfo?> loadAndGetNextPageBanner(
      void Function() isReady) async {
    pageBannerList?.setOnReadyCallback(isReady);
    await pageBannerList?.load();
    return pageBannerList;
  }

  // static void startInterstitialAd() {
  //   InterstitialAd.load(
  //     adUnitId: AdHelper.interstitialAdUnitId,
  //     request: const AdRequest(),
  //     adLoadCallback: InterstitialAdLoadCallback(onAdLoaded: (ad) {
  //       interstitialAd = ad;

  //       ad.fullScreenContentCallback =
  //           FullScreenContentCallback(onAdDismissedFullScreenContent: (ad) {});
  //       interstitialAdReady = true;
  //     }, onAdFailedToLoad: (err) {
  //       interstitialAdReady = false;
  //     }),
  //   );
  // }
}
