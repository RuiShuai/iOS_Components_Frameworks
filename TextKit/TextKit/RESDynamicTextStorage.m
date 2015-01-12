//
//  RESDynamicTextStorage.m
//  TextKit
//
//  Created by taotao on 15/1/12.
//  Copyright (c) 2015年 RuiShuai Co., Ltd. All rights reserved.
//

#import "RESDynamicTextStorage.h"

NSString *const defaultTokenName = @"defaultTokenName";

@implementation RESDynamicTextStorage

- (id)init
{
    self = [super init];
    if (self) {
        backingStore = [[NSMutableAttributedString alloc]init];
    }
    return self;
}

- (NSString *)string
{
    return [backingStore string];
}

- (NSDictionary *)attributesAtIndex:(NSUInteger)location effectiveRange:(NSRangePointer)range
{
    return [backingStore attributesAtIndex:location effectiveRange:range];
}

- (void)replaceCharactersInRange:(NSRange)range withString:(NSString *)str
{
    [self beginEditing];
    [backingStore replaceCharactersInRange:range withString:str];
    
    [self edited:NSTextStorageEditedCharacters|NSTextStorageEditedAttributes
           range:range
  changeInLength:str.length - range.length];
    
    textNeedsUpdate = YES;
    [self endEditing];
    
}

- (void)setAttributes:(NSDictionary *)attrs range:(NSRange)range
{
    [self beginEditing];
    
    [backingStore setAttributes:attrs range:range];
    [self edited:NSTextStorageEditedAttributes range:range changeInLength:0];
    
    [self endEditing];
}

- (void)processEditing
{
    if (textNeedsUpdate) {
        textNeedsUpdate = NO;
        //invoke
        [self performReplacementForCharacterChangeInRange:[self editedRange]];
    }
    [super processEditing];
}

//custom
- (void)performReplacementForCharacterChangeInRange:(NSRange)changedRange
{
    NSRange extendedRange = NSUnionRange(changedRange, [[self string] lineRangeForRange:NSMakeRange(changedRange.location, 0)]);
    extendedRange = NSUnionRange(changedRange, [[self string] lineRangeForRange:NSMakeRange(NSMaxRange(changedRange), 0)]);
    
    //invoke
    [self applyTokenAttributesToRange:extendedRange];
}

- (void)applyTokenAttributesToRange:(NSRange)searchRange
{
    NSDictionary *defaultAttributes = [self.tokens objectForKey:defaultTokenName];
    
    [[self string] enumerateSubstringsInRange:searchRange
                                      options:NSStringEnumerationByWords
                                   usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         NSDictionary *attributesForToken = [self.tokens objectForKey:substring];
         if (!attributesForToken) {
             attributesForToken = defaultAttributes;
         }
         [self addAttributes:attributesForToken range:substringRange];
    }];
    
}


@end
