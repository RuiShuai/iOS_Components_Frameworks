//
//  RESInputNumberTableCell.m
//  ImagePlayground
//
//  Created by taotao on 14/12/31.
//  Copyright (c) 2014年 RuiShuai Co., Ltd. All rights reserved.
//

#import "RESInputNumberTableCell.h"

@implementation RESInputNumberTableCell

- (void)awakeFromNib {
    // Initialization code
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Base methods
-(void)configureForInfo:(NSDictionary *)attributeInfo andKey:(NSString *)attributeKey
{
    [super configureForInfo:attributeInfo andKey:attributeKey];
    [self.inputNumberLabel setText:attributeKey];
    
    CGFloat maxValue = [[attributeInfo valueForKey:kCIAttributeSliderMax] floatValue];
    [self.inputNumberSlider setMaximumValue:maxValue];
    
    CGFloat minValue = [[attributeInfo valueForKey:kCIAttributeSliderMin] floatValue];
    [self.inputNumberSlider setMinimumValue:minValue];
    
    CGFloat defaultValue = [[attributeInfo valueForKey:kCIAttributeDefault] floatValue];
    [self.inputNumberSlider setValue:defaultValue];
    
}

-(id)getAttributeValue
{
    CGFloat value = [self.inputNumberSlider value];
    return [NSNumber numberWithFloat:value];
}

@end
