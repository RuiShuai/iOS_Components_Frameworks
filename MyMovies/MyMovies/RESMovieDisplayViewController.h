//
//  DetailViewController.h
//  MyMovies
//
//  Created by taotao on 14/12/25.
//  Copyright (c) 2014年 RuiShuai Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RESMovieEditViewController.h"
#import "RESCoreDataManager.h"
#import "RESMovieManagedObject.h"
#import "RESFriendManagedObject.h"

@interface RESMovieDisplayViewController : UITableViewController<RESMovieEditDelegate>

@property (strong,nonatomic) NSManagedObjectID *movieDetailID;
@property (strong, nonatomic) IBOutlet UILabel *movieTitleAndYearLabel;
@property (strong, nonatomic) IBOutlet UITextView *movieDescription;
@property (strong, nonatomic) IBOutlet UILabel *movieSharedInfoLabel;

@end

