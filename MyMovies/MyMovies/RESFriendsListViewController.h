//
//  RESFriendsListViewController.h
//  MyMovies
//
//  Created by taotao on 14/12/25.
//  Copyright (c) 2014年 RuiShuai Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "RESFriendManagedObject.h"
#import "RESCoreDataManager.h"
#import "RESFriendsEditViewController.h"

@interface RESFriendsListViewController : UITableViewController<NSFetchedResultsControllerDelegate>

@property (strong,nonatomic) NSFetchedResultsController *fetchedResultsController;

@end
