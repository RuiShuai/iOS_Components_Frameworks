//
//  RESSocialViewController.m
//  SocialNetworking
//
//  Created by taotao on 15/1/16.
//  Copyright (c) 2015年 RuiShuai Co., Ltd. All rights reserved.
//

#import "RESSocialViewController.h"
#import "RESTimelineViewController.h"
#define kActionSheetTwitter 1
#define kActionSheetFacebook 2
#define kActionSheetSinaWeibo 3
#define kInputCharacterLimit 140
#define kAppIDRegisterInFacebook @"363120920441086"
#define kAppIDRegisterInSinaWeibo @"3583465162"
@interface RESSocialViewController ()

@end

@implementation RESSocialViewController

#pragma mark - view life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //test facebook
    ACAccountStore *accountStore = [[ACAccountStore alloc]init];
    ACAccountType *facebookAccountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
    NSDictionary *options = @{
                              ACFacebookAudienceKey:ACFacebookAudienceEveryone,
                              ACFacebookAppIdKey:kAppIDRegisterInFacebook,
                              ACFacebookPermissionsKey:@[@"email"]};
    [accountStore requestAccessToAccountsWithType:facebookAccountType options:options completion:^(BOOL granted, NSError *error) {
        if (granted) {
            NSLog(@"Basic access granted");
        }else{
            NSLog(@"Basic access denied");
        }
    }];
    
    //textView
    [self.socialTextView setDelegate:self];
    [self.socialTextView becomeFirstResponder];
    
}



#pragma mark - ActionSheet Routing
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //facebook
    if (actionSheet.tag == kActionSheetFacebook) {
        
        //pre-define: facebook accountType
        ACAccountStore *accountStore = [[ACAccountStore alloc]init];
        ACAccountType *facebookAccountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
        NSDictionary *options = nil;
        NSLog(@"Publish permission granted");
        NSLog(@"Publish permission denied");
        
        //case 0:composer
        if (buttonIndex == 0) {
            
            [self facebookComposer];
        }
        //case 1:autopost
        else if (buttonIndex == 1){
            options = @{ACFacebookAudienceKey:ACFacebookAudienceEveryone,
                        ACFacebookAppIdKey:kAppIDRegisterInFacebook,
                        ACFacebookPermissionsKey:@[@"publish_stream"]};
            [accountStore requestAccessToAccountsWithType:facebookAccountType options:options completion:^(BOOL granted, NSError *error) {
                if (granted) {
                    //默认用最后一个账号
                    NSArray *accounts = [accountStore accountsWithAccountType:facebookAccountType];
                    
                    facebookAccount = [accounts lastObject];
                    
                    //facebookAutopost
                    [self performSelectorOnMainThread:@selector(facebookAutopost) withObject:nil waitUntilDone:NO];
                }
            }];
            
        }
        //case 2:timeline
        else if (buttonIndex == 2){
            
            options = @{ACFacebookAudienceKey:ACFacebookAudienceEveryone,
                        ACFacebookAppIdKey:kAppIDRegisterInFacebook,
                        ACFacebookPermissionsKey:@[@"read_stream"]
                        };
            [accountStore requestAccessToAccountsWithType:facebookAccountType options:options completion:^(BOOL granted, NSError *error) {
                
                if (granted) {
                    //last account
                    NSArray *accounts = [accountStore accountsWithAccountType:facebookAccountType];
                    facebookAccount = [accounts lastObject];
                    
                    //timeline
                    [self performSelectorOnMainThread:@selector(facebookTimeline) withObject:nil waitUntilDone:NO];
                }
                else {
                    [self performSelectorOnMainThread:@selector(facebookError:) withObject:error waitUntilDone:NO];
                }
                
            }];
        }

        
    }
    //twitter
    else if (actionSheet.tag == kActionSheetTwitter){
        switch (buttonIndex) {
            case 0:
                [self twitterComposer];
                break;
            case 1:
                [self twitterAutopost];
                break;
            case 2:
                [self twitterTimeline];
                break;
            default:
                break;
        }
        
        
    }
    
    //sinaWeibo
    else if (actionSheet.tag == kActionSheetSinaWeibo){
        switch (buttonIndex) {
            case 0:
                [self sinaWeiboComposer];
                break;
            case 1:
                [self sinaWeiboPost];
                break;
            case 2:
                [self sinaWeiboTimeline];
                break;
            default:
                break;
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


#pragma mark - facebook action
- (IBAction)facebookTouched:(id)sender
{
    //why force onMainThread?
    //[self performSelectorOnMainThread:@selector(showFacebookActionSheet) withObject:nil waitUntilDone:NO];
    
    [self performSelectorOnMainThread:@selector(showSinaWeiboActionSheet) withObject:nil waitUntilDone:NO];
    
}

- (void)showFacebookActionSheet
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"Facebook Actions" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Composer","Auto-post",@"Timeline", nil];
    actionSheet.tag = kActionSheetFacebook;
    [actionSheet showInView:self.view];
}

//iphone内置账号
- (void)facebookComposer
{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        SLComposeViewControllerCompletionHandler myBlock = ^(SLComposeViewControllerResult result){
            if (result == SLComposeViewControllerResultCancelled) {
                NSLog(@"Cancelled");
            }else{
                NSLog(@"Done");
            }
            
            [controller dismissViewControllerAnimated:YES completion:^{
                [self.socialTextView becomeFirstResponder];
            }];
            
        };
        
        controller.completionHandler = myBlock;
        
        [controller setInitialText:self.socialTextView.text];
        
        [self presentViewController:controller animated:YES completion:nil];
    }else{
        NSLog(@"facebook UnAvailable");
    }
}

- (void)facebookAutopost
{
    NSDictionary *parameters = [NSDictionary dictionaryWithObject:self.socialTextView.text forKey:@"message"];
    NSURL *feedURL = nil;
    
    if (attachmentImage) {
        feedURL = [NSURL URLWithString:@"https://graph.facebook.com/me/photos"];
    }else{
        feedURL = [NSURL URLWithString:@"https://graph.facebook.com/me/feed"];
    }
    
    SLRequest *feedRequest = [SLRequest requestForServiceType:SLServiceTypeFacebook requestMethod:SLRequestMethodPOST URL:feedURL parameters:parameters];
    
    if (attachmentImage) {
        //png
        NSData *imageData = UIImagePNGRepresentation(attachmentImage);
        [feedRequest addMultipartData:imageData withName:@"source" type:@"multipart/form-data" filename:@"Image"];
        
    }
    
    feedRequest.account = facebookAccount;
    
    [feedRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        NSLog(@"Facebook post status code: %d",(int)[urlResponse statusCode]);
        
        if ([urlResponse statusCode] == 200) {
            [self performSelectorOnMainThread:@selector(reportSuccessOrError:) withObject:@"Your message has been posted to Facebook" waitUntilDone:NO];
        }
        else if (error != nil){
            [self performSelectorOnMainThread:@selector(facebookError:) withObject:error waitUntilDone:NO];
        }
        
        
    }];
    
}

- (void)facebookTimeline
{
    NSURL *feedURL = [NSURL URLWithString:@"https://graph.facebook.com/me/feed"];
    
    SLRequest *feedRequest = [SLRequest requestForServiceType:SLServiceTypeFacebook requestMethod:SLRequestMethodGET URL:feedURL parameters:nil];
    
    feedRequest.account = facebookAccount;
    
    [feedRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        
        NSLog(@"Facebook post statusCode: %d",(int)[urlResponse statusCode]);
        
        if ([urlResponse statusCode]==200) {
            
            NSLog(@"%@",[[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error] objectForKey:@"data"]);
            
            [self performSelectorOnMainThread:@selector(presentTimeline:) withObject:[[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error] objectForKey:@"data"] waitUntilDone:NO];
        }
        else if (error != nil){
            
            [self performSelectorOnMainThread:@selector(facebookError:) withObject:error waitUntilDone:NO];
        }
        
        
    }];
    
}

- (void)facebookError:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
    [alert show];
}


#pragma mark - twitter action

- (IBAction)twitterTouched:(id)sender
{
    //用actionSheet弹出
    [self performSelectorOnMainThread:@selector(showTwitterActionSheet) withObject:nil waitUntilDone:NO];
    
}

-(void)showTwitterActionSheet
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Twitter Actions" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Composer", @"Auto-Post", @"Timeline", nil];
    actionSheet.tag = kActionSheetTwitter;
    [actionSheet showInView: self.view];
    
}

- (void)twitterComposer//调用iphone中自带的account
{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        //
        SLComposeViewController *cvc = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        
        SLComposeViewControllerCompletionHandler myBlock = ^(SLComposeViewControllerResult result){
            if (result == SLComposeViewControllerResultCancelled) {
                NSLog(@"Cancelled");
            }
            else{
                NSLog(@"Done");
            }
            //
            [cvc dismissViewControllerAnimated:YES completion:nil];
            [self.socialTextView becomeFirstResponder];
        };
        
        cvc.completionHandler = myBlock;
        
        [cvc setInitialText:@"Check out my app:"];
        [cvc addImage:[UIImage imageNamed:@"Kitten.jpg"]];
        [cvc addURL:[NSURL URLWithString:@"http://amzn.to/Um85L0"]];
        
        
        [cvc removeAllImages];
        [cvc removeAllURLs];
        
        [self presentViewController:cvc animated:YES completion:nil];
        
        
    }else{
        NSLog(@"Twitter composer is not aviable.");
    }
}

- (void)twitterAutopost
{
    ACAccountStore *account = [[ACAccountStore alloc]init];
    ACAccountType *accountType = [account accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    [account requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error) {
        if (error!=nil) {
            [self performSelectorOnMainThread:@selector(reportSuccessOrError:) withObject:[error localizedDescription] waitUntilDone:NO];
        }
        
        if (granted == YES) {
            NSArray *arrayOfAccounts =[account accountsWithAccountType:accountType];
            if ([arrayOfAccounts count] > 0) {
                
                ACAccount *twitterAccount = [arrayOfAccounts lastObject];
                
                NSURL *requestURL = nil;
                
                if (attachmentImage) {
                    requestURL = [NSURL URLWithString:@"https://update.twitter.com/1/statuses/update_with_media.json"];
                }else{
                    requestURL = [NSURL URLWithString:@"http://api.twitter.com/1/statuses/update.json"];
                }
                
                SLRequest *postRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodPOST URL:requestURL parameters:nil];
                
                if (self.socialTextView.text) {
                    [postRequest addMultipartData:[@"A Tweet Text!" dataUsingEncoding:NSUTF8StringEncoding] withName:@"status" type:@"multipart/form-data" filename:nil];
                }
                
                if (attachmentImage) {
                    NSData *imageData = UIImageJPEGRepresentation(attachmentImage, 1.0);
                    [postRequest addMultipartData:imageData withName:@"media" type:@"image/jpg" filename:@"Image.jpg"];
                }
                
                postRequest.account = twitterAccount;
                
                //perform
                [postRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                    if (error != nil) {
                        [self performSelectorOnMainThread:@selector(reportSuccessOrError:) withObject:[error localizedDescription] waitUntilDone:NO];
                    }
                    
                    if ([urlResponse statusCode] == 200) {
                        [self performSelectorOnMainThread:@selector(reportSuccessOrError:) withObject:@"Your message has been posted to Twitter" waitUntilDone:NO];
                    }
                    
                }];
                
            }
        }else{
            NSLog(@"Access Denied");
        }
        
    }];
    
    
}

- (void)reportSuccessOrError:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
    [alert show];
    
    //self.socialTextView.text = nil;
}

- (void)twitterTimeline
{
    ACAccountStore *accountStore = [[ACAccountStore alloc]init];
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    [accountStore requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error) {
        
        if (error!=nil) {
            [self performSelectorOnMainThread:@selector(reportSuccessOrError:) withObject:[error localizedDescription] waitUntilDone:NO];
        }
        
        if (granted == YES) {
            
            NSArray *arrayOfAccounts = [accountStore accountsWithAccountType:accountType];
            
            if ([arrayOfAccounts count]>0) {
                
                ACAccount *twitterAccount = [arrayOfAccounts lastObject];
                
                NSURL *requestURL = [NSURL URLWithString:@"http://api.twitter.com/1/statuses/home_timeline.json"];
                NSDictionary *options = @{@"count":@"20",@"include_entities":@"1"};
                
                SLRequest *postRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:requestURL parameters:options];
                
                postRequest.account = twitterAccount;
                
                [postRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {

                    NSLog(@"SinaWeibo post statusCode: %u",(int)[urlResponse statusCode]);
                    
                    if ([urlResponse statusCode] == 200) {
                        NSLog(@"%@", [[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error] objectForKey:@"data"]);
                        
                        [self performSelectorOnMainThread:@selector(presentTimeline:) withObject:[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error] waitUntilDone:NO];
                        
                    }else if (error != nil) {
                        [self performSelectorOnMainThread:@selector(sinaWeiboError:) withObject:error waitUntilDone:NO];
                        
                    }
                    
                    
                }];
            }
            
        }
    }];
    
    
}


#pragma mark - sinaweibo action
- (void)showSinaWeiboActionSheet
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"SinaWeibo Actions" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Composer",@"Auto-Post",@"Timeline",nil];
    actionSheet.tag = kActionSheetSinaWeibo;
    [actionSheet showInView:self.view];
}

- (void)sinaWeiboComposer
{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeSinaWeibo]) {
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeSinaWeibo];
        
        SLComposeViewControllerCompletionHandler myBlock = ^(SLComposeViewControllerResult result){
            if (result == SLComposeViewControllerResultCancelled) {
                NSLog(@"Cancelled");
            }else{
                NSLog(@"Done");
            }
            
            [controller dismissViewControllerAnimated:YES completion:^{
                [self.socialTextView becomeFirstResponder];
            }];
            
        };
        
        controller.completionHandler = myBlock;
        
        [controller setInitialText:@"Check out my app:"];
        [controller addImage:[UIImage imageNamed:@"Kitten.jpg"]];
        [controller addURL:[NSURL URLWithString:@"http://amzn.to/Um85L0"]];
        [controller removeAllImages];
        [controller removeAllURLs];
        
        [self presentViewController:controller animated:YES completion:nil];
    }else{
        NSLog(@"SinaWeibo Composer is not available.");
    }
}

-(void)sinaWeiboPost
{
    ACAccountStore *accountStore = [[ACAccountStore alloc]init];
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierSinaWeibo];
    [accountStore requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error) {
        
        if (error!=nil) {
            [self performSelectorOnMainThread:@selector(reportSuccessOrError:) withObject:[error localizedDescription] waitUntilDone:NO];
        }
        
        if (granted == YES) {
            NSArray *arrayOfAccounts = [accountStore accountsWithAccountType:accountType];
            if ([arrayOfAccounts count] > 0) {
                ACAccount *sinaWeiboAccount = [arrayOfAccounts lastObject];
                NSURL *requestURL = nil;
                
                if (attachmentImage) {
                    requestURL = [NSURL URLWithString:@"http://api.t.sina.com.cn/statuses/upload_url_text.json"];
                }else{
                    requestURL = [NSURL URLWithString:@"http://api.t.sina.com.cn/statuses/update.json"];
                }
                
                SLRequest *postRequest = [SLRequest requestForServiceType:SLServiceTypeSinaWeibo requestMethod:SLRequestMethodPOST URL:requestURL parameters:nil];
                
                if (self.socialTextView.text) {
                    [postRequest addMultipartData:[@"A sina weibo Test!" dataUsingEncoding:NSUTF8StringEncoding] withName:@"status" type:@"multipart/form-data" filename:nil];
                }
                
                if (attachmentImage) {
                    NSData *imageData = UIImageJPEGRepresentation(attachmentImage, 1.0);
                    [postRequest addMultipartData:imageData withName:@"media" type:@"image/jpg" filename:@"Image.jpg"];
                }
                
                postRequest.account = sinaWeiboAccount;
                
                [postRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                    
                    if (error != nil) {
                        [self performSelectorOnMainThread:@selector(reportSuccessOrError:) withObject:[error localizedDescription] waitUntilDone:NO];
                    }
                    
                    if ([urlResponse statusCode] == 200) {
                        [self performSelectorOnMainThread:@selector(reportSuccessOrError:) withObject:@"Your message has been posted to SinaWeibo" waitUntilDone:NO];
                    }
                    
                }];
                
            }
        }else{
            NSLog(@"Access Denied");
        }
        
    }];
}

-(void)sinaWeiboTimeline
{
    ACAccountStore *accountStore = [[ACAccountStore alloc]init];
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierSinaWeibo];
    
    [accountStore requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error) {
        
        NSLog(@"timeline comming with:%@",[error localizedDescription]);
       
        if (error!=nil) {
            [self performSelectorOnMainThread:@selector(reportSuccessOrError:) withObject:[error localizedDescription] waitUntilDone:NO];
        }
        
        if (granted == YES) {
            NSArray *arrayOfAccounts = [accountStore accountsWithAccountType:accountType];
            
            if ([arrayOfAccounts count] > 0) {
                
                ACAccount *sinaWeiboAccount = [arrayOfAccounts lastObject];
                NSURL *requestURL = [NSURL URLWithString:@"https://api.weibo.com/2/statuses/home_timeline.json"];
                NSLog(@"%@",[sinaWeiboAccount description]);
                
                NSDictionary *options = @{@"count":@"20"};
                
                SLRequest *postRequest = [SLRequest requestForServiceType:SLServiceTypeSinaWeibo requestMethod:SLRequestMethodGET URL:requestURL parameters:options];
                
                postRequest.account = sinaWeiboAccount;
                
                [postRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                    
                    NSLog(@"SinaWeibo post statusCode: %u",(int)[urlResponse statusCode]);
                    
                    if ([urlResponse statusCode] == 200) {
                        NSLog(@"%@", [[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error] objectForKey:@"data"]);
                        
                        [self performSelectorOnMainThread:@selector(presentTimeline:) withObject:[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error] waitUntilDone:NO];
                        
                    }else if (error != nil) {
                        [self performSelectorOnMainThread:@selector(sinaWeiboError:) withObject:error waitUntilDone:NO];
                        
                    }
                    

                    
                }];
                
                
            }
        }
        
    }];
    
}

- (void)sinaWeiboError:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
    [alert show];
}


#pragma mark - Timeline segue
- (void)presentTimeline:(NSArray *)timelineArray
{
    
    NSLog(@"%@",NSStringFromSelector(_cmd));
    //programatic segue
    
    RESTimelineViewController *timelineVC = [[RESTimelineViewController alloc]initWithNibName:@"RESTimelineViewController" bundle:nil];
    [timelineVC setTimelineData:timelineArray];
    
    UINavigationController *navC = timelineVC.navigationController;

    //(modal) nav+vc
    [self presentViewController:navC animated:YES completion:nil];
    
}

#pragma mark - attachImage picker

- (IBAction)attachImageTouched:(id)sender
{
    attachmentImage = nil;
    pickerController = [[UIImagePickerController alloc]init];
    
    pickerController.delegate = self;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    }else{
        pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    //modal
    [self presentViewController:pickerController animated:YES completion:nil];
    
}



#pragma mark -
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    attachmentImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - TextView delegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSUInteger characterCount = [[textView text]length];
    characterCount -= range.length;
    characterCount += text.length;
    
    if (characterCount <= kInputCharacterLimit) {
        self.charCountLabel.text = [NSString stringWithFormat:@"%d Characters Remaining",(int)(kInputCharacterLimit-characterCount)];
        return YES;
    }
    
    return NO;
}



@end
