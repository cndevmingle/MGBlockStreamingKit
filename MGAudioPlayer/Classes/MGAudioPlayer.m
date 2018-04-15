//
//  MGAudioPlayer.m
//  MGBlockStreamingKitDemo
//
//  Created by Mingle on 2018/4/15.
//  Copyright © 2018年 Mingle. All rights reserved.
//

#import "MGAudioPlayer.h"

@interface MGAudioPlayer () <STKAudioPlayerDelegate>

/**播放器*/
@property (nonatomic, strong) STKAudioPlayer *audioPlayer;
/**刷新计时器*/
@property (nonatomic, strong) NSTimer *refreshTimer;
/**播放失败已重试次数*/
@property (nonatomic, assign) NSInteger replayUseCountInFail;
/**当前播放的音频地址*/
@property (nonatomic, strong) NSURL *currentURL;

@end

@implementation MGAudioPlayer

+ (instancetype)shareInstance {
    static MGAudioPlayer *player;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        player = [[MGAudioPlayer alloc] init];
    });
    return player;
}

- (instancetype)init {
    if (self = [super init]) {
        [self setup];
    }
    return self;
}

- (STKAudioPlayer *)audioPlayer {
    if (!_audioPlayer) {
        _audioPlayer = [[STKAudioPlayer alloc] init];
        _audioPlayer.delegate = self;
    }
    return _audioPlayer;
}

- (void)setRefreshTimeInterval:(NSTimeInterval)refreshTimeInterval {
    if (refreshTimeInterval <= 0) {
        _refreshTimeInterval = 0;
    } else {
        _refreshTimeInterval = refreshTimeInterval;
    }
    [self tryLaunchProgressTimer];
}

- (void)setup {
    _replayCountInFail = 1;
    _replayUseCountInFail = 0;
    _refreshTimeInterval = 1;
    [self audioPlayer];
}

- (void)seekToTime:(double)time {
    [_audioPlayer seekToTime:time];
}

- (void)playWithURL:(NSURL *)URL {
    _replayUseCountInFail = 0;
    _currentURL = URL;
    STKDataSource *dataSource = [STKAudioPlayer dataSourceFromURL:URL];
    [self.audioPlayer playDataSource:dataSource withQueueItemID:URL];
    [self tryLaunchProgressTimer];
}

- (void)pause {
    [self.audioPlayer pause];
    [_refreshTimer invalidate];
    _refreshTimer = nil;
}

- (void)resume {
    [self.audioPlayer resume];
    [self tryLaunchProgressTimer];
}

- (void)stop {
    [self.audioPlayer stop];
    [_refreshTimer invalidate];
    _refreshTimer = nil;
}

- (void)tryLaunchProgressTimer {
    if (_refreshTimer) {
        [_refreshTimer invalidate];
        _refreshTimer = nil;
    }
    if (_refreshTimeInterval > 0 && (_audioPlayer.state == STKAudioPlayerStateRunning || _audioPlayer.state == STKAudioPlayerStateBuffering || _audioPlayer.state == STKAudioPlayerStatePlaying)) {
        _refreshTimer = [NSTimer scheduledTimerWithTimeInterval:_refreshTimeInterval target:self selector:@selector(refreshTimerHandle) userInfo:nil repeats:YES];
        
    }
}

- (void)refreshTimerHandle {
    if (_refreshBlock) {
        _refreshBlock(_audioPlayer.duration, _audioPlayer.progress, (_audioPlayer.state == STKAudioPlayerStateError && _replayUseCountInFail < _replayCountInFail) ? STKAudioPlayerStateReady : _audioPlayer.state, STKAudioPlayerErrorNone);
    }
}

#pragma mark - 播放器代理
/// Raised when an item has started playing
-(void) audioPlayer:(STKAudioPlayer*)audioPlayer didStartPlayingQueueItemId:(NSObject*)queueItemId {
#if DEBUG
    NSLog(@"开始播放:%@", queueItemId);
#endif
    if (_startPlayBlock) {
        _startPlayBlock(_currentURL);
    }
    
    [self tryLaunchProgressTimer];
}

/// Raised when an item has finished buffering (may or may not be the currently playing item)
/// This event may be raised multiple times for the same item if seek is invoked on the player
-(void) audioPlayer:(STKAudioPlayer*)audioPlayer didFinishBufferingSourceWithQueueItemId:(NSObject*)queueItemId {
#if DEBUG
    NSLog(@"缓冲完成:%@", queueItemId);
#endif
}

/// Raised when the state of the player has changed
-(void) audioPlayer:(STKAudioPlayer*)audioPlayer stateChanged:(STKAudioPlayerState)state previousState:(STKAudioPlayerState)previousState {
#if DEBUG
    NSLog(@"播放状态改变:%@", @(state));
#endif
    if (_refreshBlock) {
        _refreshBlock(audioPlayer.duration, audioPlayer.progress, (_audioPlayer.state == STKAudioPlayerStateError && _replayUseCountInFail < _replayCountInFail) ? STKAudioPlayerStateReady : _audioPlayer.state, STKAudioPlayerErrorNone);
    }
}

/// Raised when an item has finished playing
-(void) audioPlayer:(STKAudioPlayer*)audioPlayer didFinishPlayingQueueItemId:(NSObject*)queueItemId withReason:(STKAudioPlayerStopReason)stopReason andProgress:(double)progress andDuration:(double)duration {
#if DEBUG
    NSLog(@"播放完成:%@", queueItemId);
#endif
    // 播放完成尝试重启计时器，因为播放下一首时，上一首也会调用播放完成，而且可能会延迟调用
    [self tryLaunchProgressTimer];
    
    if (_finishPlayBlock) {
        _finishPlayBlock(_currentURL);
    }
}

/// Raised when an unexpected and possibly unrecoverable error has occured (usually best to recreate the STKAudioPlauyer)
-(void) audioPlayer:(STKAudioPlayer*)audioPlayer unexpectedError:(STKAudioPlayerErrorCode)errorCode {
#if DEBUG
    NSLog(@"播放错误:%@", @(errorCode));
#endif
    [_refreshTimer invalidate];
    _refreshTimer = nil;
    
    if (_refreshBlock) {
        _refreshBlock(audioPlayer.duration, audioPlayer.progress, (_audioPlayer.state == STKAudioPlayerStateError && _replayUseCountInFail < _replayCountInFail) ? STKAudioPlayerStateReady : _audioPlayer.state, errorCode);
    }
    
    if (_replayUseCountInFail < _replayCountInFail) {
        [self playWithURL:_currentURL];
        _replayUseCountInFail++;
    }
}

/// Optionally implemented to get logging information from the STKAudioPlayer (used internally for debugging)
-(void) audioPlayer:(STKAudioPlayer*)audioPlayer logInfo:(NSString*)line {
#if DEBUG
    NSLog(@"播放日志:%@", line);
#endif
}

/// Raised when items queued items are cleared (usually because of a call to play, setDataSource or stop)
-(void) audioPlayer:(STKAudioPlayer*)audioPlayer didCancelQueuedItems:(NSArray*)queuedItems {
    [_refreshTimer invalidate];
    _refreshTimer = nil;
}

@end
