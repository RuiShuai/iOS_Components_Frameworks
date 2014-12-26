//
//  RESDateChooserViewController.h
//  MyMovies
//
//  Created by taotao on 14/12/25.
//  Copyright (c) 2014年 RuiShuai Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RESDateChooserDelegate <NSObject>
- (void)chooserSelectedDate:(NSDate *)date;
@end

@interface RESDateChooserViewController : UITableViewController

@property (strong,nonatomic) NSDate *selectedDate;
@property (weak,nonatomic) id<RESDateChooserDelegate> delegate;

@end
