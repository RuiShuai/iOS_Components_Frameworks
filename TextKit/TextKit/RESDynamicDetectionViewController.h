//
//  RESDynamicDetectionViewController.h
//  TextKit
//
//  Created by taotao on 15/1/12.
//  Copyright (c) 2015年 RuiShuai Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RESDynamicDetectionViewController : UIViewController<UITextViewDelegate,UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet UITextView *textView;

@property (strong, nonatomic) NSURL *toBelaunchURL;

@end
