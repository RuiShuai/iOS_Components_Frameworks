//
//  RESNotesDetailViewController.h
//  MyNotes2
//
//  Created by taotao on 15/1/9.
//  Copyright (c) 2015年 RuiShuai Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RESMyNoteDocument.h"
#import "RESConflictResolutionViewController.h"

#define kRESLastUpdatedNoteKey @"lastUpdatedNote"

@interface RESNotesDetailViewController : UIViewController<RESMyNoteDocumentDelegate,RESMyNoteConflictDelegate>

@property (strong,nonatomic) NSURL *myNoteURL;
@property (strong, nonatomic) IBOutlet UITextView *myNoteTextView;
@property (strong, nonatomic) IBOutlet UIButton *conflictButton;
@property (strong,nonatomic) RESMyNoteDocument *myNoteDocument;

- (IBAction)resolveConflictTouched:(id)sender;

@end
