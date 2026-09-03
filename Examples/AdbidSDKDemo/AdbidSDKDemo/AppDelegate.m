//
//  AppDelegate.m
//  LeadMoadAdSDKDemo
//
//  Created by youzhadoubao on 2025/9/17.
//
#import "AppDelegate.h"
#include <Foundation/Foundation.h>
#import <AdSupport/AdSupport.h>
#import <AppTrackingTransparency/AppTrackingTransparency.h>
#import <LingSDK/LingSDK.h>
#import "AdbidHomeViewController.h"
#import "TimeUtil.h"
#import "AdbidTabBarViewController.h"
#import "AppConfig.h"
#import "AdbidSplashHotAD.h"
#import "HMLaunchController.h"
#import "AdbidSplashTokenTester.h"

@interface AppDelegate () <LingAggSplashAdDelegate>
@property (nonatomic, strong) LingAggSplashAd *splashAd;
@property (nonatomic, assign) BOOL isEnterForeground;
@property (nonatomic, strong) LingAggSplashAd *startupTestSplashAd;
@property (nonatomic, strong) AdbidSplashTokenTester *startupTokenTester;
@end

@implementation AppDelegate

- (void)performOnMainThread:(dispatch_block_t)block {
    if ([NSThread isMainThread]) {
        block();
    } else {
        dispatch_async(dispatch_get_main_queue(), block);
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self requestTrackingPermission];
    });
    UIWindow *keyWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    AdbidTabBarViewController *tabBar = [[AdbidTabBarViewController alloc] init];
    self.window = keyWindow;
    self.window.rootViewController = tabBar;
    [keyWindow makeKeyAndVisible];
    [self setupAdbidAdSDK];
    
  
    return YES;
}

- (void)requestTrackingPermission {
    if (@available(iOS 14, *)) {
        // 检查当前授权状态
        ATTrackingManagerAuthorizationStatus status = [ATTrackingManager trackingAuthorizationStatus];
        NSLog(@"Current ATTrackingManager status: %lu", (unsigned long)status);

        if (status == ATTrackingManagerAuthorizationStatusNotDetermined) {
            // 只有在未确定状态时才请求权限
            [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"ATTrackingManager status after request: %lu", (unsigned long)status);
                });
            }];
        } else {
            // 已经有授权状态，直接初始化SDK
            NSLog(@"ATTrackingManager already determined, status: %lu", (unsigned long)status);
            
        }
    } else {
        // iOS 14以下版本直接初始化SDK
        NSLog(@"iOS version < 14, initializing SDK directly");
         
    }
}

// MARK: - setup lm sdk
- (void)setupAdbidAdSDK {
    
    LingAggSDKConfiguration *configuration = [LingAggSDKConfiguration configuration];
    configuration.appID = [AppConfig appID];
    configuration.debugMode = YES;
    configuration.logLevel = LingAggLogLevelInfo;
    LingAggCustomPermissionController* adP = [[LingAggCustomPermissionController alloc]init];
    configuration.adCustomController = adP;
    NSString* sdkVersion = [LingAggSDKConfiguration sdkVersion];
    NSTimeInterval initStartTime = [[NSDate date] timeIntervalSince1970];
   
    dispatch_async(dispatch_get_main_queue(), ^{
        NSTimeInterval taskStartTime = [[NSDate date] timeIntervalSince1970];
        NSTimeInterval mainTaskWaitCost = (taskStartTime - initStartTime) * 1000.0;
        NSTimeInterval mockMainThreadTaskDuration = 2.0;
        NSLog(@"领摩聚合SDK 初始化主线程耗时任务开始，等待耗时=%.2fms 模拟耗时=%.2fs 时间=%@ 当前线程=%@",
              mainTaskWaitCost,
              mockMainThreadTaskDuration,
              [TimeUtil times][0],
              [NSThread isMainThread] ? @"主线程" : @"子线程");
        [NSThread sleepForTimeInterval:mockMainThreadTaskDuration];
        NSTimeInterval taskExecuteCost = ([[NSDate date] timeIntervalSince1970] - taskStartTime) * 1000.0;
        NSLog(@"领摩聚合SDK 初始化主线程耗时任务结束，执行耗时=%.2fms 时间=%@ 当前线程=%@",
              taskExecuteCost,
              [TimeUtil times][0],
              [NSThread isMainThread] ? @"主线程" : @"子线程");
    });
    NSLog(@"领摩聚合SDK 初始化开始 version=%@ 时间=%@",sdkVersion,[TimeUtil times][0]);
    [LingAggSDKManager startWithAsyncCompletionHandler:^(BOOL success, NSError *_Nullable error) {
        NSTimeInterval initCost = ([[NSDate date] timeIntervalSince1970] - initStartTime) * 1000.0;
        BOOL callbackOnMainThread = [NSThread isMainThread];
        NSLog(@"AdbidSDK 初始化回调 isMainThread=%@ 时间=%@ 当前线程=%@",
              callbackOnMainThread ? @"YES" : @"NO",
              [TimeUtil times][0],
              [NSThread currentThread]);
        dispatch_async(dispatch_get_main_queue(), ^{
            if (success) {
                NSLog(@"领摩聚合SDK 初始化成功第一次！耗时=%.2fms 时间=%@ 原始回调isMainThread=%@",
                      initCost,
                      [TimeUtil times][0],
                      callbackOnMainThread ? @"YES" : @"NO");
                [self logCurrentCAIDValuesWithTag:@"init-success"];
                // caids / GDT CAID 可能异步稍后写入，再补打一次
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self logCurrentCAIDValuesWithTag:@"init+3s"];
                });
               //  [self triggerServerBidTokenConfigCostTestAfterInitialization];
            } else {
                NSLog(@"领摩聚合SDK 初始化失败第一次！耗时=%.2fms 时间=%@ error=%@ 原始回调isMainThread=%@",
                      initCost,
                      [TimeUtil times][0],
                      error.localizedDescription ?: @"",
                      callbackOnMainThread ? @"YES" : @"NO");
            }
        });
    }];
}

/// 打印当前 CAID / caids（聚合缓存 + GDT 缓存）
- (void)logCurrentCAIDValuesWithTag:(NSString *)tag {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    id adbidCaids = [ud objectForKey:@"AdbidNativeDemoCaidsKey"];
    id gdtCAID = [ud objectForKey:@"LMAD_CAID_Data"];
    NSTimeInterval gdtFetchTime = [ud doubleForKey:@"LMAD_CAID_FetchTime"];
    NSString *gdtFetchDesc = gdtFetchTime > 0
        ? [NSString stringWithFormat:@"%.0f (距今 %.0fs)", gdtFetchTime, [[NSDate date] timeIntervalSince1970] - gdtFetchTime]
        : @"无";

    NSLog(@"[CAID][%@] AdbidNativeDemoCaidsKey = %@", tag ?: @"-", adbidCaids ?: @"(nil)");
    NSLog(@"[CAID][%@] LMAD_CAID_Data = %@", tag ?: @"-", gdtCAID ?: @"(nil)");
    NSLog(@"[CAID][%@] LMAD_CAID_FetchTime = %@", tag ?: @"-", gdtFetchDesc);

    // 从 GDT 结构里抽出最新 caid 值，方便直接看
    if ([gdtCAID isKindOfClass:[NSDictionary class]]) {
        NSArray *data = [(NSDictionary *)gdtCAID objectForKey:@"data"];
        if ([data isKindOfClass:[NSArray class]] && data.count > 0) {
            id last = data.lastObject;
            if ([last isKindOfClass:[NSDictionary class]]) {
                NSLog(@"[CAID][%@] latest GDT value=%@ version=%@",
                      tag ?: @"-",
                      [(NSDictionary *)last objectForKey:@"value"] ?: @"",
                      [(NSDictionary *)last objectForKey:@"version"] ?: @"");
            }
        }
    }
    if ([adbidCaids isKindOfClass:[NSArray class]] && [(NSArray *)adbidCaids count] > 0) {
        id first = [(NSArray *)adbidCaids firstObject];
        if ([first isKindOfClass:[NSDictionary class]]) {
            NSLog(@"[CAID][%@] Adbid first caid=%@ version=%@",
                  tag ?: @"-",
                  [(NSDictionary *)first objectForKey:@"caid"] ?: [(NSDictionary *)first objectForKey:@"value"] ?: @"",
                  [(NSDictionary *)first objectForKey:@"version"] ?: @"");
        }
    }
}

// MARK: - Splash
- (void)triggerServerBidTokenConfigCostTestAfterInitialization {
    NSString *slotId = [AppConfig openID];
    if (slotId.length == 0) {
        NSLog(@"初始化成功后跳过 requestServerBidTokenConfigBeforeLoadForSplashAd 测试: slotId 为空");
        return;
    }
    if (!self.startupTokenTester) {
        self.startupTokenTester = [[AdbidSplashTokenTester alloc] init];
    }
    self.startupTestSplashAd = [[LingAggSplashAd alloc] initWithSlotId:slotId];
    NSLog(@"初始化成功后开始调用 requestServerBidTokenConfigBeforeLoadForSplashAd 测试，slotId=%@ 时间=%@",
          slotId,
          [TimeUtil times][0]);
    [self requestServerBidTokenConfigBeforeLoadForSplashAd:self.startupTestSplashAd slotId:slotId];
}

- (void)requestServerBidTokenConfigBeforeLoadForSplashAd:(LingAggSplashAd *)splashAd slotId:(NSString *)slotId {
    __weak typeof(self) weakSelf = self;
    CFAbsoluteTime methodStartTime = CFAbsoluteTimeGetCurrent();
    CFAbsoluteTime requestStartTime = CFAbsoluteTimeGetCurrent();
    
//    [AdbidSDKManager requestServerBidTokenConfigForPositionId:slotId completion:^(NSString * _Nullable sdkInfoConfig, NSError * _Nullable configError) {
//        __strong typeof(weakSelf) strongSelf = weakSelf;
//        if (!strongSelf) {
//            return;
//        }
//        NSTimeInterval elapsedTime = (CFAbsoluteTimeGetCurrent() - requestStartTime) * 1000.0;
//        NSString *costLog = [NSString stringWithFormat:@"AppDelegate requestServerBidTokenConfigForPositionId 耗时: %.2f ms, slotId=%@, %@", elapsedTime, slotId ?: @"", configError ? [NSString stringWithFormat:@"error=%@", configError.localizedDescription ?: @"unknown"] : @"success"];
//        NSLog(@"%@", costLog);
//        [strongSelf.startupTokenTester getTokenWithAdId:slotId sdkInfo:sdkInfoConfig completion:^(BOOL success, NSDictionary * _Nullable config, NSError * _Nullable error) {
//            NSTimeInterval methodElapsedTime = (CFAbsoluteTimeGetCurrent() - methodStartTime) * 1000.0;
//            NSString *methodCostLog = [NSString stringWithFormat:@"AppDelegate requestServerBidTokenConfigBeforeLoadForSplashAd 总耗时: %.2f ms, slotId=%@, %@", methodElapsedTime, slotId ?: @"", error ? [NSString stringWithFormat:@"error=%@", error.localizedDescription ?: @"unknown"] : @"success"];
//            NSLog(@"%@", methodCostLog);
//            if (strongSelf.startupTestSplashAd == splashAd) {
//                NSString *token = [config objectForKey:@"token"];
//                [splashAd loadAdWithToken:token];
//            }
//        }];
//    }];
}

- (void)loadSplashAd {
    self.splashAd = [[LingAggSplashAd alloc] initWithSlotId:[AppConfig openID]];
    self.splashAd.viewController = self.window.rootViewController;
    self.splashAd.delegate = self;
    [self.splashAd loadAd];
}
// MARK: - LMSplashAdDelegate
// 广告加载成功
- (void)splashAdDidLoad:(LingAggSplashAd *)splashAd {
    BOOL callbackOnMainThread = [NSThread isMainThread];
    NSLog(@"冷启动开屏广告加载成功回调 isMainThread=%@ 时间=%@ 当前线程=%@",
          callbackOnMainThread ? @"YES" : @"NO",
          [TimeUtil times][0],
          [NSThread currentThread]);
    [self performOnMainThread:^{
        UIView *brandView = [self demoSplashBrandView];
        [self.splashAd showAdToWindow:self.window bottomView:brandView];
    }];
}

/// Demo 底部品牌条：占开屏底部 1/5
- (UIView *)demoSplashBrandView {
    CGFloat width = UIScreen.mainScreen.bounds.size.width;
    CGFloat height = UIScreen.mainScreen.bounds.size.height * 0.2;
    UIView *brandView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    brandView.backgroundColor = [UIColor whiteColor];

    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"DEMO 品牌条";
    titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightSemibold];
    titleLabel.textColor = [UIColor colorWithRed:0.16 green:0.20 blue:0.27 alpha:1.0];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [brandView addSubview:titleLabel];

    UILabel *hintLabel = [[UILabel alloc] init];
    hintLabel.text = @"底部 1/5 区域 · 广告在上方 4/5";
    hintLabel.font = [UIFont systemFontOfSize:12];
    hintLabel.textColor = [UIColor colorWithRed:0.45 green:0.50 blue:0.56 alpha:1.0];
    hintLabel.textAlignment = NSTextAlignmentCenter;
    hintLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [brandView addSubview:hintLabel];

    UIView *logoBox = [[UIView alloc] init];
    logoBox.backgroundColor = [UIColor colorWithRed:0.18 green:0.48 blue:0.95 alpha:1.0];
    logoBox.layer.cornerRadius = 10;
    logoBox.translatesAutoresizingMaskIntoConstraints = NO;
    [brandView addSubview:logoBox];

    UILabel *logoLabel = [[UILabel alloc] init];
    logoLabel.text = @"LOGO";
    logoLabel.font = [UIFont systemFontOfSize:11 weight:UIFontWeightBold];
    logoLabel.textColor = [UIColor whiteColor];
    logoLabel.textAlignment = NSTextAlignmentCenter;
    logoLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [logoBox addSubview:logoLabel];

    [NSLayoutConstraint activateConstraints:@[
        [logoBox.centerXAnchor constraintEqualToAnchor:brandView.centerXAnchor],
        [logoBox.topAnchor constraintEqualToAnchor:brandView.topAnchor constant:12],
        [logoBox.widthAnchor constraintEqualToConstant:44],
        [logoBox.heightAnchor constraintEqualToConstant:44],
        [logoLabel.centerXAnchor constraintEqualToAnchor:logoBox.centerXAnchor],
        [logoLabel.centerYAnchor constraintEqualToAnchor:logoBox.centerYAnchor],
        [titleLabel.topAnchor constraintEqualToAnchor:logoBox.bottomAnchor constant:8],
        [titleLabel.leadingAnchor constraintEqualToAnchor:brandView.leadingAnchor constant:16],
        [titleLabel.trailingAnchor constraintEqualToAnchor:brandView.trailingAnchor constant:-16],
        [hintLabel.topAnchor constraintEqualToAnchor:titleLabel.bottomAnchor constant:4],
        [hintLabel.leadingAnchor constraintEqualToAnchor:brandView.leadingAnchor constant:16],
        [hintLabel.trailingAnchor constraintEqualToAnchor:brandView.trailingAnchor constant:-16],
    ]];
    return brandView;
}

// 广告加载失败
- (void)splashAd:(LingAggSplashAd *)splashAd didFailToLoadWithError:(NSError *)error {
}
// 广告展示成功
- (void)splashAdDidShow:(LingAggSplashAd *)splashAd {
}

// 广告展示失败
- (void)splashAd:(LingAggSplashAd *)splashAd didFailToShowWithError:(NSError *)error {
}

// 广告被点击
- (void)splashAdDidClick:(LingAggSplashAd *)splashAd {
}

// 广告被关闭
- (void)splashAdDidClose:(LingAggSplashAd *)splashAd {
}

- (void)removeSplashAd {
    if (self.splashAd) {
        self.splashAd = nil;
        self.window.rootViewController = [self rootViewController];
    }
}

- (UIViewController *)rootViewController {
    AdbidHomeViewController *mainViewController = [[AdbidHomeViewController alloc] init];
    UINavigationController *navigationVC =
        [[UINavigationController alloc] initWithRootViewController:mainViewController];
    return navigationVC;
}
- (void)applicationDidEnterBackground:(UIApplication *)application{
    self.isEnterForeground = YES;
}

- (void)applicationWillEnterForeground:(UIApplication *)application{
      
    if (self.isEnterForeground) {
        UINavigationController *nav = [self getCurrentNavigationController];
        // 判断能不能 push
//        if (nav && ![nav.topViewController isKindOfClass:[HMLaunchController class]]) {
//            HMLaunchController *launchVC = [[HMLaunchController alloc] init];
//            [nav pushViewController:launchVC animated:NO]; // 无动画 push
//        }
        
       // if ([AppConfig shared].isOpenHotAppOpenAd) {
          //  [[AdbidSplashHotAD shared]loadOrShowSplashHotAD];
     //   }
    }
}

// 获取当前显示的导航（通用、稳定）
- (UINavigationController *)getCurrentNavigationController {
    UIViewController *topVC = [self getTopViewController];
    if ([topVC isKindOfClass:[UINavigationController class]]) {
        return (UINavigationController *)topVC;
    }
    return topVC.navigationController;
}

// 获取顶层控制器
- (UIViewController *)getTopViewController {
    UIViewController *viewController = self.window.rootViewController;
    while (viewController.presentedViewController) {
        viewController = viewController.presentedViewController;
    }
    return viewController;
}

@end
