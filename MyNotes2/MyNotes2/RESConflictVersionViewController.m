//
//  RESConflictVersionViewController.m
//  MyNotes2
//
//  Created by taotao on 15/1/9.
//  Copyright (c) 2015年 RuiShuai Co., Ltd. All rights reserved.
//

#import "RESConflictVersionViewController.h"

@interface RESConflictVersionViewController ()

@end

@implementation RESConflictVersionViewController

#pragma mark - view life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    
    NSString *dateString = [dateFormatter stringFromDate:[self.fileVersion modificationDate]];
    
    [self.versionLabel setText:[self.fileVersion localizedName]];
    [self.versionDate setText:dateString];
    
    [self.versionComputer setText:[self.fileVersion localizedNameOfSavingComputer]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


#pragma mark -
- (IBAction)selectVersionTouched:(id)sender
{
    [self.delegate conflictVersionSelected:self.fileVersion];
}


@end
