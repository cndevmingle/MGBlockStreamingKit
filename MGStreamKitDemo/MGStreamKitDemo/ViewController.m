//
//  ViewController.m
//  MGStreamKitDemo
//
//  Created by Mingle on 2018/4/15.
//  Copyright © 2018年 Mingle. All rights reserved.
//

#import "ViewController.h"
#import "MGAudioPlayer.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *stateLbl;
@property (weak, nonatomic) IBOutlet UISlider *progressSlider;
/**错误次数*/
@property (nonatomic, assign) NSInteger errorCount;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _errorCount = 0;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)play:(id)sender {
    NSURL *url = [NSURL URLWithString:@"http://125.65.108.22:8080/upload/2018-04/6eb15687-d561-4039-82eb-78d58dfed35a.aac"];
    MGAudioPlayer *player = [MGAudioPlayer shareInstance];
    player.refreshTimeInterval = 1;
    __weak typeof(self) weakSelf = self;
    
    player.refreshBlock = ^(double duration, double progress, STKAudioPlayerState state, STKAudioPlayerErrorCode errorCode) {
        weakSelf.progressSlider.maximumValue = duration;
        weakSelf.progressSlider.value = progress;
        switch (state) {
            case STKAudioPlayerStateReady:
                weakSelf.stateLbl.text = @"Ready";
                break;
            case STKAudioPlayerStateRunning:
                weakSelf.stateLbl.text = @"Runnings";
                break;
            case STKAudioPlayerStatePlaying:
                weakSelf.stateLbl.text = [NSString stringWithFormat:@"%@:%@", @(progress), @(duration)];
                break;
            case STKAudioPlayerStateBuffering:
                weakSelf.stateLbl.text = @"缓冲中";
                break;
            case STKAudioPlayerStatePaused:
                weakSelf.stateLbl.text = @"暂停";
                break;
            case STKAudioPlayerStateStopped:
                weakSelf.stateLbl.text = @"停止";
                break;
            case STKAudioPlayerStateDisposed:
                weakSelf.stateLbl.text = @"Disposed";
                break;
            case STKAudioPlayerStateError:
                if (weakSelf.errorCount == 0) {
                    weakSelf.stateLbl.text = @"错误";
                }
                break;
            default:
                break;
        }
//        if (weakSelf.errorCount == 0) {
//            weakSelf.errorCount++;
//            [weakSelf play:nil];
//        }
    };
    player.startPlayBlock = ^(NSURL * _Nonnull URL) {
        NSLog(@"开始播放%@", URL);
//        [player seekToTime:125];
    };
    player.finishPlayBlock = ^(NSURL * _Nonnull URL) {
        NSLog(@"播放完成%@", URL);
    };
    [player playWithURL:url];
}

- (NSString *)formatTime:(double)time {
    NSInteger seconds = (NSInteger)ceil(time);
    return [NSString stringWithFormat:@"%@:%@", @(seconds/60), @(seconds%60)];
}

- (IBAction)pause:(id)sender {
    [[MGAudioPlayer shareInstance] pause];
}
- (IBAction)resume:(id)sender {
    [[MGAudioPlayer shareInstance] resume];
}
- (IBAction)stop:(id)sender {
    [[MGAudioPlayer shareInstance] stop];
}

@end
