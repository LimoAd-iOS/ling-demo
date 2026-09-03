#import <Foundation/Foundation.h>
#import <LingSDK/LingAggPublicDefine.h>

@interface LingAggBidLossInfo : NSObject

@property (nonatomic, assign) LingAggPlatform winnerPlatform;
@property (nonatomic, assign) NSInteger winnerPrice;

@end
