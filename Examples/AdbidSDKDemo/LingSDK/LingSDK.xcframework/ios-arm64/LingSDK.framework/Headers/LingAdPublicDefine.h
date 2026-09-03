//
//  LingAdPublicDefine.h
//  LingSDK
//
//  Created by youzhadoubao on 2025/9/17.
//

#ifndef LingAdPublicDefine_h
#define LingAdPublicDefine_h

typedef NS_ENUM(NSInteger, LingAdLogLevel) {
    LingAdLogLevelNone = 0,   // 关闭所有日志
    LingAdLogLevelError,      // 仅错误日志（必须关注）
    LingAdLogLevelWarning,    // 警告日志（潜在问题）
    LingAdLogLevelInfo,       // 普通信息（流程节点）
    LingAdLogLevelDebug       // 调试日志（详细过程，仅Debug模式）
};

// SDK内部日志级别（不对外暴露）
typedef NS_ENUM(NSInteger, LingAdInternalLogLevel) {
    LingAdInternalLogLevelInternal = 100  // SDK内部调试日志（仅SDK开发时使用）
};

typedef NS_ENUM(NSInteger, LingSplashLandingPageType) {
    LingSplashLandingPageType_Unknow          = 0, // 未知 
    LingSplashLandingPageType_lp    = 1, // 落地页（html/h5）
    LingSplashLandingPageType_Deeplink      = 2, // deep 类型广告落地页
    LingSplashLandingPageType_AppDownload    = 3, // 下载类广告（app下载页）
    LingSplashLandingPageType_WeChat          = 4, // 微信小程序/小游戏
    LingSplashLandingPageType_UniversalLink   = 5, // UniversalLink 唤起
    LingSplashLandingPageType_AppStore        = 6, // ios应用商店下载
};

typedef NS_ENUM(NSInteger, LingInterstitialLandingPageType) {
    LingInterstitialLandingPageType_Unknow          = 0, // 未知
    LingInterstitialLandingPageType_lp    = 1, // 落地页（html/h5）
    LingInterstitialLandingPageType_Deeplink      = 2, // deep 类型广告落地页
    LingInterstitialLandingPageType_AppDownload    = 3, // 下载类广告（app下载页）
    LingInterstitialLandingPageType_WeChat          = 4, // 微信小程序/小游戏
    LingInterstitialLandingPageType_UniversalLink   = 5, // UniversalLink 唤起
    LingInterstitialLandingPageType_AppStore        = 6, // ios应用商店下载
};

typedef NS_ENUM(NSInteger, LingAdPlatform) {
    LingAdPlatform_Unknown = 0,
    LingAdPlatform_GDT = 1,
    LingAdPlatform_CSJ = 2,
    LingAdPlatform_Kuaishou = 3,
    LingAdPlatform_Baidu = 4,
    LingAdPlatform_AdMob = 5,
    LingAdPlatform_Pangle = 6,
    LingAdPlatform_AppLovin = 7,
    LingAdPlatform_Unity = 8,
    LingAdPlatform_IronSource = 9,
    LingAdPlatform_Mintegral = 10,
    LingAdPlatform_Vungle = 11,
    LingAdPlatform_Chartboost = 12,
    LingAdPlatform_LM = 13,
    LingAdPlatform_UBX = 14,
    LingAdPlatform_GorMore = 15,
    LingAdPlatform_TaKu = 16,
    LingAdPlatform_FunLink = 17,
    LingAdPlatform_Ezviz = 18, //萤石
    LingAdPlatform_MS = 19, //美数
    LingAdPlatform_Sigmob = 20,
};

typedef NS_ENUM(NSInteger, LingAdType) {
    LingAdType_Splash              = 1, // 开屏
    LingAdType_Banner              = 2, // 横幅
    LingAdType_Interstitial        = 3, // 插屏
    LingAdType_Feed                = 4, // 信息流
    LingAdType_RewardVideo         = 5, // 激励视频
    LingAdType_Draw                = 6, // draw
    LingAdType_Unknow              = 7, // 未知
};

static inline NSString *LingAdTypeString(LingAdType type) {
    switch (type) {
        case LingAdType_Splash: return @"splash";
        case LingAdType_Banner: return @"banner";
        case LingAdType_Interstitial: return @"interstitial";
        case LingAdType_Feed: return @"feed";
        case LingAdType_RewardVideo: return @"reward";
        case LingAdType_Draw: return @"draw";
        default: return @"unknown";
    }
}

/// 交互类型 21  摇一摇 (支持开屏、插屏、激励)
/// 22  扭一扭 (支持开屏、插屏、激励 部分设备不支持扭一扭)
/// 23  划一划 (支持开屏、插屏、激励)
/// 24  仅按钮可触发点击(支持开屏、插屏、激励视频)

typedef NS_ENUM(NSInteger, LingInteractionType) {
    LingInteractionType_AllClick       = 1, // 全屏点击
    LingInteractionType_AreaClick      = 24, // 区域点击
    LingInteractionType_Shake          = 21, // 摇一摇
    LingInteractionType_Slide          = 23, // 滑动
    LingInteractionType_SlideClick     = 5, // 划一划且点击
    LingInteractionType_Twist          = 22, // 扭一扭
    LingInteractionType_None           = 999
};

typedef NS_ENUM(NSInteger, LingEventType) {
    LingEventType_Impression           = 1, // 曝光
    LingEventType_Click                = 2, // 点击
};

// 摇一摇检测模式
// 单向：任一轴单次峰值跨阈值即可触发（更灵敏）
// 双向：窗口内任一轴出现 ≥N 个交替符号峰值（来回往返）才触发
typedef NS_ENUM(NSInteger, LingShakeMode) {
    LingShakeMode_OneWay = 1, // 单向（默认）
    LingShakeMode_TwoWay = 2, // 双向（来回往返）
};

typedef NS_ENUM(NSInteger, LingBidResult) {
    LingBidResult_Win                  = 1, // 竞胜
    LingBidResult_Loss                 = 2, // 竞败
    LingBidResult_Unknown              = 0, // 未知
};

// MARK: - Error

static NSString *const LingAdSDKErrorDomain = @"com.leadmoad.ad.sdk.error";

typedef NS_ENUM(NSInteger, LingAdErrorCode) {
    LingAdErrorCodeInitFailed = 1100,
    LingAdErrorCodeParamMissing = 1010, // 参数缺失（通用参数缺失场景）
    LingAdErrorCodeAdTimeout = 1011, // 广告超时
    LingAdErrorCodeNoAd = 1012, // 无广告
    LingAdLoadErrorCode_ImageNoCache = 1013, // 无图片缓存
    LingAdLoadErrorCode_ImageUrlIsNil = 1014, // 图片URL为空
    LingAdLoadErrorCode_ImageSaveToLocalError = 1016, // 图片保存到本地失败
    LingAdLoadErrorCode_ImageDataWrong = 1017, // 图片数据错误
    LingAdLoadErrorCode_ImageLoadError = 1018, // 图片加载失败
    LingAdLoadErrorCode_VideoUrlIsNil = 1015, // 视频URL为空
    LingAdLoadErrorCode_VideoUrlError = 1019, // 视频URL错误
    LingAdErrorCode_VideoPlayError = 1020, // 视频播放错误
    LingAdErrorCodeAdNotReady = 1021, // 广告未准备好
    LingAdErrorCodeAdShowing = 1022, // 广告正在展示中
    LingAdPrepareErrorCodeAdTimeout = 1023, // 1.2s视频广告准备超时
    LingAdImageErrorCodeAdTimeout = 1024, // 兜底图片准备失败
    LingAdErrorCodeMaterialLoadFailed = 3010, // load 前素材下载失败或参数不合法
    LingAdErrorCodeMaterialShowFailed = 3011, // 展示中素材加载异常（已用本地兜底）
    
};

// 错误描述细化，明确指出是广告ID缺失
static inline NSString *LingAdErrorDescription(LingAdErrorCode code) {
    switch (code) {
        // ... 其他描述
        case LingAdErrorCodeInitFailed:
            return @"SDK 初始化失败";
        case LingAdErrorCodeParamMissing: 
            return @"缺少必要参数";
        case LingAdErrorCodeAdTimeout:
            return @"广告请求超时";
        case LingAdErrorCodeNoAd:
            return @"无广告";
        case LingAdLoadErrorCode_ImageNoCache:
            return @"无图片缓存";
        case LingAdLoadErrorCode_ImageUrlIsNil:
            return @"图片URL为空";
        case LingAdLoadErrorCode_ImageSaveToLocalError:
            return @"图片保存到本地失败";
        case LingAdLoadErrorCode_VideoUrlIsNil:
            return @"视频URL为空";
        case LingAdLoadErrorCode_VideoUrlError:
            return @"视频URL错误";
        case LingAdErrorCode_VideoPlayError:
            return @"视频播放错误";
        case LingAdErrorCodeAdNotReady:
            return @"广告未准备好";
        case LingAdErrorCodeMaterialLoadFailed:
            return @"广告素材下载失败或参数不合法";
        case LingAdErrorCodeMaterialShowFailed:
            return @"广告展示素材加载异常";
        default: return @"未知错误";
    }
}

#endif /* LingAdPublicDefine_h */
