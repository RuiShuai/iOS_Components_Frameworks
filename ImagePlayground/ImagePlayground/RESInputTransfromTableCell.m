//
//  RESInputTransfromTableCell.m
//  ImagePlayground
//
//  Created by taotao on 14/12/31.
//  Copyright (c) 2014年 RuiShuai Co., Ltd. All rights reserved.
//

#import "RESInputTransfromTableCell.h"

@implementation RESInputTransfromTableCell

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
    [self.inputTransformLabel setText:attributeKey];
}

-(id)getAttributeValue
{
    CGFloat tx = [[self.inputTXTextField text] floatValue];
    CGFloat ty = [[self.inputTYTextField text] floatValue];
    CGFloat sx = [[self.inputSXTextField text] floatValue];
    CGFloat sy = [[self.inputSYTextField text] floatValue];
    CGFloat r = [[self.inputRotateTextField text] floatValue];
    
    CGAffineTransform translate = CGAffineTransformMakeTranslation(tx, ty);
    CGAffineTransform scale = CGAffineTransformMakeScale(sx, sy);
    CGAffineTransform rotate = CGAffineTransformMakeRotation(r);
    
    CGAffineTransform translateAndScale = CGAffineTransformConcat(translate, scale);
    
    CGAffineTransform transform = CGAffineTransformConcat(translateAndScale, rotate);
    
    //make updates...
    
    NSValue *attrValue = [NSValue valueWithCGAffineTransform:transform];
    return attrValue;
    
}

#pragma mark - UITextFieldDelegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    [super valueChanged:nil];
    return YES;
}

@end
