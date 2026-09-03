//
//  AdbidInterstitialTokenTester.h
//  AdbidSDKDemo
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^AdbidInterstitialTokenTestCompletion)(BOOL success, NSDictionary *_Nullable config, NSError *_Nullable error);

@interface AdbidInterstitialTokenTester : NSObject

- (void)getTokenWithAdId:(NSString *)adId
                 sdkInfo:(NSString *_Nullable)sdkInfo
              completion:(AdbidInterstitialTokenTestCompletion _Nullable)completion;

@end

NS_ASSUME_NONNULL_END
