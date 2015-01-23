//
//  RESGameControlViewController.m
//  CactusGame
//
//  Created by taotao on 15/1/23.
//  Copyright (c) 2015年 RuiShuai Co., Ltd. All rights reserved.
//

#import "RESGameControlViewController.h"
#import "RESGamePlayViewController.h"

#define kLeaderboardIdentifier @"com.ruishuai.cactus.leaderboard"

@interface RESGameControlViewController ()

@end

@implementation RESGameControlViewController


#pragma mark - 
#pragma mark View Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.navigationController setNavigationBarHidden:YES];
    
    [[RESGameCenterManager sharedManager] setDelegate:self];
    
    //Depending upon OS requirements either method may be used.
    
    [[RESGameCenterManager sharedManager] authenticateLocalUser];
    //[[RESGameCenterManager sharedManager] authenticateLocalUseriOS8];
    
    
}

-(BOOL)shouldAutorotate
{
    return YES;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[RESGameCenterManager sharedManager] setDelegate:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}



#pragma mark - 
#pragma mark Game Control
- (IBAction)play:(id)sender
{
    //segue
    //[self performSegueWithIdentifier:@"playGameSegue" sender:sender];
}

- (IBAction)leaderboards:(id)sender
{
    GKGameCenterViewController *leaderboardVC = [[GKGameCenterViewController alloc]init];
    if (leaderboardVC == nil) {
        NSLog(@"Unable to create leaderboard view controller");
        return;
    }

    leaderboardVC.gameCenterDelegate = self;
    leaderboardVC.viewState = GKGameCenterViewControllerStateLeaderboards;
    leaderboardVC.leaderboardTimeScope = GKLeaderboardTimeScopeToday;
    leaderboardVC.leaderboardIdentifier = kLeaderboardIdentifier;
    [self presentViewController:leaderboardVC animated:YES completion:nil];
}

- (IBAction)achievements:(id)sender
{
    GKGameCenterViewController *achievementVC = [[GKGameCenterViewController alloc]init];
    if (achievementVC == nil) {
        NSLog(@"Unable to create achievement view controller");
        return;
    }
    
    achievementVC.gameCenterDelegate = self;
    achievementVC.viewState = GKGameCenterViewControllerStateAchievements;
    
    [self presentViewController:achievementVC animated:YES completion:nil];
}


#pragma mark - 
#pragma mark GKGameCenterViewControllerDelegate
-(void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark - 
#pragma mark GameCenter delegate
-(void)gameCenterLoggedIn:(NSError *)error
{
    if (error!=nil) {
        NSLog(@"An error occurred trying to log into Game Center: %@", [error localizedDescription]);
    }
    else
    {
        NSLog(@"Successfully logged into Game Center!");
    }
}

-(void)scoreDataUpdated:(NSArray *)scores error:(NSError *)error
{
    if (error!=nil) {
        NSLog(@"An error occurred trying to report a score to Game Center:%@",[error localizedDescription]);
    }
    else
    {
        NSLog(@"Successfully submitted score");
    }
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if  ([[segue identifier] isEqualToString:@"playGameSegue"])
    {
        //segue.destinationViewController
    }
}


@end
