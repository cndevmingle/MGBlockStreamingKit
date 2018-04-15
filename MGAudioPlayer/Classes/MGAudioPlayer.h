//
//  MGAudioPlayer.h
//  MGBlockStreamingKitDemo
//
//  Created by Mingle on 2018/4/15.
//  Copyright © 2018年 Mingle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STKAudioPlayer.h"

NS_ASSUME_NONNULL_BEGIN
@interface MGAudioPlayer : NSObject

/**播放失败重试次数，默认1*/
@property (nonatomic, assign) NSInteger replayCountInFail;
/**刷新频率，默认0s-不刷新，大于0才会开始刷新*/
@property (nonatomic, assign) NSTimeInterval refreshTimeInterval;
/**刷新的回调，单例状态下请记得释放*/
@property (nonatomic, copy, nullable) void(^refreshBlock)(double duration, double progress, STKAudioPlayerState state, STKAudioPlayerErrorCode errorCode);
/**开始播放的回调*/
@property (nonatomic, copy, nullable) void(^startPlayBlock)(NSURL *URL);
/**播放完成的回调*/
@property (nonatomic, copy, nullable) void(^finishPlayBlock)(NSURL *URL);

/**
 单例
 */
+ (instancetype)shareInstance;

/**
 播放指定音频

 @param URL 音频地址
 */
- (void)playWithURL:(NSURL *)URL;

/**
 暂停
 */
- (void)pause;

/**
 继续
 */
- (void)resume;

/**
 结束播放
 */
- (void)stop;

/**
 从指定时间开始播放

 @param time 开始播放的时间
 */
- (void)seekToTime:(double)time;

@end
NS_ASSUME_NONNULL_END
