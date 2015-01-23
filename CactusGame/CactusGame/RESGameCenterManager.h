//
//  RESGameCenterManager.h
//  CactusGame
//
//  Created by taotao on 15/1/23.
//  Copyright (c) 2015年 RuiShuai Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>

@protocol GameCenterManagerDelegate <NSObject>
@optional
-(void)gameCenterLoggedIn:(NSError *)error;
-(void)gameCenterScoreReported:(NSError *)error;
-(void)scoreDataUpdated:(NSArray *)scores error:(NSError *)error;
-(void)gameCenterAchievementReported:(NSError *)error;
@end

@interface RESGameCenterManager : NSObject

@property (weak,nonatomic) id<GameCenterManagerDelegate> delegate;
@property (strong,nonatomic) NSMutableDictionary *achievementDictionary;

+(RESGameCenterManager *)sharedManager;

-(void)authenticateLocalUser;
-(void)authenticateLocalUseriOS8;
-(void)reportScore:(int64_t)score forLeaderboardID:(NSString *)identifier;

-(GKAchievement *)achievementForIdentifier:(NSString *)identifier;
-(void)reportAchievement:(NSString *)identifier withPercentageComplete:(double)percentComplete;
-(void)resetAchievements;


@end
