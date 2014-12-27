//
//  RESFriendsEditViewController.h
//  MyMovies
//
//  Created by taotao on 14/12/25.
//  Copyright (c) 2014年 RuiShuai Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "RESFriendManagedObject.h"
#import "RESCoreDataManager.h"

@interface RESFriendsEditViewController : UITableViewController

@property (strong,nonatomic) NSManagedObjectID *editFriendID;
@property (strong, nonatomic) IBOutlet UITextField *friendName;
- (IBAction)saveButtonTouched:(id)sender;
- (IBAction)cancelButtonTouched:(id)sender;

@end
