//
//  LingAdSDKConfiguration.h
//  LingSDK
//
//  Created by youzhadoubao on 2025/9/17.
//

#import <Foundation/Foundation.h>
#import <LingSDK/LingAdPublicDefine.h>

NS_ASSUME_NONNULL_BEGIN

@interface LingAdSDKConfiguration : NSObject

@property (nonatomic, copy, readonly, class) NSString *sdkVersion;

@property (nonatomic, assign, readwrite) BOOL debugMode;

/// 默认LMAdLogLevelNone
@property (nonatomic, assign) LingAdLogLevel logLevel;
/// 必传
@property (nonatomic, copy) NSString * appID;
/// 可选
@property (nonatomic, copy) NSString * userId;
@property (nonatomic, copy) NSString * idfa;
/// 可选
@property (nonatomic, strong) NSNumber* latitude;
/// 可选
@property (nonatomic, strong) NSNumber* longitude;

@property (nonatomic, assign) BOOL logDirectSend;

@property (nonatomic, copy) NSString *configNativeUrl;

+ (instancetype)configuration;

/// 与聚合层 IDFA 对齐
@property (nonatomic, copy) NSString *IDFA;

@end

NS_ASSUME_NONNULL_END
