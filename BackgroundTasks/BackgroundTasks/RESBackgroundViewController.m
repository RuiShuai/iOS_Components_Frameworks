//
//  ViewController.m
//  BackgroundTasks
//
//  Created by taotao on 15/1/8.
//  Copyright (c) 2015年 RuiShuai Co., Ltd. All rights reserved.
//

#import "RESBackgroundViewController.h"

#define kLastCounterKey @"lastCounter"

@interface RESBackgroundViewController ()
- (void)performBackgroundTask;
@end

@implementation RESBackgroundViewController

#pragma mark - view life cycle
- (void)viewDidLoad {
    [super viewDidLoad];

    NSString *audioPath = [[NSBundle mainBundle] pathForResource:@"16_audio" ofType:@"mp3"];
    NSURL *audioURL = [NSURL fileURLWithPath:audioPath];
    
    self.audioPlayer = [self getAudioPlayerWithURL:audioURL];
    
}

-(AVAudioPlayer*)getAudioPlayerWithURL:(NSURL *)audioURL
{
    //audioPlayer
    NSError *playerInitError = nil;
    
    AVAudioPlayer *audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:audioURL error:&playerInitError];
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    
    NSError *activeError = nil;
    if (![session setActive:YES error:&activeError]) {
        NSLog(@"Failed to set active audio session!");
    }
    
    NSError *categoryError = nil;
    if (![session setCategory:AVAudioSessionCategoryPlayback error:&categoryError]) {
        NSLog(@"Failed to set audio category!");
    }
    
    return audioPlayer;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


#pragma mark - user actions
- (IBAction)playBackgroundMusicTouched:(id)sender
{
    if ([self.audioPlayer isPlaying]) {
        [self.audioPlayer stop];
        [self.audioButton setTitle:@"Play Background Music" forState:UIControlStateNormal];
    }else{
        UIImage *lockImage = [UIImage imageNamed:@"book_cover"];
        MPMediaItemArtwork *artwork = [[MPMediaItemArtwork alloc]initWithImage:lockImage];
        NSDictionary *mediaDict =
        @{
          MPMediaItemPropertyTitle:@"BackgroundTask Audio",
          MPMediaItemPropertyMediaType:@(MPMediaTypeAnyAudio),
          MPMediaItemPropertyPlaybackDuration:@(self.audioPlayer.duration),
          MPNowPlayingInfoPropertyPlaybackRate:@1.0,
          MPNowPlayingInfoPropertyElapsedPlaybackTime:@(self.audioPlayer.currentTime),
          MPMediaItemPropertyAlbumArtist:@"Joe Keeley",
          MPMediaItemPropertyArtist:@"Kyle Richter",
          MPMediaItemPropertyArtwork:artwork
          };
        
        [self.audioPlayer play];
        
        [self.audioButton setTitle:@"Stop Background Music" forState:UIControlStateNormal];
        
        [[MPNowPlayingInfoCenter defaultCenter]setNowPlayingInfo:mediaDict];
        
        [self becomeFirstResponder];
    
        [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
        
    }
}

- (IBAction)startBackgroundTouched:(id)sender
{
    UIDevice *device = [UIDevice currentDevice];
    if (![device isMultitaskingSupported]) {
        NSLog(@"Multitasking not supported on this device.");
        return;
    }
   
    [self.backgroundButton setEnabled:NO];
    
    NSString *buttonTitle = @"Background Task Running";
    [self.backgroundButton setTitle:buttonTitle forState:UIControlStateNormal];
    
    //异步进程
    dispatch_queue_t background = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(background, ^{
        [self performBackgroundTask];
    });
}

- (void)performBackgroundTask
{
    __block NSInteger counter = 0;
    
    __block UIBackgroundTaskIdentifier bTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        
        NSLog(@"Background Expiration Handler called.");
        NSLog(@"Counter is: %d, task ID is %u.",counter,bTask);
            
        [[UIApplication sharedApplication]endBackgroundTask:bTask];
            
        bTask = UIBackgroundTaskInvalid;
    }];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSInteger startCounter = [userDefaults integerForKey:kLastCounterKey];
    
    NSInteger twentyMins = 3 * 60;
    
    NSLog(@"Background task starting, task ID is %u.",bTask);
    for (counter = startCounter; counter <= twentyMins; counter++) {
        [NSThread sleepForTimeInterval:1];

        [userDefaults setInteger:counter forKey:kLastCounterKey];
        //同步userDefaults
        [userDefaults synchronize];
        
        NSTimeInterval remainingTime = [[UIApplication sharedApplication]backgroundTimeRemaining];
        if (remainingTime == DBL_MAX) {//DBL_MAX ?
            //NSLog(@"%f",DBL_MAX);
            NSLog(@"Background Processed %d. Still in foreground.",counter);
        }else{
            NSLog(@"Background Processed %d. Time remaining is: %f",counter,remainingTime);
        }
        
    }
    NSLog(@"Background Completed tasks");
    //重置0
    [userDefaults setInteger:0 forKey:kLastCounterKey];
    [userDefaults synchronize];
    
    dispatch_sync(dispatch_get_main_queue(), ^{
        [self.backgroundButton setEnabled:YES];
        [self.backgroundButton setTitle:@"Start Background Task" forState:UIControlStateNormal];
    });
    
    [[UIApplication sharedApplication] endBackgroundTask:bTask];
    bTask = UIBackgroundTaskInvalid;
    
}

@end
