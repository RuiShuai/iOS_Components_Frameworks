//
//  RESYearChooserViewController.h
//  MyMovies
//
//  Created by taotao on 14/12/25.
//  Copyright (c) 2014年 RuiShuai Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RESYearChooserDelegate <NSObject>
- (void)chooserSelectedYear:(NSString *)year;
@end


@interface RESYearChooserViewController : UITableViewController

@property (strong,nonatomic) NSString *selectedYear;
@property (weak,nonatomic) id<RESYearChooserDelegate> delegate;

@end
