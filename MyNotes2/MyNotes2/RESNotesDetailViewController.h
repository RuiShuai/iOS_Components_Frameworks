//
//  RESNotesDetailViewController.h
//  MyNotes2
//
//  Created by taotao on 15/1/9.
//  Copyright (c) 2015年 RuiShuai Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RESNotesDetailViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextView *myNoteTextView;

@property (strong, nonatomic) IBOutlet UIButton *conflictButton;

- (IBAction)resolveConflictTouched:(id)sender;

@end
