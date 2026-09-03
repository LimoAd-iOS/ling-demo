//
//  LingNativeAd.h
//  LeadmoadAdSDK
//
//  Created by youzhadoubao on 2025/9/25.
//

#import <Foundation/Foundation.h>
#import <LingSDK/LingAggNativeObj.h>
#import <UIKit/UIKit.h>
#import <LingSDK/LingAggBidLossInfo.h>
#import <LingSDK/LingAggAdInfoModel.h>
NS_ASSUME_NONNULL_BEGIN

@class LingAggNativeAd;

@protocol LingAggNativeAdDelegate <NSObject>
/// 广告加载成功
- (void)nativeAdDidLoad:(LingAggNativeAd *)nativeAd;
/// 广告加载失败
- (void)nativeAd:(LingAggNativeAd *)nativeAd didFailToLoadWithError:(NSError *)error;

@optional

/**
 当自渲染广告被点击时调用
 */
- (void)nativeAdViewDidClick:(LingAggNativeAd *)nativeAd;

/**
 广告曝光回调
 */
- (void)nativeAdViewDidExpose:(LingAggNativeAd *)nativeAd;

@end

@interface LingAggNativeAd : NSObject

/**
 广告素材
 */
@property (atomic, strong, readonly, nullable) LingAggNativeObj *data;

/// 广告对象，在nativeAdViewDidClick回调后有值
@property (nonatomic, weak) id<LingAggNativeAdDelegate> delegate;
/**
 必传.
 处理广告点击事件的根视图控制器。
 */
@property (nonatomic, weak, readwrite) UIViewController *rootViewController;

/// 客户显式设置时覆盖渠道云端/SDK默认值；不设置则保留渠道默认值。
@property (nonatomic, assign) BOOL shouldMuted;

@property (nonatomic, assign, readonly) NSInteger eCPM;

// 广告信息
@property (nonatomic, readonly) LingAggAdInfoModel* adInfo;

- (instancetype)initWithSlotId:(NSString *)slotId;

/**
 * 加载信息流广告
 */
- (void)loadAd;
/**
 * 通过Token加载信息流广告
 */
- (void)loadAdWithToken:(NSString *)token;
/**
 带额外配置的渲染（模版广告通过 extraConfig 透传 templateView / ADFrame /
 mediaViewFrame / sizeToFit / adLogoFrame / adOptionsFrame / networkLogoFrame /
 videoPlayType）
 自渲染时 extraConfig 可为 nil，行为等同 3 参重载

 extraConfig 已知 key：
   - templateView     UIView*              模版广告的渲染容器，已挂载时保持原布局，未挂载时注册入口按容器大小兜底挂载，adapter/Taku 将真实模版视图插入其中
   - mediaView        LingAggNativeMediaView* App 在注册前已完成布局的视频壳视图
   - adFrame           NSValue<CGRect>   ATNativeADConfiguration.ADFrame
   - mediaViewFrame    NSValue<CGRect>   ATNativeADConfiguration.mediaViewFrame
   - sizeToFit         NSNumber<BOOL>    ATNativeADConfiguration.sizeToFit
   - adLogoFrame       NSValue<CGRect>   context kATNativeAdConfigurationContextAdLogoViewFrameKey
   - adOptionsFrame    NSValue<CGRect>   context kATNativeAdConfigurationContextAdOptionsViewFrameKey
   - networkLogoFrame  NSValue<CGRect>   context kATNativeAdConfigurationContextNetworkLogoViewFrameKey
   - videoPlayType     NSNumber<NSInt>   ATNativeADConfiguration.videoPlayType
 */
- (void)registerContainer:(__kindof UIView *)containerView
            mainImageView:(__kindof UIImageView *)mainImageView
       withClickableViews:(NSArray<__kindof UIView *> *_Nullable)clickableViews
              extraConfig:(nullable NSDictionary *)extraConfig;

/**
 注册点击事件
 @param containerView 原生广告的容器视图。必传
 @param mainImageView 原生广告的大图容器
 @param clickableViews 可点击的视图数组。可选
 */
- (void)registerContainer:(__kindof UIView *)containerView mainImageView:(__kindof UIImageView *) mainImageView
       withClickableViews:(NSArray<__kindof UIView *> *_Nullable)clickableViews;
/// price 二价（即竞败方最高价）
- (void)winNotice:(NSInteger)price;
/// info 竞胜方平台  竞胜方最高价
- (void)lossNotice:(LingAggBidLossInfo *)info;
///是否准备好，准备好了才能加载广告
- (BOOL)isReady;

@end

NS_ASSUME_NONNULL_END
