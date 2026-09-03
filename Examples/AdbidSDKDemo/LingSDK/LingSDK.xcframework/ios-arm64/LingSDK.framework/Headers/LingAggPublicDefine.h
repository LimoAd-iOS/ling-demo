//
//  LingAggPublicDefine.h
//  LingAggSDK
//
//  Created by youzhadoubao on 2025/9/17.
//

#ifndef LingAdPublicDefine_h
#define LingAdPublicDefine_h

/// 交互类型
typedef NS_ENUM(NSInteger, LingAggAdRedirectionType) {
    LingAggAdRedirectionTypeUnknown,        //unknown type
    LingAggAdRedirectionTypeApp,            //open download page in-app
    LingAggAdRedirectionTypeWeb,            //open webpage in-app
    LingAggAdRedirectionTypeDeepLink,       //open deeplink
    LingAggAdRedirectionTypeAppStore,       //open appstore
    LingAggAdRedirectionTypeSafari,         //open safari
    LingAggAdRedirectionTypeError           //can`t open landing page
};

typedef NS_ENUM(NSInteger, LingAggLogLevel) {
    LingAggLogLevelNone = 0,   // 关闭所有日志
    LingAggLogLevelError,      // 仅错误日志（必须关注）
    LingAggLogLevelWarning,    // 警告日志（潜在问题）
    LingAggLogLevelInfo,       // 普通信息（流程节点）
    LingAggLogLevelDebug       // 调试日志（详细过程，仅Debug模式）
};

// SDK内部日志级别（不对外暴露）
typedef NS_ENUM(NSInteger, LingAggAdInternalLogLevel) {
    LingAggAdInternalLogLevelInternal = 100  // SDK内部调试日志（仅SDK开发时使用）
};

typedef NS_ENUM(NSInteger, LingAggSplashLandingPageType) {
    LingAggSplashLandingPageType_Unknow          = 0, // 未知
    LingAggSplashLandingPageType_lp    = 1, // 落地页（html/h5）
    LingAggSplashLandingPageType_Deeplink      = 2, // deep 类型广告落地页
    LingAggSplashLandingPageType_AppDownload    = 3, // 下载类广告（app下载页）
    LingAggSplashLandingPageType_WeChat          = 4, // 微信小程序/小游戏
    LingAggSplashLandingPageType_UniversalLink   = 5, // UniversalLink 唤起
    LingAggSplashLandingPageType_AppStore        = 6, // ios应用商店下载
};

typedef NS_ENUM(NSInteger, LingAggPlatform) {
    LingAggPlatform_Unknown = 0,
    LingAggPlatform_GDT = 1,
    LingAggPlatform_CSJ = 2,
    LingAggPlatform_Kuaishou = 3,
    LingAggPlatform_Baidu = 4,
    LingAggPlatform_AdMob = 5,
    LingAggPlatform_Pangle = 6,
    LingAggPlatform_AppLovin = 7,
    LingAggPlatform_Unity = 8,
    LingAggPlatform_IronSource = 9,
    LingAggPlatform_Mintegral = 10,
    LingAggPlatform_Vungle = 11,
    LingAggPlatform_Chartboost = 12,
    LingAggPlatform_LM = 13,
    LingAggPlatform_UBX = 14,
    LingAggPlatform_goMore = 15,
    LingAggPlatform_TaKu = 16,
    LingAggPlatform_FunLink = 17, //泛连
    LingAggPlatform_Ezviz = 18, //萤石
    LingAggPlatform_MS = 19, //美数
    LingAggPlatform_Sigmob = 20,
    LingAggPlatform_WM = 21
};

typedef NS_ENUM(NSInteger, LingAggType) {
    LingAggType_Splash              = 1, // 开屏
    LingAggType_Banner              = 2, // 横幅
    LingAggType_Interstitial        = 3, // 插屏
    LingAggType_Feed                = 4, // 信息流
    LingAggType_RewardVideo         = 5, // 激励视频
    LingAggType_Draw                = 6,  // draw
    LingAggType_Unknow              = 7, // 未知
};

static inline NSString *LingAggTypeString(LingAggType type) {
    switch (type) {
        case LingAggType_Splash: return @"splash";
        case LingAggType_Banner: return @"banner";
        case LingAggType_Interstitial: return @"interstitial";
        case LingAggType_Feed: return @"feed";
        case LingAggType_RewardVideo: return @"reward";
        case LingAggType_Draw: return @"draw";
        default: return @"unknown";
    }
}

/// 交互类型 21  摇一摇 (支持开屏、插屏、激励)
/// 22  扭一扭 (支持开屏、插屏、激励 部分设备不支持扭一扭)
/// 23  划一划 (支持开屏、插屏、激励)
/// 24  仅按钮可触发点击(支持开屏、插屏、激励视频)

typedef NS_ENUM(NSInteger, LingAggInteractionType) {
    LingAggInteractionType_AllClick       = 1, // 全屏点击
    LingAggInteractionType_AreaClick      = 24, // 区域点击
    LingAggInteractionType_Shake          = 21, // 摇一摇
    LingAggInteractionType_Slide          = 23, // 滑动
    LingAggInteractionType_SlideClick     = 5, // 划一划且点击
    LingAggInteractionType_Twist          = 22, // 扭一扭
    LingAggInteractionType_None           = 999
};

typedef NS_ENUM(NSInteger, LingAggEventType) {
    LingAggEventType_Impression           = 1, // 曝光
    LingAggEventType_Click                = 2, // 点击
};

typedef NS_ENUM(NSInteger, LingAggBidResult) {
    LingAggBidResult_Win                  = 1, // 竞胜
    LingAggBidResult_Loss                 = 2, // 竞败
    LingAggBidResult_Unknown              = 0, // 未知
};

// MARK: - Error

static NSString *const LingAggSDKErrorDomain = @"com.LingAgg.ad.sdk.error";

typedef NS_ENUM(NSInteger, LingAggErrorCode) {
    LingAggErrorCodeInitFailed = -5204,//广告Sdk未初始化
    LingAggErrorCodeParamMissing = 1010, // 参数缺失（通用参数缺失场景）
    LingAggErrorCodeAdTimeout = 1011, // 广告超时
    LingAggErrorCodeNoAd = 1012, // 无广告
    LingAggLoadErrorCode_ImageNoCache = 1013, // 无图片缓存
    LingAggLoadErrorCode_ImageUrlIsNil = 1014, // 图片URL为空
    LingAggLoadErrorCode_ImageSaveToLocalError = 1016, // 图片保存到本地失败
    LingAggLoadErrorCode_ImageDataWrong = 1017, // 图片数据错误
    LingAggLoadErrorCode_ImageLoadError = 1018, // 图片加载失败
    LingAggLoadErrorCode_VideoUrlIsNil = 1015, // 视频URL为空
    LingAggLoadErrorCode_VideoUrlError = 1019, // 视频URL错误
    LingAggErrorCode_VideoPlayError = 1020, // 视频播放错误
    LingAggErrorCodeAdNotReady = 1021, // 广告未准备好
    LingAggErrorCodeAdShowing = 1022, // 广告正在展示中
};

// 错误描述细化，明确指出是广告ID缺失
static inline NSString *LingAdErrorDescription(LingAggErrorCode code) {
    switch (code) {
        // ... 其他描述
        case LingAggErrorCodeInitFailed:
            return @"SDK 初始化失败";
        case LingAggErrorCodeParamMissing: 
            return @"缺少必要参数";
        case LingAggErrorCodeAdTimeout:
            return @"广告请求超时";
        case LingAggErrorCodeNoAd:
            return @"无广告";
        case LingAggLoadErrorCode_ImageNoCache:
            return @"无图片缓存";
        case LingAggLoadErrorCode_ImageUrlIsNil:
            return @"图片URL为空";
        case LingAggLoadErrorCode_ImageSaveToLocalError:
            return @"图片保存到本地失败";
        case LingAggLoadErrorCode_VideoUrlIsNil:
            return @"视频URL为空";
        case LingAggLoadErrorCode_VideoUrlError:
            return @"视频URL错误";
        case LingAggErrorCode_VideoPlayError:
            return @"视频播放错误";
        case LingAggErrorCodeAdNotReady:
            return @"广告未准备好";
        default: return @"未知错误";
    }
}

#endif /* LingAdPublicDefine_h */
