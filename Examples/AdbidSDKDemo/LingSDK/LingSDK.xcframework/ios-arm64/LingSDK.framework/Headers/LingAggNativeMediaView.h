//
//  LingAggNativeMediaView.h
//  LeadmoadAdSDK
//
//  Created by youzhadoubao on 2025/9/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class LingAggNativeMediaView;
@protocol LingAggNativeMediaViewDelegate <NSObject>

@optional

/**
 用户点击 MediaView 回调

 @param mediaView 播放器实例
 */
- (void)nativeMediaViewDidClick:(LingAggNativeMediaView *)mediaView;
/**
 准备播放
 */
- (void)nativeMediaViewReadyToPlay:(LingAggNativeMediaView *)mediaView;

/**
 播放完成回调

 @param mediaView 播放器实例
 */
- (void)nativeMediaViewDidPlayFinished:(LingAggNativeMediaView *)mediaView;
/**
 播放失败回调
 */
- (void)nativeMediaView:(LingAggNativeMediaView *)mediaView didPlayFailWithError:(NSError *_Nullable)error;

@end

@interface LingAggNativeMediaView : UIView

/**
 MoskenNativeMediaView 回调对象
 */
@property (nonatomic, weak) id<LingAggNativeMediaViewDelegate> delegate;

/**
 播放视频
 */
- (void)play;

/**
 暂停视频，调用 pause 后，需要被暂停的视频广告对象，不会再自动播放，需要调用 play 才能恢复播放。
 */
- (void)pause;

/**
 停止播放，并展示第一帧
 */
- (void)stop;

@end

NS_ASSUME_NONNULL_END
