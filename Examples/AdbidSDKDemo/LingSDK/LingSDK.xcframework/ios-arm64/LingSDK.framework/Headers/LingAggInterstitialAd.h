//
//  LingAggInterstitialAd.h
//  LingAggSDK
//
//  Created by youzhadoubao on 2025/9/17.
//

#import <Foundation/Foundation.h>
#import <LingSDK/LingAggBidLossInfo.h>
#import <LingSDK/LingAggPublicDefine.h>
#import <LingSDK/LingAggAdInfoModel.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@class LingAggInterstitialAd;
@protocol LingAggInterstitialAdDelegate <NSObject>
@optional
/// 广告请求成功
- (void)interstitialAdDidLoad:(LingAggInterstitialAd *)interstitialAd;
/// 广告请求失败
- (void)interstitialAdFailedToLoad:(LingAggInterstitialAd *)interstitialAd withError:(NSError *)error;
/// 开屏广告成功展示
- (void)interstitialAdDidShow:(LingAggInterstitialAd *)interstitialAd;
/// 开屏广告展示失败
- (void)interstitialAdFailedToShow:(LingAggInterstitialAd *)interstitialAd  withError:(NSError *)error;
/// 开屏广告点击
- (void)interstitialAdDidClick:(LingAggInterstitialAd *)interstitialAd;
/// 开屏广告关闭
- (void)interstitialAdDidClose:(LingAggInterstitialAd *)interstitialAd;
/// 广告完成转化(关闭落地页)
- (void)interstitialAdDidFinishConversion:(LingAggInterstitialAd *)interstitialAd interactionType:(LingAggAdRedirectionType)interactionType;

@end

@interface LingAggInterstitialAd : NSObject

@property (nonatomic, weak) id<LingAggInterstitialAdDelegate> delegate;

@property (nonatomic, strong, nullable) UIViewController *viewController;// 落地页设置
/// 返回广告的eCPM，单位：分
@property (nonatomic, readonly) NSInteger eCPM;
// 广告信息
@property (nonatomic, readonly) LingAggAdInfoModel* adInfo;


- (instancetype)initWithSlotId:(NSString *)slotId;

- (NSString*)getRequestId;

/// 发起拉取广告请求
- (void)loadAd;
/**
 * 通过Token加载信息流广告
 */
- (void)loadAdWithToken:(NSString *)token;
/*
 * 必须在主线程调用
 */
- (void)showAd:(UIViewController *)viewController;
/// price 二价（即竞败方最高价）
- (void)winNotice:(NSInteger)price;
/// info 竞胜方平台  竞胜方最高价
- (void)lossNotice:(LingAggBidLossInfo *)info;
///是否准备好，准备好了才能加载广告
- (BOOL)isReady;

@end

NS_ASSUME_NONNULL_END
