//
//  RESMovieEditViewController.h
//  MyMovies
//
//  Created by taotao on 14/12/25.
//  Copyright (c) 2014年 RuiShuai Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RESCoreDataManager.h"
#import "RESDateChooserViewController.h"
#import "RESYearChooserViewController.h"
#import "RESFriendChooserViewController.h"
#import "RESMovieManagedObject.h"
#import "RESFriendManagedObject.h"
//委托协议
@protocol RESMovieEditDelegate <NSObject>
-(void)movieChanged:(RESMovieManagedObject *)movieMO;
@end

//
@interface RESMovieEditViewController : UITableViewController<UITextFieldDelegate,UITextViewDelegate,RESDateChooserDelegate,RESYearChooserDelegate,RESFriendChooserDelegate>

@property (nonatomic,strong) NSManagedObjectID *editMovieID;
@property (nonatomic,weak) id<RESMovieEditDelegate> delegate;

@property (strong, nonatomic) IBOutlet UITextField *movieTitle;
@property (strong, nonatomic) IBOutlet UILabel *movieYearLabel;
@property (strong, nonatomic) IBOutlet UITextView *movieDescription;
@property (strong, nonatomic) IBOutlet UISwitch *sharedSwitch;
@property (strong, nonatomic) IBOutlet UILabel *sharedFriendLabel;
@property (strong, nonatomic) IBOutlet UILabel *sharedOnDateLabel;
@property (strong, nonatomic) IBOutlet UITableViewCell *sharedFriendCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *sharedDateCell;

- (IBAction)saveButtonTouched:(id)sender;
- (IBAction)cancelButtonTouched:(id)sender;
- (IBAction)sharedSwitchChanged:(id)sender;



@end
