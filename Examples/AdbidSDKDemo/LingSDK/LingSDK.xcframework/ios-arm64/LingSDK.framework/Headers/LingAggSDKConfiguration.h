//
//  LingAdSDKConfiguration.h
//  LingAggSDK
//
//  Created by youzhadoubao on 2025/9/17.
//

#import <Foundation/Foundation.h>
#import <LingSDK/LingAggPublicDefine.h>

NS_ASSUME_NONNULL_BEGIN

@interface LingAggCustomPermissionController : NSObject
@property (nonatomic, assign, readwrite) BOOL allowPersonalizedAd; //是否允许个性化广告（基于用户画像推荐）
@property (nonatomic, assign, readwrite) BOOL allowLocation;//是否允许获取地理位置信息（用于地域化广告）
@end

typedef NS_ENUM(int, LingAggUserGender) {
    LingAggUserGenderUnknown = 0,  // 未知
    LingAggUserGenderMale    = 1,  // 男
    LingAggUserGenderFemale  = 2,  // 女
};

@interface LingAggSDKConfiguration : NSObject

@property (nonatomic, copy, readonly, class) NSString *sdkVersion;

@property (nonatomic, assign, readwrite) BOOL debugMode;

/// 默认LingAggAdLogLevelNone
@property (nonatomic, assign) LingAggLogLevel logLevel;

@property (nonatomic, copy) NSString *appID; //必传 构建Build对象，入参Sdk初始化参数
@property (nonatomic, copy) NSString *appChannel; //设置应用渠道

@property (nonatomic, copy) NSString *appVersion; //设置应用版本

@property (nonatomic, assign) NSInteger age; //年龄

@property (nonatomic, copy) NSString * userId; //设置用户ID

@property (nonatomic, copy) NSString * IDFA; //广告Id

@property (nonatomic, assign) LingAggUserGender gender; //设置性别（Male表示男性，Female表示女性）

@property (nonatomic, strong) LingAggCustomPermissionController *adCustomController;

@property (nonatomic, assign) BOOL logDirectSend;

+ (instancetype)configuration NS_SWIFT_NAME(configurationShared());

/// Native 广告内置 logo 资源。
+ (NSDictionary *)defaultNativeLogoResource;

@end

NS_ASSUME_NONNULL_END
