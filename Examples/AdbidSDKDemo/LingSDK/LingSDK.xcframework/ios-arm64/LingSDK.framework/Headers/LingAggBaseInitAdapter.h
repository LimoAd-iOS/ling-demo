//
//  LingAggBaseInitAdapter.h
//  LingAggSDK
//
//  Created by chaizhiyong on 2026/5/2.
//

#import <Foundation/Foundation.h>
#import <LingSDK/LingAggAdInitArgument.h>
NS_ASSUME_NONNULL_BEGIN

@interface LingAggBaseInitAdapter : NSObject


- (void)initWithInitArgument:(LingAggAdInitArgument *)adInitArgument complete:(void (^__nullable)(BOOL success, NSError *_Nullable error))completion;

+ (nullable NSString *)sdkVersion;

+ (nullable NSString *)adapterVersion;

+ (nullable NSString *)adapterProtocolVersion;

@end

NS_ASSUME_NONNULL_END
