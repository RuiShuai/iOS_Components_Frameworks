//
//  MasterViewController.h
//  MyMovies
//
//  Created by taotao on 14/12/25.
//  Copyright (c) 2014年 RuiShuai Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "RESCoreDataManager.h"
#import "RESMovieEditViewController.h"

@interface RESMovieListViewController : UITableViewController <NSFetchedResultsControllerDelegate>

//liaision联络者 between tableview and coredata
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;


@end

