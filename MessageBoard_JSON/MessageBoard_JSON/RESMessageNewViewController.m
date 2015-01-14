//
//  RESMessageNewViewController.m
//  MessageBoard_JSON
//
//  Created by taotao on 15/1/13.
//  Copyright (c) 2015年 RuiShuai Co., Ltd. All rights reserved.
//

#import "RESMessageNewViewController.h"

@interface RESMessageNewViewController ()
@property (nonatomic,strong) NSMutableData *connectionData;
@end

@implementation RESMessageNewViewController

#pragma mark - view life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //update UI with new message template
    if (self.messageDict) {
        [self.nameTextField setText:[self.messageDict objectForKey:@"name"]];
        [self.messageTextView setText:[self.messageDict objectForKey:@"message"]];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


- (void)showActivityIndicatorViewInNavigationItem
{
    UIActivityIndicatorView *actView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.navigationItem.titleView = actView;
    [actView startAnimating];
    self.navigationItem.prompt = @"消息提交中...";
}

#pragma mark - user action

- (IBAction)cancelButtonTouched:(id)sender
{
    //[self.navigationController popViewControllerAnimated:YES];
    
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)saveButtonTouched:(id)sender
{
    // show indicator
    [self showActivityIndicatorViewInNavigationItem];
    
    //dismiss keyboard
    
    [self.nameTextField resignFirstResponder];
    [self.messageTextView resignFirstResponder];
    
    //messageFromUI
    NSMutableDictionary *messageUI = [NSMutableDictionary dictionaryWithCapacity:1];
    [messageUI setObject:[self.nameTextField text] forKey:@"name"];
    [messageUI setObject:[self.messageTextView text] forKey:@"message"];
    
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    NSString *dateFmt = @"yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'";
    [dateFormatter setDateFormat:dateFmt];
    [messageUI setObject:[dateFormatter stringFromDate:today] forKey:@"message_date"];
    
    NSDictionary *postDict = [NSDictionary dictionaryWithObject:messageUI forKey:@"message"];
    
    //post json
    NSError *jsonSerializationError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:postDict options:NSJSONWritingPrettyPrinted error:&jsonSerializationError];
    
    if (!jsonSerializationError) {
        NSString *serialJSON = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"serialized json: %@",serialJSON);
        
        //send post request
        NSURL *messageBoardURL = [NSURL URLWithString:kMessageBoardURLString];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:messageBoardURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
        
        [request setHTTPMethod:@"POST"];//1
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];//2
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];//2
        [request setValue:[NSString stringWithFormat:@"%d",[jsonData length]] forHTTPHeaderField:@"Content-Length"];//3
        [request setHTTPBody:jsonData];//4
        
        NSURLConnection *jsonConn = [[NSURLConnection alloc]initWithRequest:request delegate:self];
        
        if (jsonConn) {
            NSMutableData *connData = [[NSMutableData alloc]init];
            [self setConnectionData:connData];
        }else{
            NSLog(@"Connection failed...");
        }
        
    }else{
        NSLog(@"JSON Encoding failed:%@",[jsonSerializationError localizedDescription]);
    }
    
    
    [self.delegate createNewMessage:postDict withPostError:jsonSerializationError];
    
}

#pragma mark - TextField delegate methods
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    //move to the message field
    [self.messageTextView becomeFirstResponder];
    return YES;
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    [textView resignFirstResponder];
    [self.navigationItem.rightBarButtonItem setTag:1];
    
}

#pragma mark - NSURLConnection delegate

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    connection = nil;
    self.connectionData = nil;
    NSLog(@"Connection failed. Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
}


#pragma mark - NSURLConnectionData delegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [self.connectionData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.connectionData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"Connection completed successfully.");
    connection = nil;
    self.connectionData = nil;
    
    //dismiss indicator
    self.navigationItem.titleView = nil;
    self.navigationItem.prompt = nil;
    
    //Now that connection is complete, OK to return to main view and reload
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}


@end
