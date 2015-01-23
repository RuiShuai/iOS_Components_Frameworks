//
//  RESGameViewController.h
//  CactusGame
//
//  Created by taotao on 15/1/23.
//  Copyright (c) 2015年 RuiShuai Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RESGameCenterManager.h"

@interface RESGamePlayViewController : UIViewController<GameCenterManagerDelegate,UIAlertViewDelegate>
{
    IBOutlet UILabel *scoreLabel;
    float score;
    int life;
    
    BOOL gameOver;
    BOOL paused;
    
    IBOutlet UIImageView *duneOne;
    IBOutlet UIImageView *duneTwo;
    IBOutlet UIImageView *duneThree;
    
    NSTimer *play5MinTimer;
}

-(IBAction)pause:(id)sender;

-(void)spawnCactus;
-(void)cactusHit:(UIButton *)sender;
-(void)cactusMissed:(UIButton *)sender;
-(void)updateLife;
-(void)displayNewScore:(float)updatedScore;
-(void)play5MinTick;



@end
