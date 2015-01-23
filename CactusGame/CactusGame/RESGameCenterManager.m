//
//  RESGameCenterManager.m
//  CactusGame
//
//  Created by taotao on 15/1/23.
//  Copyright (c) 2015年 RuiShuai Co., Ltd. All rights reserved.
//

#import "RESGameCenterManager.h"

@implementation RESGameCenterManager

static RESGameCenterManager *sharedManager = nil;

#pragma mark -
#pragma mark Overhead

+(RESGameCenterManager *)sharedManager
{
    @synchronized(self)
    {
        if (sharedManager == nil) {
            sharedManager = [[self alloc] init];
        }
    }
    return sharedManager;
}




#pragma mark - 
#pragma mark Authentication

-(void)authenticateLocalUser
{
    if ([GKLocalPlayer localPlayer].authenticated == NO) {
        
        [[GKLocalPlayer localPlayer]loadDefaultLeaderboardIdentifierWithCompletionHandler:^(NSString *leaderboardIdentifier, NSError *error) {
            
            if (error!=nil)
            {
                if ([error code] == GKErrorNotSupported)
                {
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"This device does not support Game Center" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
                    [alert show];
                }
                else if ([error code]==GKErrorCancelled)
                {
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"This device has failed login too many times from the app, you will need to login from the Game Center.app" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
                    [alert show];
                }
                else
                {
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
                    [alert show];
                }
                return;
            }
            
            //call delegate perform gameCenterLoggedIn:
            [self callDelegateOnMainThread:@selector(gameCenterLoggedIn:) withArg:NULL error:error];
            //
            [self submitAllSavedScores];
            
            //Remove comment to reset all achievements on authenication
            //[self resetAchievements];
            
            [self populateAchievementCache];
            
        }];
        
        //[[GKLocalPlayer localPlayer] authenticateWithCompletionHandler:^(NSError *error) {}];
    }
}

-(void)authenticateLocalUseriOS8
{
    if ([GKLocalPlayer localPlayer].authenticateHandler == nil)
    {
        [[GKLocalPlayer localPlayer] setAuthenticateHandler:^(UIViewController *viewController, NSError *error)
        {
            
            if (error!=nil) {
                if ([error code]==GKErrorNotSupported)
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"This device does not support Game Center" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
                    [alert show];
                }
                else if ([error code]==GKErrorCancelled)
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"This device has failed login too many times from the app, you will need to login from the Game Center.app" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
                    [alert show];
                }
                else
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
                    [alert show];
                }
            }
            else
            {
                if (viewController !=nil) {
                    [(UIViewController *)self.delegate presentViewController:viewController animated:YES completion:nil];
                }
                //
                [self submitAllSavedScores];
               
                [self populateAchievementCache];
            }
            
        }];
    }
}

#pragma mark delegate method

-(void)callDelegateOnMainThread:(SEL)selector withArg:(id)arg error:(NSError *)error
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self callDelegate:selector withArg:arg error:error];
    });
}

-(void)callDelegate:(SEL)selector withArg:(id)arg error:(NSError *)error
{
    assert([NSThread isMainThread]);
    
    if (self.delegate == nil) {
        NSLog(@"Game Center Manager delegate has not been set");
        return;
    }
    
    if ([self.delegate respondsToSelector:selector])
    {
        if (arg!=NULL)
        {
            [self.delegate performSelector:selector withObject:arg withObject:error];
        }
        else
        {
            [self.delegate performSelector:selector withObject:error];
        }
    }
    else
    {
        NSLog(@"Unable to find delegate method '%s' is class %@",sel_getName(selector),[self.delegate class]);
    }
    
}
#pragma mark - 
#pragma mark Scores

-(void)submitAllSavedScores
{
    NSMutableArray *savedScoreArray = [[NSMutableArray alloc]initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"savedScores"]];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"savedScores"];
    
    for (NSData *scoreData in savedScoreArray)
    {
        GKScore *scoreReporter = [NSKeyedUnarchiver unarchiveObjectWithData:scoreData];
        scoreReporter.shouldSetDefaultLeaderboard = YES;
        
        [scoreReporter reportScoreWithCompletionHandler:^(NSError *error) {
            
            if (error != nil) {
                NSData *savedScoreData = [NSKeyedArchiver archivedDataWithRootObject:scoreReporter];
                //storeScoreForLater
                [self storeScoreForLater:savedScoreData];
            }else{
                NSLog(@"Successfully submitted scores that were pending submission");
                [self callDelegateOnMainThread:@selector(gameCenterScoreReported:) withArg:NULL error:error];
            }
            
        }];
    }
}


-(void)storeScoreForLater:(NSData *)scoreData;
{
    NSMutableArray *savedScoresArray = [[NSMutableArray alloc]initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"savedScores"]];
    [savedScoresArray addObject:scoreData];
    [[NSUserDefaults standardUserDefaults] setObject:savedScoresArray forKey:@"savedScores"];
}

-(void)reportScore:(int64_t)score forLeaderboardID:(NSString *)identifier
{
    
    
    GKScore *scoreReporter = [[GKScore alloc] initWithLeaderboardIdentifier:identifier];
    scoreReporter.value = score;
    
    [scoreReporter reportScoreWithCompletionHandler:^(NSError *error) {
        if (error != nil) {
            NSData *savedScoreData = [NSKeyedArchiver archivedDataWithRootObject:scoreReporter];
            [self storeScoreForLater:savedScoreData];
            
        }
        
        [self callDelegateOnMainThread:@selector(gameCenterScoreReported:) withArg:NULL error:error];
    }];
}


#pragma mark -
#pragma mark Achievements
-(GKAchievement *)achievementForIdentifier:(NSString *)identifier
{
    GKAchievement *achievement = nil;
    achievement = [self.achievementDictionary objectForKey:identifier];
    if (achievement==nil) {
        achievement = [[GKAchievement alloc]initWithIdentifier:identifier];
        [self.achievementDictionary setObject:achievement forKey:identifier];
    }
    return achievement;
}

-(void)reportAchievement:(NSString *)identifier withPercentageComplete:(double)percentComplete
{
    if (self.achievementDictionary == nil) {
        NSLog(@"An achievement cache must be populated before submitting achievement progress");
        return;
    }
    
    GKAchievement *achievement = [self.achievementDictionary objectForKey:identifier];
    if (achievement == nil) {
        achievement = [[GKAchievement alloc]initWithIdentifier:identifier];
        [achievement setPercentComplete:percentComplete];
        [self.achievementDictionary setObject:achievement forKey:identifier];
    }
    else
    {
        if ([achievement percentComplete]>=100.0 || [achievement percentComplete] >= percentComplete)
        {
            NSLog(@"Attempting to update achievement %@ which is either already completed or is decreasing percentage complete (%f)",identifier,percentComplete);
            return;
        }
        [achievement setPercentComplete:percentComplete];
        [self.achievementDictionary setObject:achievement forKey:identifier];
    }
    
    achievement.showsCompletionBanner = YES;
    [achievement reportAchievementWithCompletionHandler:^(NSError *error)
    {
        if (error!=nil)
        {
            NSLog(@"There was an error submitting achievement %@: %@",identifier,[error localizedDescription]);
        }
        [self callDelegateOnMainThread:@selector(gameCenterAchievementReported:) withArg:NULL error:error];
    }];
    
}

-(void)resetAchievements
{
    [self.achievementDictionary removeAllObjects];
    
    [GKAchievement resetAchievementsWithCompletionHandler:^(NSError *error)
    {
        if (error==nil) {
            NSLog(@"All achievements have been successfully reset");
        }else{
            NSLog(@"Unable to reset achievements :%@",[error localizedDescription]);
        }
    }];
    
}

-(void)populateAchievementCache
{
    if (self.achievementDictionary != nil)
    {
        NSLog(@"Repopulating achievement cache: %@",self.achievementDictionary);
    }
    else
    {
        self.achievementDictionary = [[NSMutableDictionary alloc]init];
    }
    
    [GKAchievement loadAchievementsWithCompletionHandler:^(NSArray *achievements, NSError *error) {
        if (error!=nil) {
            NSLog(@"An error occurred while populating the achievementcache: %@",[error localizedDescription]);
        }
        else{
            for (GKAchievement *achievement in achievements) {
                [self.achievementDictionary setObject:achievement forKey:[achievement identifier]];
            }
        }
    }];
    
}

@end
