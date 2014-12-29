//
//  ViewController.m
//  MediaPlayer
//
//  Created by taotao on 14/12/29.
//  Copyright (c) 2014年 RuiShuai Co., Ltd. All rights reserved.
//

#import "RESMediaPlayerViewController.h"

@interface RESMediaPlayerViewController ()

@end

@implementation RESMediaPlayerViewController

@synthesize player;

#pragma mark - view life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"MediaPlayer";
    
    //初始化播放器
    player = [MPMusicPlayerController systemMusicPlayer];//applicationMusicPlayer];
    //设置音量
    [volumeSlider setValue:[player volume]];
    //MPVolumeView
    
    //设置play按钮
    if ([player playbackState] == MPMusicPlaybackStatePlaying) {
        [playButton setTitle:@"Pause" forState:UIControlStateNormal];
    } else {
        [playButton setTitle:@"Play" forState:UIControlStateNormal];
    }
    //更新歌曲时长,当前播放时间
    [self updateSongDuration];
    [self updateCurrentPlaybackTime];
}


-(void)updateSongDuration
{
    currentSongPlaybackTime = 0;
    currentSongDuration = [[[player nowPlayingItem] valueForProperty:@"playbackDuration"] floatValue];
    int tHours = (currentSongDuration / 3600);
    int tMins = ((currentSongDuration / 60 ) - tHours * 60);
    int tSecs = (currentSongDuration) - (tMins *60) - (tHours * 3600);
    songDurationLabel.text = [NSString stringWithFormat:@"%i:%02d:%02d",tHours,tMins,tSecs];
    currentTimeLabel.text = @"0:00:00";
}

-(void)updateCurrentPlaybackTime
{
    currentSongPlaybackTime = player.currentPlaybackTime;
    int tHours = (currentSongPlaybackTime / 3600);
    int tMins = ((currentSongPlaybackTime / 60 ) - tHours * 60);
    int tSecs = (currentSongPlaybackTime) - (tMins *60) - (tHours * 3600);
    currentTimeLabel.text = [NSString stringWithFormat:@"%i:%02d:%02d",tHours,tMins,tSecs];
    
    float percentagePlayed = currentSongPlaybackTime/currentSongDuration;
    [playbackProgressIndicator setProgress:percentagePlayed];
    //设置播放模式
    player.repeatMode = MPMusicRepeatModeAll;
    player.shuffleMode = MPMusicShuffleModeSongs;
}

-(void)viewWillAppear:(BOOL)animated
{
    [self registerMediaPlayerNotifications];
    [super viewWillAppear:animated];
}

-(void)registerMediaPlayerNotifications
{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    
    [notificationCenter addObserver:self selector:@selector(nowPlayingItemChanged:) name:MPMusicPlayerControllerNowPlayingItemDidChangeNotification object:player];
    [notificationCenter addObserver:self selector:@selector(playbackStateChanged:) name:MPMusicPlayerControllerPlaybackStateDidChangeNotification object:player];
    [notificationCenter addObserver:self selector:@selector(volumeChanged:) name:MPMusicPlayerControllerVolumeDidChangeNotification object:player];
    
    [player beginGeneratingPlaybackNotifications];
    
}


-(void)viewWillDisappear:(BOOL)animated
{
    
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    
    [notificationCenter removeObserver:self name:MPMusicPlayerControllerNowPlayingItemDidChangeNotification object:player];
    [notificationCenter removeObserver:self name:MPMusicPlayerControllerPlaybackStateDidChangeNotification object:player];
    [notificationCenter removeObserver:self name:MPMusicPlayerControllerVolumeDidChangeNotification object:player];
    
    [player endGeneratingPlaybackNotifications];
    
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

#pragma mark - media player callbacks
- (void)nowPlayingItemChanged:(id)notification
{
    MPMediaItem *currentItem = [player nowPlayingItem];
    UIImage *artworkImage = [UIImage imageNamed:@"noArt.png"];
    MPMediaItemArtwork *artwork = [currentItem valueForProperty:MPMediaItemPropertyArtwork];
    if (artwork) {
        artworkImage = [artwork imageWithSize:CGSizeMake(120, 120)];
        if (artworkImage == nil) {
            artworkImage = [UIImage imageNamed:@"noArt.png"];
        }
    }
    
    [albumImageView setImage:artworkImage];
    
    NSString *titleString = [currentItem valueForProperty:MPMediaItemPropertyTitle];
    if (titleString) {
        songLabel.text = [NSString stringWithFormat:@"%@",titleString];
    }else{
        songLabel.text = @"Unknown Song";
    }
    
    NSString *artistString = [currentItem valueForProperty:MPMediaItemPropertyArtist];
    if (artistString) {
        artistLabel.text = [NSString stringWithFormat:@"%@",artistString];
    }else{
        artistLabel.text = @"Unknown artist";
    }
    
    NSString *albumString = [currentItem valueForProperty:MPMediaItemPropertyAlbumTitle];
    if (albumString) {
        recordLabel.text = [NSString stringWithFormat:@"%@",albumString];
    }else{
        recordLabel.text = @"Unknown record";
    }
    
}

- (void)playbackStateChanged:(id)notification
{
    MPMusicPlaybackState playbackState = [player playbackState];
    
    if (playbackState == MPMusicPlaybackStatePaused) {
        [playButton setTitle:@"Play" forState:UIControlStateNormal];
        if ([playbackTimer isValid]) {
            [playbackTimer invalidate];
        }
    }else if (playbackState == MPMusicPlaybackStatePlaying)
    {
        [playButton setTitle:@"Pause" forState:UIControlStateNormal];
        playbackTimer  = [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(updateCurrentPlaybackTime) userInfo:nil repeats:YES];
    }else if (playbackState == MPMusicPlaybackStateStopped)
    {
        [playButton setTitle:@"Play" forState:UIControlStateNormal];
        [player stop];
        if ([playbackTimer isValid]) {
            [playbackTimer invalidate];
        }
    }
    
}

//音量
- (void)volumeChanged:(id)notification
{
    [volumeSlider setValue:[player volume]];
}

#pragma mark - user actions

- (IBAction)volumeSiderChanged:(id)sender
{
    [player setVolume:[volumeSlider value]];
}

- (IBAction)playButtonTouched:(id)sender
{
    if ([player playbackState]==MPMusicPlaybackStatePlaying) {
        [player pause];
    }else{
        [player play];
    }
}

- (IBAction)previousButtonTouched:(id)sender
{
    [player skipToPreviousItem];
    [self updateSongDuration];
}

- (IBAction)skipBack30Seconds:(id)sender
{
    int newPlayHead = player.currentPlaybackTime - 30;
    if (newPlayHead < 0) {
        newPlayHead = 0;
    }
    player.currentPlaybackTime = newPlayHead;
}

- (IBAction)nextButtonTouched:(id)sender
{
    [player skipToNextItem];
    [self updateSongDuration];
}

- (IBAction)skipForward30Seconds:(id)sender
{
    int newPlayHead = player.currentPlaybackTime + 30;
    if (newPlayHead > currentSongDuration) {
        [player skipToNextItem];
    }else{
        player.currentPlaybackTime = newPlayHead;
    }
}

#pragma mark - play song selection

- (IBAction)playRandomSongTouched:(id)sender
{
    MPMediaItem *itemToPlay = nil;
    MPMediaQuery *allSongQuery = [[MPMediaQuery alloc]init];
    NSArray *allTracks = [allSongQuery items];
    if ([allTracks count]==0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"No music found!" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
        [alert show];
        return;
    }
    if ([allTracks count] < 2) {
        itemToPlay = [allTracks lastObject];
    }
    int trackNumber = arc4random() % [allTracks count];
    itemToPlay = [allTracks objectAtIndex:trackNumber];
    
    MPMediaItemCollection *collection = [[MPMediaItemCollection alloc] initWithItems:[NSArray arrayWithObject:itemToPlay]];
    [player setQueueWithItemCollection:collection];
    [player play];
    
    [self updateSongDuration];
    [self updateCurrentPlaybackTime];
}

- (IBAction)playDylanTouched:(id)sender
{
    MPMediaPropertyPredicate *artistNamePredicate = [MPMediaPropertyPredicate predicateWithValue:@"程池&高颖" forProperty:MPMediaItemPropertyArtist];
    MPMediaQuery *artistQuery = [[MPMediaQuery alloc] init];
    [artistQuery addFilterPredicate:artistNamePredicate];
    NSArray *tracks = [artistQuery items];
    if ([tracks count]==0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"No music found!" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
        [alert show];
        return;
    }
    MPMediaItemCollection *collection = [[MPMediaItemCollection alloc]initWithItems:tracks];
    [player setQueueWithItemCollection:collection];
    [player play];
    
    [self updateSongDuration];
    [self updateCurrentPlaybackTime];
}



#pragma mark - Media Picker delegate


- (IBAction)mediaPickerButtonTouched:(id)sender
{
    MPMediaPickerController *mediaPicker = [[MPMediaPickerController alloc]initWithMediaTypes:MPMediaTypeAny];
    mediaPicker.delegate = self;
    mediaPicker.allowsPickingMultipleItems = YES;
    mediaPicker.prompt = @"Select songs to play";
    [self presentViewController:mediaPicker animated:YES completion:nil];
}

-(void)mediaPicker:(MPMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection
{
    if (mediaItemCollection) {
        [player setQueueWithItemCollection:mediaItemCollection];
        [player play];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
