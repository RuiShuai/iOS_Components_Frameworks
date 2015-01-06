//
//  RESInputInfoTableCell.m
//  ImagePlayground
//
//  Created by taotao on 14/12/31.
//  Copyright (c) 2014年 RuiShuai Co., Ltd. All rights reserved.
//

#import "RESInputInfoCell.h"

@implementation RESInputInfoCell

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


-(void)configureForInfo:(NSDictionary *)attributeInfo andKey:(NSString *)attributeKey
{
    [self setAttributeKey:attributeKey];
}

-(id)getAttributeValue
{
    return nil;
}

-(IBAction)valueChanged:(id)sender
{
    [self.editDelegate updateFilterAttribute:self.attributeKey withValue:[self getAttributeValue]];
}

@end
