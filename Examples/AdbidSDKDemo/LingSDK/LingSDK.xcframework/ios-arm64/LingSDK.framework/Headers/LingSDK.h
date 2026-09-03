//
//  LingSDK.h
//  LingSDK（底层 Leadmoad + 聚合 Adbid 合并包）
//
//  宿主请用 LingAgg*（对应原来的 Adbid*，方法名不变：showAd: / showAdToWindow:）。
//  LingRewardVideoAd / LingSplashAd 是底层 Leadmoad，方法名与 Adbid 不完全相同。
//  若只要底层 API，再 #import <LingSDK/LingCoreSDK.h>。
//

#import <Foundation/Foundation.h>

//! Project version number for LingSDK.
FOUNDATION_EXPORT double LingSDKVersionNumber;

//! Project version string for LingSDK.
FOUNDATION_EXPORT const unsigned char LingSDKVersionString[];

#import <LingSDK/LingAdPublicDefine.h>
#import <LingSDK/LingAggPublicDefine.h>

// 聚合层（宿主接入，对应 AdbidSDK）
#import <LingSDK/LingAggSDK.h>

// Adbid 没有 Banner，底层这一支补进默认伞头
#import <LingSDK/LingBannerAd.h>
