//
//  ViewController.h
//  KeychainPlayground
////https://developer.apple.com/library/ios/samplecode/GenericKeychain/Listings/Classes_KeychainItemWrapper_m.html
//  Created by taotao on 15/1/9.
//  Copyright (c) 2015年 RuiShuai Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KeychainItemWrapper.h"

@interface RESKeychainViewController : UIViewController<UIAlertViewDelegate>
{
    UITextField *pinField;
    UITextField *pinFieldRepeat;
    KeychainItemWrapper *pinWrapper;
    IBOutlet UITextField *nameTextField;
    IBOutlet UITextField *numberTextField;
    IBOutlet UITextField *expDateTextField;
    IBOutlet UITextField *CV2CodeTextField;
}

- (IBAction)saveButtonTouched:(id)sender;



@end

