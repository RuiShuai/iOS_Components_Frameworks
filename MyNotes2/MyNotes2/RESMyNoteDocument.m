//
//  RESMyNoteDocument.m
//  MyNotes2
//
//  Created by taotao on 15/1/9.
//  Copyright (c) 2015年 RuiShuai Co., Ltd. All rights reserved.
//

#import "RESMyNoteDocument.h"

@implementation RESMyNoteDocument

#pragma mark - Custom accessors
- (void)setMyNoteText:(NSString *)newNoteText
{
    NSString *oldNoteText = _myNoteText;
    _myNoteText = [newNoteText copy];
    
    //undoManager
    SEL setNoteText = @selector(setMyNoteText:);
    
    [self.undoManager setActionName:@"Text Change"];
    [self.undoManager registerUndoWithTarget:self selector:setNoteText object:oldNoteText];
    
}

#pragma mark - Custom UIDocument methods
- (id)contentsForType:(NSString *)typeName error:(NSError *__autoreleasing *)outError
{
    if (!self.myNoteText) {
        [self setMyNoteText:@""];
    }
    
    NSData *myNoteData = [self.myNoteText dataUsingEncoding:NSUTF8StringEncoding];
    return myNoteData;
}

- (BOOL)loadFromContents:(id)contents ofType:(NSString *)typeName error:(NSError *__autoreleasing *)outError
{
    if ([contents length]>0) {
        NSString *textFromData = [[NSString alloc]initWithData:contents encoding:NSUTF8StringEncoding];
        [self setMyNoteText:textFromData];
    }
    else{
        [self setMyNoteText:@""];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(documentContentsDidChange:)]) {
        [self.delegate documentContentsDidChange:self];
    }
    return YES;
}

@end
