//
//  AppConfig.m
//  AdbidSDKDemo
//
//  Created by chaizhiyong on 2026/4/9.
//

#import "AppConfig.h"

NSNotificationName const AppConfigDidChangeNotification = @"AppConfigDidChangeNotification";

@implementation AppConfig
 
static NSString *const kEnvironmentKey = @"kAppEnvironmentKey";

static NSString *const kAppOpenAdSwitchKey = @"kAppOpenAdSwitchKey";

static NSString *const kHotAppOpenAdSwitchKey = @"kHotAppOpenAdSwitchKey";

static NSString *const kSelectedPlatformsKeyPrefix = @"kSelectedPlatformsKey";

static NSString *const kLegacySelectedPlatformsKey = @"flatform";

#pragma mark - 单例
+ (instancetype)shared {
    static AppConfig *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSUserDefaults* ua = [NSUserDefaults standardUserDefaults];
        _isOpenAppOpenAd = [ua boolForKey:kAppOpenAdSwitchKey];
        _isOpenHotAppOpenAd =  [ua boolForKey:kHotAppOpenAdSwitchKey];
    }
    return self;
}

- (void)setIsOpenAppOpenAd:(BOOL)isOpenAppOpenAd{
    _isOpenAppOpenAd = isOpenAppOpenAd;
    NSUserDefaults* ua = [NSUserDefaults standardUserDefaults];
    [ua setBool:isOpenAppOpenAd forKey:kAppOpenAdSwitchKey];
    [ua synchronize];
}

- (void)setIsOpenHotAppOpenAd:(BOOL)isOpenHotAppOpenAd{
    _isOpenHotAppOpenAd = isOpenHotAppOpenAd;
    NSUserDefaults* ua = [NSUserDefaults standardUserDefaults];
    [ua setBool:isOpenHotAppOpenAd forKey:kHotAppOpenAdSwitchKey];
    [ua synchronize];
}

#pragma mark - 保存环境
+ (void)saveEnvironment:(EnvironmentType)env {
    env = EnvironmentType_Test_10004;
    [[NSUserDefaults standardUserDefaults] setInteger:env forKey:kEnvironmentKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:AppConfigDidChangeNotification object:nil];
}

#pragma mark - 获取当前环境（从本地读取）
+ (EnvironmentType)currentEnv {
    return EnvironmentType_Test_10004;
}

+ (NSString *)currentEnvironmentDisplayText {
    return @"10004";
}

#pragma mark - 广告平台
+ (NSArray<NSString *> *)availablePlatforms {
    return @[@"LM"];
}

+ (NSString *)selectedPlatformsKeyForCurrentEnvironment {
    return [NSString stringWithFormat:@"%@_%ld", kSelectedPlatformsKeyPrefix, (long)[self currentEnv]];
}

+ (NSArray<NSString *> *)defaultPlatformsForCurrentEnvironment {
    return @[@"LM"];
}

+ (NSArray<NSString *> *)normalizedPlatforms:(NSArray *)platforms {
    NSMutableArray *normalizedPlatforms = [NSMutableArray array];
    NSArray<NSString *> *availablePlatforms = [self availablePlatforms];
    for (id platform in platforms) {
        if (![platform isKindOfClass:[NSString class]]) {
            continue;
        }
        if (![availablePlatforms containsObject:platform]) {
            continue;
        }
        if (![normalizedPlatforms containsObject:platform]) {
            [normalizedPlatforms addObject:platform];
        }
    }
    return [normalizedPlatforms copy];
}

+ (NSArray<NSString *> *)selectedPlatforms {
    NSUserDefaults *ua = [NSUserDefaults standardUserDefaults];
    NSString *selectedPlatformsKey = [self selectedPlatformsKeyForCurrentEnvironment];
    NSArray *savedPlatforms = [ua objectForKey:selectedPlatformsKey];
    if ([savedPlatforms isKindOfClass:[NSArray class]]) {
        NSArray<NSString *> *normalizedPlatforms = [self normalizedPlatforms:savedPlatforms];
        return normalizedPlatforms.count > 0 ? normalizedPlatforms : [self defaultPlatformsForCurrentEnvironment];
    }

    NSArray *legacyPlatforms = [ua objectForKey:kLegacySelectedPlatformsKey];
    if ([legacyPlatforms isKindOfClass:[NSArray class]]) {
        NSArray<NSString *> *normalizedPlatforms = [self normalizedPlatforms:legacyPlatforms];
        [ua setObject:normalizedPlatforms forKey:selectedPlatformsKey];
        [ua removeObjectForKey:kLegacySelectedPlatformsKey];
        [ua synchronize];
        return normalizedPlatforms.count > 0 ? normalizedPlatforms : [self defaultPlatformsForCurrentEnvironment];
    }

    return [self defaultPlatformsForCurrentEnvironment];
}

+ (void)saveSelectedPlatforms:(NSArray<NSString *> *)platforms {
    NSArray<NSString *> *normalizedPlatforms = [self normalizedPlatforms:platforms];
    if (normalizedPlatforms.count == 0) {
        normalizedPlatforms = [self defaultPlatformsForCurrentEnvironment];
    }
    NSUserDefaults *ua = [NSUserDefaults standardUserDefaults];
    [ua setObject:normalizedPlatforms forKey:[self selectedPlatformsKeyForCurrentEnvironment]];
    [ua synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:AppConfigDidChangeNotification object:nil];
}

+ (NSString *)selectedPlatformsDisplayText {
    NSArray<NSString *> *platforms = [self selectedPlatforms];
    return [platforms componentsJoinedByString:@","];
}

+ (NSString *)selectedPlatform {
    NSString *platform = [self selectedPlatforms].firstObject;
    if ([platform isKindOfClass:[NSString class]] && [[self availablePlatforms] containsObject:platform]) {
        return platform;
    }
    return @"LM";
}

// MARK: - 配置
+ (NSString *)appID {
    return @"10004";
}

+ (NSString *)openID {
    return @"MTc4NjUzMDM0OTQ4OA=="; // LM
}

+ (NSString *)hotID {
    return @"MTc3NjIyMDA4MzI3NQ=="; // LM
}

+ (NSString *)rewardID {
    return @"MTc3NjIyMDExMDAwMQ=="; // LM
}

+ (NSString *)nativeID {
    return @"MTc3ODY1NjEwMTM2OQ=="; // LM
}

+ (NSString *)nativeDrawID {
    return @"MTc3ODY1NjA0MTU3MQ=="; // LM
}

+ (NSString *)interstitalID {
    return @"MTc4MjQ0MTM4MjUwNQ=="; // LM
}

@end
