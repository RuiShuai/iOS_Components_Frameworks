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

@end
