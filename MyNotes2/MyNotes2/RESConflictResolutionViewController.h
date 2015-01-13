//
//  RESConflictResolutionViewController.h
//  MyNotes2
//
//  Created by taotao on 15/1/9.
//  Copyright (c) 2015年 RuiShuai Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RESConflictVersionViewController.h"

@protocol RESMyNoteConflictDelegate;

@interface RESConflictResolutionViewController : UIViewController<UIPageViewControllerDataSource,UIPageViewControllerDelegate,RESConflictResolutionDelegate>

@property (nonatomic,strong) UIPageViewController *pageViewController;
@property (nonatomic,strong) NSArray *versionList;
@property (nonatomic,strong) NSFileVersion *currentVersion;
@property (nonatomic,strong) NSURL *conflictNoteURL;
@property (nonatomic,weak) id<RESMyNoteConflictDelegate> delegate;

- (RESConflictVersionViewController *)viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard;
- (NSUInteger) indexOfViewController:(RESConflictVersionViewController *)viewController;

@end


//ConflictResolution protocol
@protocol RESMyNoteConflictDelegate <NSObject>

- (void)noteConflictResolved:(NSFileVersion *)selectedVerssion forCurrentVersion:(BOOL)isCurrentVersion;

@end


