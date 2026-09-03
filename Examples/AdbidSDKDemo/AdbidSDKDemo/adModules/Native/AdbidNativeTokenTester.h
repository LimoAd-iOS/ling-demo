//
//  AdbidNativeTokenTester.h
//  AdbidSDKDemo
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^AdbidNativeTokenTestCompletion)(BOOL success, NSDictionary *_Nullable config, NSError *_Nullable error);

@interface AdbidNativeTokenTester : NSObject

- (void)getTokenWithAdId:(NSString *)adId
                 sdkInfo:(NSString *_Nullable)sdkInfo
              completion:(AdbidNativeTokenTestCompletion _Nullable)completion;

@end

NS_ASSUME_NONNULL_END
