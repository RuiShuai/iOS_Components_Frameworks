//
//  RESInputTransfromTableCell.h
//  ImagePlayground
//
//  Created by taotao on 14/12/31.
//  Copyright (c) 2014年 RuiShuai Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RESInputInfoCell.h"

@interface RESInputTransfromTableCell : RESInputInfoCell<UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UILabel *inputTransformLabel;
@property (strong, nonatomic) IBOutlet UITextField *inputTXTextField;
@property (strong, nonatomic) IBOutlet UITextField *inputTYTextField;
@property (strong, nonatomic) IBOutlet UITextField *inputRotateTextField;
@property (strong, nonatomic) IBOutlet UITextField *inputSXTextField;
@property (strong, nonatomic) IBOutlet UITextField *inputSYTextField;


@end
