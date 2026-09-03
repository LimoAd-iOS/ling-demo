#import <Foundation/Foundation.h>
#import <LingSDK/LingAdPublicDefine.h>

@interface LingAdBidLossInfo : NSObject

@property (nonatomic, assign) LingAdPlatform winnerPlatform;
@property (nonatomic, assign) NSInteger winnerPrice;

@end
