//
//  LingNativeView.h
//  LingSDK
//
//  Created by youzhadoubao on 2025/9/25.
//

#import <UIKit/UIKit.h>
@class LingNativeAd;
@class LingNativeMediaView;

NS_ASSUME_NONNULL_BEGIN

@interface LingNativeView : UIView

/**
 视频广告的媒体View，绑定数据对象后自动生成，可自定义布局
 */
@property (nonatomic, strong, readonly) LingNativeMediaView *mediaView;

- (void)refreshData:(LingNativeAd *)nativeAd;

@end

NS_ASSUME_NONNULL_END
