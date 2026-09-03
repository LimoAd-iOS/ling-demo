//
//  LingRewardVideoAd.h
//  LingSDK
//
//  Created by mark zhang  on 2025/10/3.
//

#import <Foundation/Foundation.h>
#import <LingSDK/LingAdBidLossInfo.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class LingRewardVideoAd;

@protocol LingRewardVideoAdDelegate <NSObject>

@optional
/// 激励视频广告加载成功
- (void)rewardVideoAdDidLoad:(LingRewardVideoAd *)rewardVideoAd;

/// 激励视频广告加载失败
- (void)rewardVideoAd:(LingRewardVideoAd *)rewardVideoAd didFailToLoadWithError:(NSError *)error;

/// 激励视频广告开始展示
- (void)rewardVideoAdDidShow:(LingRewardVideoAd *)rewardVideoAd;

/// 激励视频广告展示失败
- (void)rewardVideoAd:(LingRewardVideoAd *)rewardVideoAd didFailToShowWithError:(NSError *)error;

/// 激励视频广告被点击
- (void)rewardVideoAdDidClick:(LingRewardVideoAd *)rewardVideoAd;

/// 广告完成转化(关闭落地页)
- (void)rewardedVideoAdDidFinishConversion:(LingRewardVideoAd *)interstitialAd interactionType:(LingSplashLandingPageType)interactionType;

///// 激励视频广告关闭
- (void)rewardVideoAdDidClose:(LingRewardVideoAd *)rewardVideoAd;
/// 激励视频开始播发
- (void)rewardedVideoAdStartPlay:(LingRewardVideoAd*)rewardVideoAd;
///激励视频播放完成或者发生错误时回调
- (void)rewardedVideoAdDidPlayFinish:(LingRewardVideoAd *)rewardedVideoAd withError:(NSError *_Nullable)error;
/// 激励视频播放完成，用户获得奖励
- (void)rewardVideoAdDidReward:(LingRewardVideoAd *)rewardVideoAd;

@end

@interface LingRewardVideoAd : NSObject

/// 代理对象
@property (nonatomic, weak) id<LingRewardVideoAdDelegate> delegate;

/// 广告最大请求时长，单位毫秒。默认5000，最小500毫秒
@property (nonatomic, assign) NSInteger maxLoadTime;

/// 是否静音播放，默认 YES
@property (nonatomic, assign) BOOL shouldMuted;

/// 是否已加载完成
@property (nonatomic, assign, readonly) BOOL isAdLoaded;

/// 是否正在展示
@property (nonatomic, assign, readonly) BOOL isAdShowing;

/// 返回广告的eCPM，单位：分
@property (nonatomic, assign, readonly) NSInteger eCPM;

/// 竞价素材信息，字段对齐聚合 material：appName/appPackageName/url/title/desc/jump_url/logo
@property (nonatomic, copy, readonly, nullable) NSDictionary *material;

/// 初始化激励视频广告
/// @param slotId 广告位ID
- (instancetype)initWithSlotId:(NSString *)slotId;

- (instancetype)initWithSlotId:(NSString *)slotId requestId:(NSString*)requestId;

/// 加载激励视频广告
- (void)loadAd;
/// 通过token加载激励视频广告
- (void)loadAdWithToken:(NSString*)token;

/// 展示激励视频广告
/// @param viewController 用于展示广告的视图控制器
- (void)showAdFromViewController:(UIViewController *)viewController;

/// 检查广告是否可以展示
- (BOOL)isReady;

// 竞胜/竞败上报
- (void)winNotice:(NSInteger)price;
- (void)lossNotice:(LingAdBidLossInfo *)info;

@end

NS_ASSUME_NONNULL_END
