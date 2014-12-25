//
//  MasterViewController.h
//  MyMovies
//
//  Created by taotao on 14/12/25.
//  Copyright (c) 2014年 RuiShuai Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface RESMovieListViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;


@end

