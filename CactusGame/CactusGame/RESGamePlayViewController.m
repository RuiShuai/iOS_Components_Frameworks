//
//  RESGameViewController.m
//  CactusGame
//
//  Created by taotao on 15/1/23.
//  Copyright (c) 2015年 RuiShuai Co., Ltd. All rights reserved.
//

#import "RESGamePlayViewController.h"

#define kLifeImageTag 100
#define kGameOverAlert 1
#define kPauseAlert 2
#define kLeaderboardIdentifier @"com.ruishuai.cactus.leaderboard"
#define kAchievementPlay5 @"com.ruishuai.cactus.play5"

#define kAchievementKillOne @"com.ruishuai.cactus.killOne"
#define kAchievementKillHundred @"com.ruishuai.cactus.killHundred"
#define kAchievementKillThousand @"com.ruishuai.cactus.killThousand"
#define kAchievementScore100 @"com.ruishuai.cactus.score100"
#define kAchievementPlay5Mins @"com.ruishuai.cactus.play5Mins"

@interface RESGamePlayViewController ()
{
    float screenWidth;
    float screenHeight;
}
@end

@implementation RESGamePlayViewController

#pragma mark -
#pragma mark View life cycle

- (void)viewDidLoad
{

    [self.navigationController setNavigationBarHidden:YES];
    
    screenWidth = [UIScreen mainScreen].bounds.size.width;
    screenHeight = [UIScreen mainScreen].bounds.size.height;

    [[RESGameCenterManager sharedManager] setDelegate:self];
    
    score = 0;
    life = 5;
    gameOver = NO;
    paused = NO;
    
    [super viewDidLoad];
    
    [self updateLife];
    
    //make one cactus right away
    [self performSelector:@selector(spawnCactus) withObject:nil];
    [self performSelector:@selector(spawnCactus) withObject:nil afterDelay:1.0];
    
    //timer
    play5MinTimer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(play5MinTick) userInfo:nil repeats:YES];
    
    //achievement
    [GKAchievementDescription loadAchievementDescriptionsWithCompletionHandler:^(NSArray *descriptions, NSError *error) {
        
        if (error!=nil) {
            NSLog(@"An error occurred loading achievement descriptions:%@",[error localizedDescription]);
        }
        
        for (GKAchievementDescription *achievementDescription in descriptions) {
            NSLog(@"%@",achievementDescription);
        }
        
    }];
    
}


-(void)viewWillDisappear:(BOOL)animated
{
    GKAchievement *play5MatchesAchievement = [[RESGameCenterManager sharedManager]achievementForIdentifier:kAchievementPlay5];
    
    if (![play5MatchesAchievement isCompleted]) {
        double matchesPlayed = [play5MatchesAchievement percentComplete]/20.0f;
        matchesPlayed++;
        
        [[RESGameCenterManager sharedManager] reportAchievement:kAchievementPlay5 withPercentageComplete:matchesPlayed*20.0f];
    }
    
    [super viewWillDisappear:animated];
}

-(BOOL)shouldAutorotate
{
    return YES;
}

- (void)didReceiveMemoryWarning
{

    scoreLabel = nil;
    duneOne = nil;
    duneTwo = nil;
    duneThree = nil;
    [super didReceiveMemoryWarning];
}

#pragma mark Game control

-(IBAction)pause:(id)sender
{
    paused = YES;
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"Game Paused!" delegate:self cancelButtonTitle:@"Exit" otherButtonTitles:@"Resume", nil];
    alert.tag = kPauseAlert;
    [alert show];
}



#pragma mark - 
#pragma mark Game Play

-(void)spawnCactus
{
    if  (gameOver)
    {
        return;
    }
    
    if (paused) {
        [self performSelector:@selector(spawnCactus) withObject:nil afterDelay:1];
        return;
    }
    
    int rowToSpawnIn = arc4random()%3;
    int horizontalLocation = (arc4random()%1024);
    
    int cactusSize = arc4random()%3;
    UIImage *cactusImage = nil;
    
    switch (cactusSize) {
        case 0:
            cactusImage = [UIImage imageNamed:@"CactusLarge.png"];
            break;
        case 1:
            cactusImage = [UIImage imageNamed:@"CactusMed.png"];
            break;
        case 2:
            cactusImage = [UIImage imageNamed:@"CactusSmall.png"];
            break;
        default:
            break;
    }
    
    if (horizontalLocation > screenWidth - cactusImage.size.width) {
        horizontalLocation = screenWidth - cactusImage.size.width;
    }
    
    UIImageView *duneToSpawnBehind = nil;
    
    switch (rowToSpawnIn) {
        case 0:
            duneToSpawnBehind = duneOne;
            break;
        case 1:
            duneToSpawnBehind = duneTwo;
            break;
        case 2:
            duneToSpawnBehind = duneThree;
            break;
        default:
            break;
    }
    
    float cactusHeight = cactusImage.size.height;
    float cactusWidth = cactusImage.size.width;
    
    //
    UIButton *cactus = [[UIButton alloc]initWithFrame:CGRectMake(horizontalLocation, duneToSpawnBehind.frame.origin.y, cactusWidth, cactusHeight)];
    [cactus setImage:cactusImage forState:UIControlStateNormal];
    [cactus addTarget:self action:@selector(cactusHit:) forControlEvents:UIControlEventTouchDown];
    [self.view insertSubview:cactus belowSubview:duneToSpawnBehind];
    
    //animation
    [UIView beginAnimations:@"slideInCactus" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.25];
    cactus.frame = CGRectMake(horizontalLocation, (duneToSpawnBehind.frame.origin.y-cactusHeight/2), cactusWidth, cactusWidth);
    [self performSelector:@selector(cactusMissed:) withObject:cactus afterDelay:2.0];
    
}

-(void)cactusHit:(UIButton *)sender
{
    [UIView animateWithDuration:0.1
                          delay:0.0
                        options:UIViewAnimationCurveLinear | UIViewAnimationOptionBeginFromCurrentState
                     animations:^
                        {
                            [sender setAlpha:0];
                        }
                     completion:^(BOOL finished)
                        {
                            [sender removeFromSuperview];
                        }];
    score++;
    [self displayNewScore:score];
    
    //achievement
    GKAchievement *killOneAchievement = [[RESGameCenterManager sharedManager] achievementForIdentifier:kAchievementKillOne];
    if (![killOneAchievement isCompleted]) {
        [[RESGameCenterManager sharedManager] reportAchievement:kAchievementKillOne withPercentageComplete:100.00];
    }
    
    GKAchievement *killThousandAchievement = [[RESGameCenterManager sharedManager]achievementForIdentifier:kAchievementKillThousand];
    double localKills = [[[NSUserDefaults standardUserDefaults]objectForKey:@"kills"] doubleValue];
    double remoteKills = [killThousandAchievement percentComplete]*10.0;
    if (remoteKills > localKills) {
        localKills = remoteKills;
    }
    
    localKills++;
    if (localKills <= 1000) {
        if (localKills <= 100) {
            [[RESGameCenterManager sharedManager] reportAchievement:kAchievementKillHundred withPercentageComplete:localKills];
        }
        [[RESGameCenterManager sharedManager] reportAchievement:kAchievementKillThousand withPercentageComplete:(localKills/10.0)];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithDouble:localKills] forKey:@"kills"];
    
    //next cactus
    [self performSelector:@selector(spawnCactus) withObject:nil afterDelay:(arc4random()%3)+.5];
    
}

-(void)cactusMissed:(UIButton *)sender
{
    if ([sender superview]==nil) {
        return;
    }
    if (paused) {
        return;
    }
    CGRect frame = sender.frame;
    frame.origin.y += sender.frame.size.height;
    
    [UIView animateWithDuration:0.1
                          delay:0.0
                        options:UIViewAnimationCurveLinear | UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         sender.frame = frame;
                     } completion:^(BOOL finished) {
                         [sender removeFromSuperview];
                         [self performSelector:@selector(spawnCactus) withObject:nil afterDelay:(arc4random()%3)+.5];
                         life--;
                         [self updateLife];
                     }];
    
}

-(void)updateLife
{
    UIImage *lifeImage = [UIImage imageNamed:@"heart.png"];
    for (UIView *view in [self.view subviews]) {
        if (view.tag == kLifeImageTag) {
            [view removeFromSuperview];
        }
    }
    
    for (int x=0 ; x < life; x++) {
        UIImageView *lifeImageView = [[UIImageView alloc]initWithImage:lifeImage];
        lifeImageView.tag = kLifeImageTag;
        CGRect frame = lifeImageView.frame;
        frame.origin.x = screenWidth - 45 - (x *30) ;
        frame.origin.y = 20;
        lifeImageView.frame = frame;
        
        [self.view addSubview:lifeImageView];
    }
    
    if (life == 0) {
        //report score
        [[RESGameCenterManager sharedManager] reportScore:(int64_t)score forLeaderboardID:kLeaderboardIdentifier];
        gameOver = YES;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Game over!" message:[NSString stringWithFormat:@"You scored %0.0f points!",score] delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        alert.tag = kGameOverAlert;
        [alert show];
    }
    
}

-(void)displayNewScore:(float)updatedScore
{
    int scoreInt = score;
    if (scoreInt % 10 == 0 && score <= 50) {
        [self spawnCactus];
    }
    
    scoreLabel.text = [NSString stringWithFormat:@"%06.0f",updatedScore];
    
    //achievement
    GKAchievement *score100Achievement = [[RESGameCenterManager sharedManager]achievementForIdentifier:kAchievementScore100];
    if (![score100Achievement isCompleted]) {
        [[RESGameCenterManager sharedManager] reportAchievement:kAchievementScore100 withPercentageComplete:score];
    }
}


-(void)play5MinTick
{
    if (paused || gameOver) {
        return;
    }
    GKAchievement *play5MinAchievement = [[RESGameCenterManager sharedManager]achievementForIdentifier:kAchievementPlay5Mins];
    if ([play5MinAchievement isCompleted]) {
        [play5MinTimer invalidate];
        play5MinTimer = nil;
        return;
    }
    
    double percentageComplete = play5MinAchievement.percentComplete + 1.0;
    [[RESGameCenterManager sharedManager] reportAchievement:kAchievementPlay5Mins withPercentageComplete:percentageComplete];
    
}

#pragma mark - 
#pragma mark UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == kGameOverAlert) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if (alertView.tag == kPauseAlert)
    {
        if (buttonIndex == 0) {//exit
            //report score
            [[RESGameCenterManager sharedManager] reportScore:(int64_t)score forLeaderboardID:kLeaderboardIdentifier];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else//resume
        {
            paused = NO;
        }
    }
    
}

#pragma mark - 
#pragma mark GameCenterManagerDelegate
-(void)gameCenterScoreReported:(NSError *)error
{
    if (error != nil) {
        NSLog(@"An error occurred trying to report a score to Game Center:%@",[error localizedDescription]);
    }
    else
    {
        NSLog(@"Successfully submitted score");
    }
}

-(void)gameCenterAchievementReported:(NSError *)error
{
    if(error != nil)
    {
        NSLog(@"An error occurred trying to report an achievement to Game Center: %@", [error localizedDescription]);
    }
    
    else
    {
        NSLog(@"Achievement successfully updated");
    }
}

#pragma mark - Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
