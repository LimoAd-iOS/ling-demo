//
//  Header.h
//  LingAggSDK
//
//  Created by chaizhiyong on 2026/1/21.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <LingSDK/LingAggBidLossInfo.h>

NS_ASSUME_NONNULL_BEGIN

/// 开屏广告适配层代理（回调给LingAggSplashAd）
@protocol LingAggInterstitialAdapterDelegate <NSObject>
@optional
/// 素材加载成功 extra 扩展数据
- (void)adapterDidLoadInterstitialAd:(id)adapter extra:(NSDictionary*)extra;
/// 加载失败
- (void)adapter:(id)adapter didFailToLoadInterstitialAdWithError:(NSError *)error;
/// 展示成功
- (void)adapterDidShowInterstitialAd:(id)adapter;
/// 展示失败
- (void)adapter:(id)adapter didFailToShowInterstitialAdWithError:(NSError *)error;
/// 广告点击
- (void)adapterDidClickInterstitialAd:(id)adapter;
/// 广告关闭
- (void)adapterDidCloseInterstitialAd:(id)adapter;
/// 广告完成转化(关闭落地页)
- (void)adapterDidFinishConversion:(id)interstitialAd interactionType:(int)interactionType;

@end

/// 开屏广告适配层抽象协议
@protocol LingAggInterstitialAdapterProtocol <NSObject>

/// 适配层代理（回调至LingAggSplashAd）
@property (nonatomic, weak) id<LingAggInterstitialAdapterDelegate> adapterDelegate;
/// 广告最大加载时长（毫秒）
@property (nonatomic, assign) NSInteger maxLoadTime;
/// 广告eCPM（分）
@property (nonatomic, readonly) NSInteger eCPM;
@property (nonatomic, assign) BOOL shouldMuted;///是否静音，默认是静音
/// 广告位ID（不同广告商的ID，如穿山甲的slotID、广点通的placementID）
@property (nonatomic, copy, readonly) NSString *slotId;
@property (nonatomic, copy, readonly) NSString* currentRequestId;

- (instancetype)initWithSlotId:(NSString *)slotId requestId:(NSString*)requestId;
/// 加载广告
- (void)loadAd;

- (void)loadAdWithToken:(NSString *)token;
/// 展示广告（主线程调用）
- (void)showAd:(UIViewController *)viewController;

/// 移除广告视图
- (void)removeInterstitialView;

/// 竞胜上报
- (void)winNotice:(NSInteger)price;

/// 竞败上报
- (void)lossNotice:(LingAggBidLossInfo *)info;

@end

NS_ASSUME_NONNULL_END
