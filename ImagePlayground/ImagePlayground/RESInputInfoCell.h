//
//  RESInputInfoTableCell.h
//  ImagePlayground
//
//  Created by taotao on 14/12/31.
//  Copyright (c) 2014年 RuiShuai Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RESFilterDetailViewController.h"
@interface RESInputInfoCell : UITableViewCell

@property (nonatomic,strong) NSString *attributeKey;
@property (nonatomic,weak) id<RESFilterEditingDelegate> editDelegate;

-(void)configureForInfo:(NSDictionary *)attributeInfo andKey:(NSString *)attributeKey;
-(id)getAttributeValue;
-(IBAction)valueChanged:(id)sender;

@end
