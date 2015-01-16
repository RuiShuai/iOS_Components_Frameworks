//
//  RESSocialViewController.h
//  SocialNetworking
//
//  Created by taotao on 15/1/16.
//  Copyright (c) 2015年 RuiShuai Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>
#import <Accounts/Accounts.h>

@interface RESSocialViewController : UIViewController<UITextViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    ACAccount *facebookAccount;
    UIImage *attachmentImage;
    UIImagePickerController *pickerController;
}
@property (strong, nonatomic) IBOutlet UITextView *socialTextView;
@property (strong, nonatomic) IBOutlet UILabel *charCountLabel;

- (IBAction)attachImageTouched:(id)sender;
- (IBAction)twitterTouched:(id)sender;
- (IBAction)facebookTouched:(id)sender;

@end
