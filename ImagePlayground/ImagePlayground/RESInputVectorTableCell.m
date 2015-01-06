//
//  RESInputVectorTableCell.m
//  ImagePlayground
//
//  Created by taotao on 14/12/31.
//  Copyright (c) 2014年 RuiShuai Co., Ltd. All rights reserved.
//

#import "RESInputVectorTableCell.h"

@implementation RESInputVectorTableCell

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
    [self.inputVectorLabel setText:attributeKey];
    
    CIVector *inputDefault = [attributeInfo valueForKey:kCIAttributeDefault];
    
    NSString *inputXDefault = [NSString stringWithFormat:@"%f",[inputDefault X]];
    [self.inputXTextField setText:inputXDefault];
    
    NSString *inputYDefault = [NSString stringWithFormat:@"%f",[inputDefault Y]];
    [self.inputYTextField setText:inputYDefault];
    
    NSString *inputZDefault = [NSString stringWithFormat:@"%f",[inputDefault Z]];
    [self.inputZTextField setText:inputZDefault];
    
    NSString *inputWDefault = [NSString stringWithFormat:@"%f",[inputDefault W]];
    [self.inputWTextField setText:inputWDefault];
}

-(id)getAttributeValue
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    
    NSString *inputXString = [self.inputXTextField text];
    NSNumber *inputX = [numberFormatter numberFromString:inputXString];
    
    NSString *inputYString = [self.inputYTextField text];
    NSNumber *inputY = [numberFormatter numberFromString:inputYString];
    
    NSString *inputZString = [self.inputZTextField text];
    NSNumber *inputZ = [numberFormatter numberFromString:inputZString];
    
    NSString *inputWString = [self.inputWTextField text];
    NSNumber *inputW = [numberFormatter numberFromString:inputWString];
    
    CIVector *vector = [CIVector vectorWithX:[inputX floatValue] Y:[inputY floatValue] Z:[inputZ floatValue] W:[inputW floatValue]];
    
    return vector;
}

#pragma mark - UITextFieldDelegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    [super valueChanged:nil];
    return YES;
}

@end
