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
    [[NSUserDefaults standardUserDefaults] setInteger:env forKey:kEnvironmentKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:AppConfigDidChangeNotification object:nil];
}

#pragma mark - 获取当前环境（从本地读取）
+ (EnvironmentType)currentEnv {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kEnvironmentKey] == nil) {
        return EnvironmentType_Test_10004;
    }
    EnvironmentType env = [[NSUserDefaults standardUserDefaults] integerForKey:kEnvironmentKey];
    switch (env) {
        case EnvironmentType_Test_10004:
        case EnvironmentType_Test_10011:
        case EnvironmentType_Test_10027:
        case EnvironmentType_Test_10002:
        case EnvironmentType_Test_10004S:
            return env;
        default:
            return EnvironmentType_Test_10004;
    }
}

+ (NSString *)currentEnvironmentDisplayText {
    switch ([self currentEnv]) {
        case EnvironmentType_Test_10011:     return @"10011";
        case EnvironmentType_Test_10004:     return @"10004";
        case EnvironmentType_Test_10027:     return @"10027";
        case EnvironmentType_Test_10002:     return @"10002";
        case EnvironmentType_Test_10004S:    return @"10004";
        default:                             return @"10004";
    }
}

#pragma mark - 广告平台
+ (NSArray<NSString *> *)availablePlatforms {
    switch ([self currentEnv]) {
        case EnvironmentType_Test_10002:
            return @[@"LM", @"WM",@"GDT"];
        default:
            return @[@"LM", @"UBX", @"FL", @"Ezviz",@"GDT",@"other"];
    }
}

+ (NSString *)selectedPlatformsKeyForCurrentEnvironment {
    return [NSString stringWithFormat:@"%@_%ld", kSelectedPlatformsKeyPrefix, (long)[self currentEnv]];
}

+ (NSArray<NSString *> *)defaultPlatformsForCurrentEnvironment {
    switch ([self currentEnv]) {
        case EnvironmentType_Test_10011:
        case EnvironmentType_Test_10004:
        case EnvironmentType_Test_10027:
        case EnvironmentType_Test_10002:
        case EnvironmentType_Test_10004S:
        default:
            return @[];
    }
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
        return [self normalizedPlatforms:savedPlatforms];
    }

    NSArray *legacyPlatforms = [ua objectForKey:kLegacySelectedPlatformsKey];
    if ([legacyPlatforms isKindOfClass:[NSArray class]]) {
        NSArray<NSString *> *normalizedPlatforms = [self normalizedPlatforms:legacyPlatforms];
        [ua setObject:normalizedPlatforms forKey:selectedPlatformsKey];
        [ua removeObjectForKey:kLegacySelectedPlatformsKey];
        [ua synchronize];
        return normalizedPlatforms;
    }

    return [self defaultPlatformsForCurrentEnvironment];
}

+ (void)saveSelectedPlatforms:(NSArray<NSString *> *)platforms {
    NSArray<NSString *> *normalizedPlatforms = [self normalizedPlatforms:platforms];
    NSUserDefaults *ua = [NSUserDefaults standardUserDefaults];
    [ua setObject:normalizedPlatforms forKey:[self selectedPlatformsKeyForCurrentEnvironment]];
    [ua synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:AppConfigDidChangeNotification object:nil];
}

+ (NSString *)selectedPlatformsDisplayText {
    NSArray<NSString *> *platforms = [self selectedPlatforms];
    if (platforms.count == 0) {
        return @"other";
    }
    return [platforms componentsJoinedByString:@","];
}

+ (NSString *)selectedPlatform {
    NSString *platform = [self selectedPlatforms].firstObject;
    if ([platform isKindOfClass:[NSString class]] && [[self availablePlatforms] containsObject:platform]) {
        return platform;
    }
    return @"other";
}

// MARK: - 配置
+ (NSString *)appID {
    switch ([self currentEnv]) {
        case EnvironmentType_Test_10011:     return @"10011";
        case EnvironmentType_Test_10004:     return @"10004";
        case EnvironmentType_Test_10004S:    return @"10004";
        case EnvironmentType_Test_10027:     return @"10027";
        case EnvironmentType_Test_10002:     return @"10002";
        default: return @"10027";
    }
}

+ (NSString *)openID {
    NSString *platform = [self selectedPlatform];
    switch ([self currentEnv]) {
            case EnvironmentType_Test_10011:
                if ([platform isEqualToString:@"FL"]) {
                    return @"MTc3OTI0NjczODM1OQ=="; // 泛连
                } else if ([platform isEqualToString:@"UBX"]) {
                    return @"MTc3OTI0Njg5MTQ4NQ=="; // UBix
                } else if ([platform isEqualToString:@"LM"]) {
                    return @"MTc3OTI0ODQxNzcxNg=="; // LM
                } else if ([platform isEqualToString:@"Ezviz"]) {
                    return @"MTc3OTcwNjU3MTk2OA=="; // Ezviz
                }
                return @"MTc4NjA5MjI2MDE0OA==";
            case EnvironmentType_Test_10004: {
                if ([platform isEqualToString:@"FL"]) {
                    return @"MTc3ODY0NTc0MTYwOA=="; // 泛连
                } else if ([platform isEqualToString:@"UBX"]) {
                    return @"MTc3ODY0NTkwMjkzMg=="; // UBix
                } else if ([platform isEqualToString:@"LM"]) {
                    return @"MTc4NjUzMDM0OTQ4OA=="; // LM
                } else if ([platform isEqualToString:@"Ezviz"]) {
                    return @"MTc4MTAwOTQxODk4MA=="; // Ezviz
                }
                return @"MTc1MzM0MzU1MzkzOQ==";
            }
            case EnvironmentType_Test_10004S: {
                 
                return @"MTc4NjM0NDg3MDEzNQ==";
            }
            case EnvironmentType_Test_10027: {
                if ([platform isEqualToString:@"LM"]) {
                    return @"MTc3OTg1ODA2NTIwMg=="; // LM
                } else if ([platform isEqualToString:@"KuYing"]) {
                    return @"MTc3OTg1ODA2NTIwMg=="; // KuYing
                }
                return @"MTc3OTg1ODA2NTIwMg==";
            }
            case EnvironmentType_Test_10002: {
                if ([platform isEqualToString:@"LM"]) {
                    return @"MTc4Mjg3NDEwNjIwMg=="; // LM
                } else if ([platform isEqualToString:@"WM"]) {
                    return @"MTc4ODE2Mzk4NTU3OQ=="; //LM
                } else if ([platform isEqualToString:@"GDT"]) {
                    return @"MTc4ODE3ODM5Mzc1MQ=="; //LM
                }
                return @"MTc3OTg1ODA2NTIwMg==";
             }
             default: return @"MTc1MzM0MzU1MzkzOQ==";
    }
}

+ (NSString *)hotID {
    NSString *platform = [self selectedPlatform];
    switch ([self currentEnv]) {
            case EnvironmentType_Test_10011:
                if ([platform isEqualToString:@"FL"]) {
                    return @"MTc3OTI0NjczODM1OQ=="; // 泛连
                } else if ([platform isEqualToString:@"UBX"]) {
                    return @"MTc3OTI0Njg5MTQ4NQ=="; // UBix
                } else if ([platform isEqualToString:@"LM"]) {
                    return @"MTc3OTI0ODQxNzcxNg=="; // LM
                } else if ([platform isEqualToString:@"Ezviz"]) {
                    return @"MTc3OTcwNjU3MTk2OA=="; // Ezviz
                }
                return @"MTc1MzM0MzU1MzkzOQ==";
            case EnvironmentType_Test_10004: {
                if ([platform isEqualToString:@"FL"]) {
                    return @"MTc3ODY0NTc0MTYwOA=="; // 泛连
                } else if ([platform isEqualToString:@"UBX"]) {
                    return @"MTc3ODY0NTkwMjkzMg=="; // UBix
                } else if ([platform isEqualToString:@"LM"]) {
                    return @"MTc3NjIyMDA4MzI3NQ=="; // LM
                } else if ([platform isEqualToString:@"Ezviz"]) {
                    return @"MTc4MTAwOTQxODk4MA=="; // Ezviz
                }
                return @"MTc1MzM0MzU1MzkzOQ==";
            }
            case EnvironmentType_Test_10002: {
                if ([platform isEqualToString:@"LM"]) {
                    return @"MTc4Mjg3NDEwNjIwMg=="; // LM
                }else if ([platform isEqualToString:@"WM"]) {
                    return @"MTc4ODE2Mzk4NTU3OQ=="; //LM
                }else if ([platform isEqualToString:@"GDT"]) {
                    return @"MTc4ODE3ODM5Mzc1MQ=="; //LM
                }
                return @"MTc3OTg1ODA2NTIwMg==";
            }
            default: return @"MTc1MzM0MzU1MzkzOQ==";
    }
}

+ (NSString *)rewardID {
    NSString *platform = [self selectedPlatform];
    switch ([self currentEnv]) {
            case EnvironmentType_Test_10011:
                if ([platform isEqualToString:@"FL"]) {
                    return @"MTc3OTI0NjcwMzY4Mg=="; // 泛连
                } else if ([platform isEqualToString:@"UBX"]) {
                    return @"MTc3OTI0NjkzMzEwMg=="; // UBix
                } else if ([platform isEqualToString:@"LM"]) {
                    return @"MTc3OTI0ODQ3MDQ2OA=="; // LM
                } else if ([platform isEqualToString:@"Ezviz"]) {
                    return @"MTc3OTcwNjU4NDE3NQ=="; // Ezviz
                }
                return @"MTc4NjA5MjI3MzcwMg==";
            case EnvironmentType_Test_10004: {
                if ([platform isEqualToString:@"FL"]) {
                    return @"MTc3ODY0NTc5NDg3OQ=="; // 泛连
                } else if ([platform isEqualToString:@"UBX"]) {
                    return @"MTc3ODY0NTkzNjg3NQ=="; // UBix
                } else if ([platform isEqualToString:@"LM"]) {
                    return @"MTc3NjIyMDExMDAwMQ=="; // LM
                } else if ([platform isEqualToString:@"Ezviz"]) {
                    return @"MTc4MTAxMDc2NjU2Ng=="; // Ezviz
                }
                return @"MTc1MzM0NDk5OTk3Mw==";
            }
            case EnvironmentType_Test_10004S: {
                return @"MTc4NjM0NDkzNzk2Mw==";
            }
            case EnvironmentType_Test_10002: {
                if ([platform isEqualToString:@"LM"]) {
                    return @"MTc4MzY1MDcwNjEwOA=="; // LM
                }else if ([platform isEqualToString:@"WM"]) {
                    return @"MTc4ODE2NTYyNTE1MA=="; //旺脉
                }else if ([platform isEqualToString:@"GDT"]) {
                    return @"MTc4ODE3OTM0OTI1OQ=="; //LM
                }
                return @"MTc4MzY1MDcwNjEwOA==";
            }
            default: return @"MTc1MzM0NDk5OTk3Mw==";
    }
}

+ (NSString *)nativeID {
    NSString *platform = [self selectedPlatform];
    switch ([self currentEnv]) {
            case EnvironmentType_Test_10011:
                if ([platform isEqualToString:@"FL"]) {
                    return @"MTc3OTI0NjU3NjE3Mw=="; // 泛连
                } else if ([platform isEqualToString:@"UBX"]) {
                    return @"MTc3OTI0Njk2NDA5Mw=="; // UBix
                } else if ([platform isEqualToString:@"LM"]) {
                    return @"MTc3OTI0ODQ5MDk5Mw=="; // LM
                } else if ([platform isEqualToString:@"Ezviz"]) {
                    return @"MTc3OTcwNjY1NzEwNw=="; // Ezviz
                }
                return @"MTc4NjA5MjMxNDAwMQ==";
            case EnvironmentType_Test_10004: {
                if ([platform isEqualToString:@"FL"]) {
                    return @"MTc3ODY1NDA2MDU2NA=="; // 泛连
                } else if ([platform isEqualToString:@"UBX"]) {
                    return @"MTc3ODY1NDIwOTQ1Mg=="; // UBix
                } else if ([platform isEqualToString:@"LM"]) {
                    return @"MTc3ODY1NjEwMTM2OQ=="; // LM
                } else if ([platform isEqualToString:@"Ezviz"]) {
                    return @"MTc4MTAxMDQ5NjAxNA=="; // Ezviz
                }
                return @"MTc1MzM0NTA2ODIxOA==";
            }
            case EnvironmentType_Test_10004S: {
                return @"MTc4NjM0NDg5MDYwNQ==";
            }
            case EnvironmentType_Test_10002: {
                if ([platform isEqualToString:@"LM"]) {
                    return @"MTc4MzY1MDc2MDM1OA=="; // LM
                }else if ([platform isEqualToString:@"WM"]) {
                    return @"MTc4ODE2NTg0MzMxNQ=="; //旺脉
                }else if ([platform isEqualToString:@"GDT"]) {
                    return @"MTc4ODE3OTc3NjM2Ng=="; //LM
                }
                return @"MTc4MzY1MDc2MDM1OA==";
            }
        default: return @"MTc1MzM0NTA2ODIxOA==";
    }
}

+ (NSString *)nativeDrawID {
    NSString *platform = [self selectedPlatform];
    switch ([self currentEnv]) {
            case EnvironmentType_Test_10011:
                if ([platform isEqualToString:@"FL"]) {
                    return @"MTc3OTI0NjY1MTc2OQ=="; // 泛连
                } else if ([platform isEqualToString:@"UBX"]) {
                    return @"MTc3OTI0ODM1MTk5Nw=="; // UBix
                } else if ([platform isEqualToString:@"LM"]) {
                    return @"MTc3OTI0ODUwMzQ2OA=="; // LM
                } else if ([platform isEqualToString:@"Ezviz"]) {
                    return @"MTc3OTcwNjY2OTU5NA=="; // Ezviz
                }
                return @"MTc4NjA5MjI5ODY1Mw==";
            case EnvironmentType_Test_10004: {
                if ([platform isEqualToString:@"FL"]) {
                    return @"MTc3ODY1NDA2MDU2NA=="; // 泛连
                } else if ([platform isEqualToString:@"UBX"]) {
                    return @"MTc3ODY1NDIwOTQ1Mg=="; // UBix
                } else if ([platform isEqualToString:@"LM"]) {
                    return @"MTc3ODY1NjA0MTU3MQ=="; // LM
                } else if ([platform isEqualToString:@"Ezviz"]) {
                    return @"MTc4MTAxMDQ5NjAxNA=="; // Ezviz
                }
                return @"MTc1MzM0NTA2ODIxOA==";
            }
            case EnvironmentType_Test_10004S: {
                return @"MTc4NjM0NDg5MDYwNQ==";
            }
            case EnvironmentType_Test_10002: {
                if ([platform isEqualToString:@"LM"]) {
                    return @"MTc4MzY1MDc0NzEwMQ=="; // LM
                }else if ([platform isEqualToString:@"WM"]) {
                    return @"MTc4ODE2NTg0MzMxNQ=="; //旺脉
                }else if ([platform isEqualToString:@"GDT"]) {
                    return @"MTc4ODE3OTc3NjM2Ng=="; //LM
                }
                return @"MTc4MzY1MDc0NzEwMQ==";
            }
            default: return @"MTc1MzM0NTA2ODIxOA==";
    }
}

+ (NSString *)interstitalID {
    NSString *platform = [self selectedPlatform];
    switch ([self currentEnv]) {
            case EnvironmentType_Test_10011:
                if ([platform isEqualToString:@"FL"]) {
                    return @"MTc3OTI0NjczODM1OQ=="; // 泛连
                } else if ([platform isEqualToString:@"UBX"]) {
                    return @"MTc3OTI0Njg5MTQ4NQ=="; // UBix
                } else if ([platform isEqualToString:@"LM"]) {
                    return @"MTc3OTI0ODQxNzcxNg=="; // LM
                } else if ([platform isEqualToString:@"Ezviz"]) {
                    return @"MTc3OTcwNjU3MTk2OA=="; // Ezviz
                }
                return @"MTc1MzM0MzU1MzkzOQ==";
            case EnvironmentType_Test_10004: {
                if ([platform isEqualToString:@"FL"]) {
                    return @"MTc3ODY0NTc0MTYwOA=="; // 泛连
                } else if ([platform isEqualToString:@"UBX"]) {
                    return @"MTc3ODY0NTkwMjkzMg=="; // UBix
                } else if ([platform isEqualToString:@"LM"]) {
                    return @"MTc4MjQ0MTM4MjUwNQ=="; // LM
                } else if ([platform isEqualToString:@"Ezviz"]) {
                    return @"MTc4MTAwOTQxODk4MA=="; // Ezviz
                }else if ([platform isEqualToString:@"GDT"]) {
                    return @"MTc4MjE4NDg3Njk1Nw=="; // GDT
                }
                return @"MTc1MzM0MzU1MzkzOQ==";
            }
            case EnvironmentType_Test_10004S: {
                return @"MTc4NjM0NDg1NzI0OQ==";
            }
            case EnvironmentType_Test_10002: {
                if ([platform isEqualToString:@"LM"]) {
                    return @"MTc4MzY1MDcyODAwNA=="; // LM
                }else if ([platform isEqualToString:@"WM"]) {
                    return @"MTc4ODE2NTUzNDEzMQ=="; //旺脉
                }else if ([platform isEqualToString:@"GDT"]) {
                    return @"MTc4ODE3OTUwMDAyMQ=="; //GDT
                }
                return @"MTc4MzY1MDcyODAwNA==";
            }
        default: return @"MTc1MzM0MzU1MzkzOQ==";
    }
}

@end
