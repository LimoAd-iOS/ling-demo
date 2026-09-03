//
//  LingSplashAd.h
//  LingSDK
//
//  Created by youzhadoubao on 2025/9/17.
//

#import <Foundation/Foundation.h>
#import <LingSDK/LingAdBidLossInfo.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, LingSplashAdLandingPageType) {
    LingSplashAdLandingPageType_Unknow          = 0, // 未知
    LingSplashAdLandingPageType_lp    = 1, // 落地页（html/h5）
    LingSplashAdLandingPageType_Deeplink      = 2, // deep 类型广告落地页
    LingSplashAdLandingPageType_AppDownload    = 3, // 下载类广告（app下载页）
    LingSplashAdLandingPageType_WeChat          = 4, // 微信小程序/小游戏
    LingSplashAdLandingPageType_UniversalLink   = 5, // UniversalLink 唤起
    LingSplashAdLandingPageType_AppStore        = 6, // ios应用商店下载
};

@class LingSplashAd;
@protocol LingSplashAdDelegate <NSObject>
@optional
/// 开屏广告素材加载成功
- (void)splashAdDidLoad:(LingSplashAd *)splashAd;
/// 开屏广告加载失败
- (void)splashAd:(LingSplashAd *)splashAd didFailToLoadWithError:(NSError *)error;
/// 开屏广告成功展示
- (void)splashAdDidShow:(LingSplashAd *)splashAd;
/// 开屏广告展示失败
- (void)splashAd:(LingSplashAd *)splashAd didFailToShowWithError:(NSError *)error;
/// 开屏广告点击
- (void)splashAdDidClick:(LingSplashAd *)splashAd;
/// 开屏广告关闭
- (void)splashAdDidClose:(LingSplashAd *)splashAd;
///跳到站外边
- (void)splashAdDidJumpToAppOutside:(LingSplashAd *)splashAd interactionType:(LingSplashAdLandingPageType)interactionType;

@end

@interface LingSplashAd : NSObject

@property (nonatomic, weak) id<LingSplashAdDelegate> delegate;

// 广告最大请求时长，单位毫秒。默认5000 , 最小500毫秒
@property (nonatomic, assign) NSInteger maxLoadTime;

//是否可以展示
@property (nonatomic, assign, readonly, getter=isAdValid) BOOL valid;

/// 返回广告的eCPM，单位：分
@property (nonatomic, readonly) NSInteger eCPM;

/// 竞价素材信息，字段对齐聚合 material：appName/appPackageName/url/title/desc/jump_url/logo/ imageUrl videoUrl landingPageUrl
@property (nonatomic, copy, readonly, nullable) NSDictionary *material;

@property (nonatomic, strong, nullable) UIViewController *baseViewController;// 落地页设置

- (instancetype)initWithSlotId:(NSString *)slotId;

- (instancetype)initWithSlotId:(NSString *)slotId requestId:(NSString*)requestId;

/// 发起拉取广告请求
- (void)loadAd;
/// 通过token发起拉取广告请求
- (void)loadAdWithToken:(NSString*)token;

/*
 * 必须在主线程调用
 */
- (void)showAdToWindow:(UIWindow *)window;

/**
 * 展示开屏，并可附带底部品牌条。
 * @param window 展示窗口
 * @param bottomView 品牌条视图；传非空时，底部高度取该 view 的 frame/bounds 高度，上方留给广告。传 nil 则全屏展示，等同 showAdToWindow:
 */
- (void)showAdToWindow:(UIWindow *)window bottomView:(nullable UIView *)bottomView;

/// 竞胜/竞败上报
- (void)winNotice:(NSInteger)price;
- (void)lossNotice:(LingAdBidLossInfo *)info;

@end

NS_ASSUME_NONNULL_END
