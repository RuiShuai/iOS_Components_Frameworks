//
//  ViewController.m
//  KeychainPlayground
//
//  Created by taotao on 15/1/9.
//  Copyright (c) 2015年 RuiShuai Co., Ltd. All rights reserved.
//

#import "RESKeychainViewController.h"

#define kEnterExistingPinAlert 1
#define kEnterNewPinAlert 2


@interface RESKeychainViewController ()

@end

@implementation RESKeychainViewController


#pragma mark - view life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //init pinWrapper
    pinWrapper = [[KeychainItemWrapper alloc]initWithIdentifier:@"com.ruishuai.KeychainPlayground.pin" accessGroup:nil];
    [pinWrapper setObject:(__bridge id)(kSecAttrAccessibleWhenUnlocked) forKey:(__bridge id)(kSecAttrAccessible)];
    [pinWrapper setObject:@"pinIdentifier" forKey:(__bridge id)kSecAttrAccount];
    
    //no pin set
    if ([[pinWrapper objectForKey:(__bridge id)kSecValueData] length]==0)
    {
        //弹出框
        UIAlertView *dialog = [[UIAlertView alloc]init];//WithFrame:CGRectMake(20, 200, 300, 100)
        dialog.tag = kEnterNewPinAlert;
        [dialog setDelegate:self];
        [dialog setTitle:@"Enter New Pin"];
        [dialog setMessage:@"\n\n\n"];
        [dialog addButtonWithTitle:@"OK,no pin set"];
        dialog.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;

        //pin输入框
        
        pinField = (UITextField *)[dialog textFieldAtIndex:0];
        [pinField setPlaceholder:@"Enter PIN"];
        [pinField setKeyboardType:UIKeyboardTypeNumberPad];
        
        pinFieldRepeat = (UITextField *)[dialog textFieldAtIndex:1];
        [pinFieldRepeat setPlaceholder:@"Repeat PIN"];
        [pinFieldRepeat setKeyboardType:UIKeyboardTypeNumberPad];

        [dialog show];
        
        //焦点至pinField
        [pinField becomeFirstResponder];

    //pin already set
    }else{
        
        UIAlertView *dialog = [[UIAlertView alloc]init];
        dialog.tag = kEnterExistingPinAlert;
        [dialog setDelegate:self];
        [dialog setTitle:@"Enter PIN"];
        [dialog setMessage:@" "];
        [dialog addButtonWithTitle:@"OK,pin already set"];
        dialog.alertViewStyle = UIAlertViewStyleSecureTextInput;

        pinField = [dialog textFieldAtIndex:0];
        [pinField setPlaceholder:@"Enter PIN"];
        [pinField setKeyboardType:UIKeyboardTypeNumberPad];
       
        [dialog show];

        [pinField becomeFirstResponder];
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}




#pragma mark - AlertView delegate
-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"%@",NSStringFromSelector(_cmd));
    NSLog(@"tag:%d,EnterExisting:%d",alertView.tag,kEnterExistingPinAlert);
    
    //kEnterExistingPinAlert
    if (alertView.tag == kEnterExistingPinAlert) {
        
        //pin number entered was correct
        if ([pinField.text isEqualToString:[pinWrapper objectForKey:(__bridge id)kSecValueData]])
        {
            KeychainItemWrapper *secureDataKeychain = [[KeychainItemWrapper alloc] initWithIdentifier:@"com.ruishuai.KeychainPlayground.securedData" accessGroup:nil];
            NSString *secureDataString = [secureDataKeychain objectForKey:(__bridge id)kSecValueData];
            
            //we have stored data for this keychain
            if ([secureDataString length] != 0) {
                NSData *data = [secureDataString dataUsingEncoding:NSUTF8StringEncoding];
                NSError *error = nil;
                NSDictionary *secureDataDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
                if (error != nil) {
                    NSLog(@"An error occurred: %@",[error localizedDescription]);
                }
                numberTextField.text = [secureDataDict objectForKey:@"numberTextField"];
                expDateTextField.text = [secureDataDict objectForKey:@"expDateTextField"];
                CV2CodeTextField.text = [secureDataDict objectForKey:@"CV2CodeTextField"];
                nameTextField.text = [secureDataDict objectForKey:@"nameTextField"];
            } else {
                NSLog(@"No keychain data stored yet");
            }
        }
        
        //pin number entered was incorrect
        else{
            UIAlertView *dialog = [[UIAlertView alloc]init];
            dialog.tag = kEnterExistingPinAlert;
            [dialog setDelegate:self];
            [dialog setTitle:@"Incorrect PIN!"];
            [dialog setMessage:@" "];
            [dialog addButtonWithTitle:@"OK"];
            dialog.alertViewStyle = UIAlertViewStyleSecureTextInput;
            
            pinField = [dialog textFieldAtIndex:0];
            [pinField setPlaceholder:@"Enter PIN"];
            [pinField setKeyboardType:UIKeyboardTypeNumberPad];
            
            [dialog show];
            
            [pinField becomeFirstResponder];
            
        }
        
    //kEnterNewPin
    }else{
        //两次PIN一致
        if ([pinField.text isEqualToString:pinFieldRepeat.text]) {
            [pinWrapper setObject:[pinField text] forKey:(__bridge id)kSecValueData];
        }else{
            UIAlertView *dialog = [[UIAlertView alloc]init];
            dialog.tag = kEnterNewPinAlert;
            [dialog setDelegate:self];
            [dialog setTitle:@"PINs Did not match!"];
            [dialog setMessage:@"\n\n\n"];
            [dialog addButtonWithTitle:@"OK"];
            dialog.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
            
            pinField = [dialog textFieldAtIndex:0];
            [pinField setPlaceholder:@"Enter PIN"];
            [pinField setKeyboardType:UIKeyboardTypeNumberPad];
            
            pinFieldRepeat = [dialog textFieldAtIndex:1];
            [pinFieldRepeat setPlaceholder:@"Repeat PIN"];
            [pinFieldRepeat setKeyboardType:UIKeyboardTypeNumberPad];
            
            [dialog show];
            //获得焦点
            [pinField becomeFirstResponder];
            
            
        }

    }
}


#pragma mark - user action
- (IBAction)saveButtonTouched:(id)sender
{
    NSLog(@"%@",NSStringFromSelector(_cmd));
    NSMutableDictionary *secureDataDict = [[NSMutableDictionary alloc]init];
    NSError *error = nil;
    
    if (numberTextField.text) {
        [secureDataDict setObject:numberTextField.text forKey:@"numberTextField"];
    }
    
    if (expDateTextField.text) {
        [secureDataDict setObject:expDateTextField.text forKey:@"expDateTextField"];
    }
    
    if (CV2CodeTextField.text) {
        [secureDataDict setObject:CV2CodeTextField.text forKey:@"CV2CodeTextField"];
    }
    
    if (nameTextField.text) {
        [secureDataDict setObject:nameTextField.text forKey:@"nameTextField"];
    }
    
    NSData *rawData = [NSJSONSerialization dataWithJSONObject:secureDataDict options:0 error:&error];
    
    if (error != nil) {
        NSLog(@"An error occured: %@",[error localizedDescription]);
    }
    
    NSString *dataString = [[NSString alloc]initWithData:rawData encoding:NSUTF8StringEncoding];
    KeychainItemWrapper *secureDataKeychain = [[KeychainItemWrapper alloc]initWithIdentifier:@"com.ruishuai.KeychainPlayground.securedData" accessGroup:nil];
    [secureDataKeychain setObject:@"secureDataIdentifier" forKey:(__bridge id)kSecAttrAccount];
    [secureDataKeychain setObject:(__bridge id)kSecAttrAccessibleWhenUnlocked forKey:(__bridge id)kSecAttrAccessible];
    
    [secureDataKeychain setObject:dataString forKey:(__bridge id)kSecValueData];
    
}

@end
