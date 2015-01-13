//
//  RESConflictVersionViewController.h
//  MyNotes2
//
//  Created by taotao on 15/1/9.
//  Copyright (c) 2015年 RuiShuai Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RESConflictResolutionDelegate;


@interface RESConflictVersionViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *versionLabel;
@property (strong, nonatomic) IBOutlet UILabel *versionDate;
@property (strong, nonatomic) IBOutlet UILabel *versionComputer;
@property (nonatomic, strong) NSFileVersion *fileVersion;
@property (nonatomic, weak) id<RESConflictResolutionDelegate> delegate;

- (IBAction)selectVersionTouched:(id)sender;

@end

//Protocol
@protocol RESConflictResolutionDelegate <NSObject>

-(void)conflictVersionSelected:(NSFileVersion *)selectedVersion;

@end