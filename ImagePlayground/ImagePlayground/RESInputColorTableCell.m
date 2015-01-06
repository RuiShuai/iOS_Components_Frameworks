//
//  RESInputColorTableCell.m
//  ImagePlayground
//
//  Created by taotao on 14/12/31.
//  Copyright (c) 2014年 RuiShuai Co., Ltd. All rights reserved.
//

#import "RESInputColorTableCell.h"

@implementation RESInputColorTableCell

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
//父类方法,子类实现
-(void)configureForInfo:(NSDictionary *)attributeInfo andKey:(NSString *)attributeKey
{
    [super configureForInfo:attributeInfo andKey:attributeKey];
    [self.inputColorLabel setText:attributeKey];
    
    CIColor *color = [attributeInfo valueForKey:kCIAttributeDefault];
    [self.inputRedSlider setValue:[color red]];
    [self.inputGreenSlider setValue:[color green]];
    [self.inputBlueSlider setValue:[color blue]];
    [self.inputAlphaSlider setValue:[color alpha]];
    
    [self colorSliderChanged:nil];
    
}

-(id)getAttributeValue
{
    CGFloat redValue = [self.inputRedSlider value];
    CGFloat greenValue = [self.inputGreenSlider value];
    CGFloat blueValue = [self.inputBlueSlider value];
    CGFloat alphaValue = [self.inputAlphaSlider value];
    CIColor *color = [CIColor colorWithRed:redValue green:greenValue blue:blueValue alpha:alphaValue];
    
    return color;
}

#pragma mark - User action
- (IBAction)colorSliderChanged:(id)sender
{
    CGFloat redValue = [self.inputRedSlider value];
    CGFloat greenValue = [self.inputGreenSlider value];
    CGFloat blueValue = [self.inputBlueSlider value];
    CGFloat alphaValue = [self.inputAlphaSlider value];
    UIColor *newColor = [UIColor colorWithRed:redValue green:greenValue blue:blueValue alpha:alphaValue];
    [self.displayColorView setBackgroundColor:newColor];
}


@end
