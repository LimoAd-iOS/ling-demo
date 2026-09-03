//
//  LingAggAdInitArgument.h
//  LingAggSDK
//
//  Created by chaizhiyong on 2026/5/2.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LingAggAdInitArgument : NSObject
@property (nonatomic,copy)NSString *unitAppId;
@property (nonatomic,copy)NSString *appKey;
@property (nonatomic,copy) NSArray* caids;
@property (nonatomic, assign) CLLocationDegrees latitude;
@property (nonatomic, assign) CLLocationDegrees longitude;
@end

NS_ASSUME_NONNULL_END
