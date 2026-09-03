//
//  LingAggBaseRewardVideoAdapter.h
//  LingAggSDK
//
//  Created by chaizhiyong on 2026/1/21.
//

#import <Foundation/Foundation.h>
#import <LingSDK/LingAggRewardVideoAdapterProtocol.h>

NS_ASSUME_NONNULL_BEGIN
@interface LingAggBaseRewardVideoAdapter : NSObject<LingAggRewardVideoAdapterProtocol>

@property (nonatomic, weak) id<LingAggRewardVideoAdapterDelegate> adapterDelegate;
@property (nonatomic, assign) NSInteger maxLoadTime;
@property (nonatomic, assign) NSInteger eCPM;
@property (nonatomic, assign) BOOL shouldMuted;///是否静音，默认是静音
@property (nonatomic, copy, readonly) NSString *slotId;
@property (nonatomic, copy, readonly) NSString *currentRequestId;

- (instancetype)initWithSlotId:(NSString *)slotId requestId:(NSString*)requestId NS_DESIGNATED_INITIALIZER;
- (void)updateCurrentRequestId:(NSString *)requestId;
- (instancetype)init NS_UNAVAILABLE;
//是否可以显示
- (BOOL)isReady;

+(BOOL)isExistSDK;

@end

NS_ASSUME_NONNULL_END
