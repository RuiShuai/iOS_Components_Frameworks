//
//  RESMessageBoardViewController.h
//  MessageBoard_JSON
//
//  Created by taotao on 15/1/13.
//  Copyright (c) 2015年 RuiShuai Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RESMessageNewViewController.h"

#define kMessageBoardURLString     @"http://freezing-cloud-6077.herokuapp.com/messages.json"

//@protocol RESMessageEditDelegate;

@interface RESMessageBoardViewController : UITableViewController<NSURLConnectionDelegate,NSURLConnectionDataDelegate,RESMessageEditDelegate>

@property (nonatomic,strong) NSArray *messageArray;


- (IBAction)newMessageTouched:(id)sender;

@end
