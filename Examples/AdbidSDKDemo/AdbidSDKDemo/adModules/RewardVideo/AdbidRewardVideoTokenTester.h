//
//  AdbidRewardVideoTokenTester.h
//  AdbidSDKDemo
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^AdbidRewardVideoTokenTestCompletion)(BOOL success, NSDictionary *_Nullable config, NSError *_Nullable error);

@interface AdbidRewardVideoTokenTester : NSObject

- (void)getTokenWithAdId:(NSString *)adId
                 sdkInfo:(NSString *_Nullable)sdkInfo
              completion:(AdbidRewardVideoTokenTestCompletion _Nullable)completion;

@end

NS_ASSUME_NONNULL_END
