//
//  RESMyNoteDocument.h
//  MyNotes2
//
//  Created by taotao on 15/1/9.
//  Copyright (c) 2015年 RuiShuai Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol RESMyNoteDocumentDelegate;

//MyNoteDocument
@interface RESMyNoteDocument : UIDocument
@property (nonatomic,copy) NSString *myNoteText;
@property (nonatomic,weak) id<RESMyNoteDocumentDelegate> delegate;
@end

//MyNoteDocument Delegate protocol
@protocol RESMyNoteDocumentDelegate <NSObject>
@optional
- (void)documentContentsDidChange:(RESMyNoteDocument *)document;
@end


