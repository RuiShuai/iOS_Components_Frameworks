//
//  RESInputColorTableCell.h
//  ImagePlayground
//
//  Created by taotao on 14/12/31.
//  Copyright (c) 2014年 RuiShuai Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RESInputInfoCell.h"

@interface RESInputColorTableCell : RESInputInfoCell
@property (strong, nonatomic) IBOutlet UILabel *inputColorLabel;
@property (strong, nonatomic) IBOutlet UISlider *inputRedSlider;
@property (strong, nonatomic) IBOutlet UISlider *inputGreenSlider;
@property (strong, nonatomic) IBOutlet UISlider *inputBlueSlider;
@property (strong, nonatomic) IBOutlet UISlider *inputAlphaSlider;
@property (strong, nonatomic) IBOutlet UIView *displayColorView;

- (IBAction)colorSliderChanged:(id)sender;

@end
