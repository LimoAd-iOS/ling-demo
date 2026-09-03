//
//  LingAggSplashAd.h
//  LingAggSDK
//
//  Created by youzhadoubao on 2025/9/17.
//

#import <Foundation/Foundation.h>
#import <LingSDK/LingAggBidLossInfo.h>
#import <LingSDK/LingAggAdInfoModel.h>

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@class LingAggSplashAd;
@protocol LingAggSplashAdDelegate <NSObject>
@optional
/// 开屏广告素材加载成功
- (void)splashAdDidLoad:(LingAggSplashAd *)splashAd;
/// 开屏广告加载失败
- (void)splashAd:(LingAggSplashAd *)splashAd didFailToLoadWithError:(NSError *)error;
/// 开屏广告成功展示
- (void)splashAdDidShow:(LingAggSplashAd *)splashAd;
/// 开屏广告展示失败
- (void)splashAd:(LingAggSplashAd *)splashAd didFailToShowWithError:(NSError *)error;
/// 开屏广告点击
- (void)splashAdDidClick:(LingAggSplashAd *)splashAd;
/// 开屏广告关闭
- (void)splashAdDidClose:(LingAggSplashAd *)splashAd;
/// 广告完成转化(关闭落地页)
- (void)splashAdDidFinishConversion:(LingAggSplashAd *)interstitialAd interactionType:(LingAggAdRedirectionType)interactionType;

@end

@interface LingAggSplashAd : NSObject

@property (nonatomic, weak) id<LingAggSplashAdDelegate> delegate;

/// 返回广告的eCPM，单位：分
@property (nonatomic, readonly) NSInteger eCPM;
// 广告信息
@property (nonatomic, readonly) LingAggAdInfoModel* adInfo;
//广告素材
@property (nonatomic, copy, readonly) NSDictionary *material;

@property (nonatomic, strong, nullable) UIViewController *viewController;// 落地页设置

- (instancetype)initWithSlotId:(NSString *)slotId;

- (NSString*)getRequestId;

/// 发起拉取广告请求
- (void)loadAd;
/// 通过Token发起拉取广告请求
- (void)loadAdWithToken:(NSString *)token;

 /// 必须在主线程调用
- (void)showAdToWindow:(UIWindow *)window;

/**
 * 展示开屏，并可附带底部品牌条。
 * @param bottomView 品牌条视图；非空时广告占上方 4/5，底部 1/5 留给该 view。传 nil 等同 showAdToWindow:
 */
- (void)showAdToWindow:(UIWindow *)window bottomView:(nullable UIView *)bottomView;

/// price 二价（即竞败方最高价）
- (void)winNotice:(NSInteger)price;
/// info 竞胜方平台  竞胜方最高价
- (void)lossNotice:(LingAggBidLossInfo *)info;
///是否准备好，准备好了才能加载广告
- (BOOL)isReady;

@end

NS_ASSUME_NONNULL_END
