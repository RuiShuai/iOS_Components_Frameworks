//
//  RESDynamicTextStorage.h
//  TextKit
//
//  Created by taotao on 15/1/12.
//  Copyright (c) 2015年 RuiShuai Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NSString *const defaultTokenName;

@interface RESDynamicTextStorage : NSTextStorage
{
    NSMutableAttributedString *backingStore;
    BOOL textNeedsUpdate;
}

@property (nonatomic,copy) NSDictionary *tokens;

@end
