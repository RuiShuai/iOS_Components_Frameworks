//
//  DetailViewController.m
//  MyMovies
//
//  Created by taotao on 14/12/25.
//  Copyright (c) 2014年 RuiShuai Co., Ltd. All rights reserved.
//

#import "RESMovieDisplayViewController.h"

@interface RESMovieDisplayViewController ()
- (void)configureView;
- (void)configureViewForMovie:(RESMovieManagedObject *)movieMO;
@end

@implementation RESMovieDisplayViewController

#pragma mark - View Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureView];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    [self setMovieTitleAndYearLabel:nil];
    [self setMovieDescription:nil];
    [self setMovieSharedInfoLabel:nil];
}

- (void)configureView {
    //Update the user interface for the detail item;
    if (self.movieDetailID) {
        NSManagedObjectContext *moc = [[RESCoreDataManager sharedManager] managedObjectContext];
        RESMovieManagedObject *movieMO = (RESMovieManagedObject *)[moc objectWithID:self.movieDetailID];
        
        [self configureViewForMovie:movieMO];
    }
}

- (void)configureViewForMovie:(RESMovieManagedObject *)movieMO
{
    NSString *movieTitleYear = [movieMO yearAndTitle];
    [self.movieTitleAndYearLabel setText:movieTitleYear];
    
    [self.movieDescription setText:[movieMO movieDescription]];
    
    BOOL movieLent = [[movieMO lent] boolValue];
    
    NSString *movieShared = @"Not Shared";
    if (movieLent) {
        RESFriendManagedObject *friendMO = [movieMO valueForKey:@"lentToFriend"];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        NSString *sharedDateTxt = [dateFormatter stringFromDate:[movieMO lentOn]];
        
        movieShared = [NSString stringWithFormat:@"Shared with %@ on %@",[friendMO valueForKey:@"friendName"],sharedDateTxt];
        
    }
    
    [self.movieSharedInfoLabel setText:movieShared];
    
}

#pragma mark - segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //editMovie
    if ([[segue identifier] isEqualToString:@"editMovie"]) {
        UINavigationController *nc = (UINavigationController *)[segue destinationViewController];
        RESMovieEditViewController *mEVC = (RESMovieEditViewController *)[nc visibleViewController];
        [mEVC setEditMovieID:self.movieDetailID];
        //明确委托关系
        [mEVC setDelegate:self];
    }
}

#pragma mark - RESMovieEditDelegate
- (void)movieChanged:(RESMovieManagedObject *)movieMO
{
    [self setMovieDetailID:[movieMO objectID]];
    [self configureViewForMovie:movieMO];
}


@end
