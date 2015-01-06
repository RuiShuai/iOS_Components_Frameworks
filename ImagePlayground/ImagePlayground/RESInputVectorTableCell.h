//
//  RESInputVectorTableCell.h
//  ImagePlayground
//
//  Created by taotao on 14/12/31.
//  Copyright (c) 2014年 RuiShuai Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RESInputInfoCell.h"

@interface RESInputVectorTableCell : RESInputInfoCell<UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UILabel *inputVectorLabel;

@property (strong, nonatomic) IBOutlet UITextField *inputXTextField;
@property (strong, nonatomic) IBOutlet UITextField *inputYTextField;
@property (strong, nonatomic) IBOutlet UITextField *inputZTextField;
@property (strong, nonatomic) IBOutlet UITextField *inputWTextField;



@end
