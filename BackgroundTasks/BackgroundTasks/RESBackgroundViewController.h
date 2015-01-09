//
//  ViewController.h
//  BackgroundTasks
//
//  Created by taotao on 15/1/8.
//  Copyright (c) 2015年 RuiShuai Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface RESBackgroundViewController : UIViewController

@property (strong, nonatomic) AVAudioPlayer *audioPlayer;
@property (strong, nonatomic) IBOutlet UIButton *audioButton;
@property (strong, nonatomic) IBOutlet UIButton *backgroundButton;

- (IBAction)playBackgroundMusicTouched:(id)sender;
- (IBAction)startBackgroundTouched:(id)sender;

@end

