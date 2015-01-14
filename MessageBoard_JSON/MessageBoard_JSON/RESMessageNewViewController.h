//
//  RESMessageNewViewController.h
//  MessageBoard_JSON
//
//  Created by taotao on 15/1/13.
//  Copyright (c) 2015年 RuiShuai Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kMessageBoardURLString     @"http://freezing-cloud-6077.herokuapp.com/messages.json"

@protocol RESMessageEditDelegate <NSObject>

-(void)createNewMessage:(NSDictionary *)messageDict withPostError:(NSError *)error;

@end

@interface RESMessageNewViewController : UIViewController<UITextFieldDelegate,UITextViewDelegate,NSURLConnectionDelegate,NSURLConnectionDataDelegate>

@property (nonatomic,strong) NSDictionary *messageDict;
@property (nonatomic,weak) id<RESMessageEditDelegate> delegate;
@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) IBOutlet UITextView *messageTextView;



- (IBAction)cancelButtonTouched:(id)sender;

- (IBAction)saveButtonTouched:(id)sender;

@end
