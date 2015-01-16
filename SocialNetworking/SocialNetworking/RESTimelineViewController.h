//
//  RESTimelineViewController.h
//  SocialNetworking
//
//  Created by taotao on 15/1/16.
//  Copyright (c) 2015年 RuiShuai Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RESTimelineViewController : UITableViewController

@property (nonatomic,strong) NSArray *timelineData;

- (IBAction)dismissTouched:(id)sender;


@end
