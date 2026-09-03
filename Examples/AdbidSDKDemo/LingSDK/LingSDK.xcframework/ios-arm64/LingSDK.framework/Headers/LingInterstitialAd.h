//
//  LingInterstitialAd.h
//  LingSDK
//
//  Created by youzhadoubao on 2025/9/17.
//

#import <Foundation/Foundation.h>
#import <LingSDK/LingAdBidLossInfo.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, LingInterstitialAdLandingPageType) {
    LingInterstitialAdLandingPageType_Unknow          = 0, // 未知
    LingInterstitialAdLandingPageType_lp    = 1, // 落地页（html/h5）
    LingInterstitialAdLandingPageType_Deeplink      = 2, // deep 类型广告落地页
    LingInterstitialAdLandingPageType_AppDownload    = 3, // 下载类广告（app下载页）
    LingInterstitialAdLandingPageType_WeChat          = 4, // 微信小程序/小游戏
    LingInterstitialAdLandingPageType_UniversalLink   = 5, // UniversalLink 唤起
    LingInterstitialAdLandingPageType_AppStore        = 6, // ios应用商店下载
};

@class LingInterstitialAd;
@protocol LingInterstitialAdDelegate <NSObject>
@optional
/// 开屏广告素材加载成功
- (void)interstitialAdDidLoad:(LingInterstitialAd *)InterstitialAd;
/// 开屏广告加载失败
- (void)interstitialAd:(LingInterstitialAd *)InterstitialAd didFailToLoadWithError:(NSError *)error;
/// 开屏广告成功展示
- (void)interstitialAdDidShow:(LingInterstitialAd *)InterstitialAd;
/// 开屏广告展示失败
- (void)interstitialAd:(LingInterstitialAd *)InterstitialAd didFailToShowWithError:(NSError *)error;
/// 开屏广告点击
- (void)interstitialAdDidClick:(LingInterstitialAd *)InterstitialAd;
/// 开屏广告关闭
- (void)interstitialAdDidClose:(LingInterstitialAd *)InterstitialAd;
///跳到站外边
- (void)interstitialAdDidJumpToAppOutside:(LingInterstitialAd *)InterstitialAd interactionType:(LingInterstitialAdLandingPageType)interactionType;

@end

@interface LingInterstitialAd : NSObject

@property (nonatomic, weak) id<LingInterstitialAdDelegate> delegate;

// 广告最大请求时长，单位毫秒。默认5000 , 最小500毫秒
@property (nonatomic, assign) NSInteger maxLoadTime;

//是否可以展示
@property (nonatomic, assign, readonly, getter=isAdValid) BOOL valid;

/// 返回广告的eCPM，单位：分
@property (nonatomic, readonly) NSInteger eCPM;

/// 竞价素材信息，字段对齐聚合 material：appName/appPackageName/url/title/desc/jump_url/logo
@property (nonatomic, copy, readonly, nullable) NSDictionary *material;

- (instancetype)initWithSlotId:(NSString *)slotId;

- (instancetype)initWithSlotId:(NSString *)slotId requestId:(NSString*)requestId;

/// 发起拉取广告请求
- (void)loadAd;
/// 通过token拉取广告请求
- (void)loadAdWithToken:(NSString*)token;
/*
 * 必须在主线程调用
 */
- (void)showAd:(UIViewController *)viewController;
/// 竞胜/竞败上报
- (void)winNotice:(NSInteger)price;
- (void)lossNotice:(LingAdBidLossInfo *)info;

@end

NS_ASSUME_NONNULL_END
