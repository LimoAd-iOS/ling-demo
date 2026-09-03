//
//  LingSDK.h
//  LingSDK（底层 Leadmoad + 聚合 Adbid 合并包）
//

#import <Foundation/Foundation.h>

//! Project version number for LingSDK.
FOUNDATION_EXPORT double LingSDKVersionNumber;

//! Project version string for LingSDK.
FOUNDATION_EXPORT const unsigned char LingSDKVersionString[];

// 聚合层（宿主接入）
#import <LingSDK/LingAggSDK.h>

// 底层 Leadmoad
#import <LingSDK/LingCoreSDK.h>
