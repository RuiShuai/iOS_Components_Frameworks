//
//  ViewController.h
//  MediaPlayer
//
//  Created by taotao on 14/12/29.
//  Copyright (c) 2014年 RuiShuai Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface RESMediaPlayerViewController : UIViewController<MPMediaPickerControllerDelegate>
{
    IBOutlet UILabel *songLabel;
    IBOutlet UILabel *artistLabel;
    IBOutlet UILabel *recordLabel;
    IBOutlet UIImageView *albumImageView;
    MPMusicPlayerController *player;
    IBOutlet UIProgressView *playbackProgressIndicator;
    IBOutlet UIButton *playButton;
    IBOutlet UISlider *volumeSlider;
    
    float currentSongPlaybackTime;
    float currentSongDuration;
    IBOutlet UILabel *songDurationLabel;
    IBOutlet UILabel *currentTimeLabel;
    
    NSTimer *playbackTimer;
}

@property (nonatomic,strong) MPMusicPlayerController *player;

- (IBAction)volumeSiderChanged:(id)sender;
- (IBAction)mediaPickerButtonTouched:(id)sender;
- (IBAction)playButtonTouched:(id)sender;
- (IBAction)previousButtonTouched:(id)sender;
- (IBAction)skipBack30Seconds:(id)sender;
- (IBAction)nextButtonTouched:(id)sender;
- (IBAction)skipForward30Seconds:(id)sender;
- (IBAction)playRandomSongTouched:(id)sender;
- (IBAction)playDylanTouched:(id)sender;

-(void)registerMediaPlayerNotifications;
-(void)updateSongDuration;
-(void)updateCurrentPlaybackTime;

@end

