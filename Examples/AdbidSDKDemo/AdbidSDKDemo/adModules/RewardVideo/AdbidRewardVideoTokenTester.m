//
//  AdbidRewardVideoTokenTester.m
//  AdbidSDKDemo
//

#import "AdbidRewardVideoTokenTester.h"

static NSString * const AdbidRewardVideoTokenTesterErrorDomain = @"com.leadmoad.ad.sdk.error";
static NSString * const AdbidRewardVideoTokenTesterRequestManagerClassName = @"LMAdRequestManager";
static NSString * const AdbidRewardVideoTokenTesterRequestSelectorName = @"requestAdTestToken:adType:timeout:sdkInfo:success:failure:";
static NSInteger const AdbidRewardVideoTokenTesterAdType = 5;
static NSInteger const AdbidRewardVideoTokenTesterTimeout = 10000;

@interface AdbidRewardVideoTokenTester ()

@property (nonatomic, strong, nullable) id requestManager;

@end


@implementation AdbidRewardVideoTokenTester

- (instancetype)init {
    self = [super init];
    if (self) {
        Class requestManagerClass = NSClassFromString(AdbidRewardVideoTokenTesterRequestManagerClassName);
        if (requestManagerClass) {
            _requestManager = [[requestManagerClass alloc] init];
        }
    }
    return self;
}

- (void)getTokenWithAdId:(NSString *)adId
                 sdkInfo:(NSString *_Nullable)sdkInfo
              completion:(AdbidRewardVideoTokenTestCompletion _Nullable)completion {
    if (adId.length == 0) {
        [self finishWithCompletion:completion
                           success:NO
                            config:nil
                             error:[self errorWithCode:-1 message:@"广告ID为空"]];
        return;
    }

    if (!self.requestManager) {
        [self finishWithCompletion:completion
                           success:NO
                            config:nil
                             error:[self errorWithCode:-1 message:@"LMAdRequestManager不可用"]];
        return;
    }

    SEL selector = NSSelectorFromString(AdbidRewardVideoTokenTesterRequestSelectorName);
    if (![self.requestManager respondsToSelector:selector]) {
        [self finishWithCompletion:completion
                           success:NO
                            config:nil
                             error:[self errorWithCode:-1 message:@"requestAdTestToken接口不可用"]];
        return;
    }

    __weak typeof(self) weakSelf = self;
    void (^successBlock)(id responseObject) = [^(id responseObject) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) {
            return;
        }

        NSDictionary *dict = (NSDictionary *)responseObject;
        if (![dict isKindOfClass:[NSDictionary class]] || dict.count == 0) {
            [strongSelf finishWithCompletion:completion
                                     success:NO
                                      config:nil
                                       error:[strongSelf errorWithCode:-2 message:@"配置为空"]];
            return;
        }

        [strongSelf finishWithCompletion:completion success:YES config:dict error:nil];
    } copy];

    void (^failureBlock)(NSError *error) = [^(NSError *error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) {
            return;
        }
        [strongSelf finishWithCompletion:completion success:NO config:nil error:error];
    } copy];

    typedef NSString *_Nullable (*AdbidRewardVideoTokenRequestIMP)(id target,
                                                                   SEL selector,
                                                                   NSString *adId,
                                                                   NSInteger adType,
                                                                   NSInteger timeout,
                                                                   NSString *_Nullable sdkInfo,
                                                                   id success,
                                                                   id failure);
    AdbidRewardVideoTokenRequestIMP requestImp = (AdbidRewardVideoTokenRequestIMP)[self.requestManager methodForSelector:selector];
    requestImp(self.requestManager,
               selector,
               adId,
               AdbidRewardVideoTokenTesterAdType,
               AdbidRewardVideoTokenTesterTimeout,
               sdkInfo,
               successBlock,
               failureBlock);
}

- (void)finishWithCompletion:(AdbidRewardVideoTokenTestCompletion _Nullable)completion
                     success:(BOOL)success
                      config:(NSDictionary *_Nullable)config
                       error:(NSError *_Nullable)error {
    if (completion) {
        completion(success, config, error);
    }
}

- (NSError *)errorWithCode:(NSInteger)code message:(NSString *)message {
    return [NSError errorWithDomain:AdbidRewardVideoTokenTesterErrorDomain
                               code:code
                           userInfo:@{NSLocalizedDescriptionKey : message ?: @""}];
}

@end
