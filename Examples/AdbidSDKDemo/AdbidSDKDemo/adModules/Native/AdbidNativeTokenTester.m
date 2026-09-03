//
//  AdbidNativeTokenTester.m
//  AdbidSDKDemo
//

#import "AdbidNativeTokenTester.h"

static NSString * const AdbidNativeTokenTesterErrorDomain = @"com.leadmoad.ad.sdk.error";
static NSString * const AdbidNativeTokenTesterRequestManagerClassName = @"LMAdRequestManager";
static NSString * const AdbidNativeTokenTesterRequestSelectorName = @"requestAdTestToken:adType:timeout:sdkInfo:success:failure:";
static NSInteger const AdbidNativeTokenTesterAdType = 4;
static NSInteger const AdbidNativeTokenTesterTimeout = 10000;

@interface AdbidNativeTokenTester ()
@property (nonatomic, strong, nullable) id requestManager;
@end

@implementation AdbidNativeTokenTester

- (instancetype)init {
    self = [super init];
    if (self) {
        Class requestManagerClass = NSClassFromString(AdbidNativeTokenTesterRequestManagerClassName);
        if (requestManagerClass) {
            _requestManager = [[requestManagerClass alloc] init];
        }
    }
    return self;
}

- (void)getTokenWithAdId:(NSString *)adId
                 sdkInfo:(NSString *_Nullable)sdkInfo
              completion:(AdbidNativeTokenTestCompletion _Nullable)completion {
    if (adId.length == 0) {
        [self finishWithCompletion:completion success:NO config:nil error:[self errorWithCode:-1 message:@"广告ID为空"]];
        return;
    }

    if (!self.requestManager) {
        [self finishWithCompletion:completion success:NO config:nil error:[self errorWithCode:-1 message:@"LMAdRequestManager不可用"]];
        return;
    }

    SEL selector = NSSelectorFromString(AdbidNativeTokenTesterRequestSelectorName);
    if (![self.requestManager respondsToSelector:selector]) {
        [self finishWithCompletion:completion success:NO config:nil error:[self errorWithCode:-1 message:@"requestAdTestToken接口不可用"]];
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
            [strongSelf finishWithCompletion:completion success:NO config:nil error:[strongSelf errorWithCode:-2 message:@"配置为空"]];
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

    typedef NSString *_Nullable (*AdbidNativeTokenRequestIMP)(id target,
                                                              SEL selector,
                                                              NSString *adId,
                                                              NSInteger adType,
                                                              NSInteger timeout,
                                                              NSString *_Nullable sdkInfo,
                                                              id success,
                                                              id failure);
    AdbidNativeTokenRequestIMP requestImp = (AdbidNativeTokenRequestIMP)[self.requestManager methodForSelector:selector];
    requestImp(self.requestManager,
               selector,
               adId,
               AdbidNativeTokenTesterAdType,
               AdbidNativeTokenTesterTimeout,
               sdkInfo,
               successBlock,
               failureBlock);
}

- (void)finishWithCompletion:(AdbidNativeTokenTestCompletion _Nullable)completion
                     success:(BOOL)success
                      config:(NSDictionary *_Nullable)config
                       error:(NSError *_Nullable)error {
    if (completion) {
        completion(success, config, error);
    }
}

- (NSError *)errorWithCode:(NSInteger)code message:(NSString *)message {
    return [NSError errorWithDomain:AdbidNativeTokenTesterErrorDomain
                               code:code
                           userInfo:@{NSLocalizedDescriptionKey : message ?: @""}];
}

@end
