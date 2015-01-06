//
//  RESInputNumberTableCell.h
//  ImagePlayground
//
//  Created by taotao on 14/12/31.
//  Copyright (c) 2014年 RuiShuai Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RESInputInfoCell.h"

@interface RESInputNumberTableCell : RESInputInfoCell

@property (strong, nonatomic) IBOutlet UILabel *inputNumberLabel;
@property (strong, nonatomic) IBOutlet UISlider *inputNumberSlider;


@end
