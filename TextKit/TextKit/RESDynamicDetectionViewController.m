//
//  RESDynamicDetectionViewController.m
//  TextKit
//
//  Created by taotao on 15/1/12.
//  Copyright (c) 2015年 RuiShuai Co., Ltd. All rights reserved.
//

#import "RESDynamicDetectionViewController.h"

@interface RESDynamicDetectionViewController ()

@end

@implementation RESDynamicDetectionViewController

#pragma mark - view life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.textView setDataDetectorTypes:UIDataDetectorTypePhoneNumber | UIDataDetectorTypeLink | UIDataDetectorTypeAddress | UIDataDetectorTypeCalendarEvent];
    NSString *originText = self.textView.text;
    NSString *appendText = @"Website: http://www.pearsoned.com\nPhone: (310) 597-3781\nAddress: 1 infinite loop cupertino ca 95014\nWhen: July 15th at 7pm PST";
    [self.textView setText:[NSString stringWithFormat:@"%@\n\n\n%@",appendText,originText]];
    [self.textView setDelegate:self];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

#pragma mark - TextView delegate
- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange
{
    NSLog(@"%@",NSStringFromSelector(_cmd));
    self.toBelaunchURL = URL;
    NSLog(@"%@",self.toBelaunchURL);
    
    if ([[URL absoluteString] hasPrefix:@"http://"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"URL Launching" message:[NSString stringWithFormat:@"About to launch %@",[URL absoluteString]] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Launch", nil];
        [alert setDelegate:self];
        [alert show];
        return NO;
    }
    
    return YES;
}


#pragma mark - AlertView delegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        return;
    }
    else{
        [[UIApplication sharedApplication] openURL:self.toBelaunchURL];
    }
}



@end
