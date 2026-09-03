//
//  LingAggrewardVideoAd.h
//  LingAggSDK
//
//  Created by youzhadoubao on 2025/9/17.
//

#import <Foundation/Foundation.h>
#import <LingSDK/LingAggBidLossInfo.h>
#import <LingSDK/LingAggAdInfoModel.h>

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@class LingAggRewardVideoAd;
@protocol LingAggRewardVideoAdDelegate <NSObject>
@optional
/// 开屏广告素材加载成功
- (void)rewardVideoAdDidLoad:(LingAggRewardVideoAd *)rewardVideoAd;
/// 开屏广告加载失败
- (void)rewardVideoAd:(LingAggRewardVideoAd *)rewardVideoAd didFailToLoadWithError:(NSError *)error;
/// 开屏广告成功展示
- (void)rewardVideoAdDidShow:(LingAggRewardVideoAd *)rewardVideoAd;
/// 开屏广告展示失败
- (void)rewardVideoAd:(LingAggRewardVideoAd *)rewardVideoAd didFailToShowWithError:(NSError *)error;
/// 开屏广告点击
- (void)rewardVideoAdDidClick:(LingAggRewardVideoAd *)rewardVideoAd;

/// 广告完成转化(关闭落地页)
- (void)rewardVideoAdDidFinishConversion:(LingAggRewardVideoAd *)interstitialAd interactionType:(LingAggAdRedirectionType)interactionType;
/// 开屏广告关闭
- (void)rewardVideoAdDidClose:(LingAggRewardVideoAd *)rewardVideoAd;

///激励视频开始播放
- (void)rewardVideoAdDidStartPlay:(LingAggRewardVideoAd *)rewardedVideoAd;

 ///激励视频播放完成或者发生错误时回调
- (void)rewardVideoAdDidEndPlay:(LingAggRewardVideoAd *)rewardedVideoAd withError:(NSError *_Nullable)error;

 ///视频广告播放达到激励条件回调
- (void)rewardVideoAdDidReward:(LingAggRewardVideoAd *)rewardedVideoAd;


@end

@interface LingAggRewardVideoAd : NSObject

@property (nonatomic, weak) id<LingAggRewardVideoAdDelegate> delegate;
/// 返回广告的eCPM，单位：分
@property (nonatomic, readonly) NSInteger eCPM;
// 广告信息
@property (nonatomic, readonly) LingAggAdInfoModel* adInfo;

@property (nonatomic, strong) NSDictionary* LocalExtra;

@property (nonatomic, assign) BOOL shouldMuted;///是否静音，默认是非静音

- (instancetype)initWithSlotId:(NSString *)slotId;

- (NSString*)getRequestId;

/// 发起拉取广告请求
- (void)loadAd;

- (void)loadAdWithToken:(NSString *)token;

/// 必须在主线程调用
- (void)showAd:(UIViewController *)viewController;
/// price 二价（即竞败方最高价）
- (void)winNotice:(NSInteger)price;
/// info 竞胜方平台  竞胜方最高价
- (void)lossNotice:(LingAggBidLossInfo *)info;
///是否准备好
- (BOOL)isReady;

/// 与底层 Leadmoad / Ling 对齐，内部转发 showAd:
- (void)showAdFromViewController:(UIViewController *)viewController;

@end

NS_ASSUME_NONNULL_END
