//
//  RESMovieEditViewController.m
//  MyMovies
//
//  Created by taotao on 14/12/25.
//  Copyright (c) 2014年 RuiShuai Co., Ltd. All rights reserved.
//

#import "RESMovieEditViewController.h"

@interface RESMovieEditViewController ()
@property (nonatomic,strong) RESMovieManagedObject *editMovie;
@end

@implementation RESMovieEditViewController

#pragma mark - View Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureView];
}

- (void)configureView
{
    if (self.editMovieID) {
        
        NSManagedObjectContext *moc = [[RESCoreDataManager sharedManager] managedObjectContext];
        RESMovieManagedObject *movieMO = (RESMovieManagedObject *)[moc objectWithID:self.editMovieID];
        [self setEditMovie:movieMO];
        
        //设置UI
        [self.movieTitle setText:[movieMO title]];
        [self.movieYearLabel setText:[movieMO year]];
        [self.movieDescription setText:[movieMO movieDescription]];
        BOOL movieLent = [[movieMO lent] boolValue];
        [self.sharedSwitch setOn:movieLent];
        
        if (movieLent) {
            RESFriendManagedObject *friendMO = [movieMO lentToFriend];
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
            NSString *sharedDateText = [dateFormatter stringFromDate:[movieMO lentOn]];
            
            [self.sharedFriendLabel setText:[friendMO valueForKey:@"friendName"]];
            [self.sharedOnDateLabel setText:sharedDateText];
            [self.sharedFriendCell setHidden:NO];
            [self.sharedDateCell setHidden:NO];
            
        } else
        {
            [self.sharedFriendCell setHidden:YES];
            [self.sharedDateCell setHidden:YES];
        }
        
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


#pragma mark - IBActions

- (IBAction)saveButtonTouched:(id)sender
{
    //处理lentToFriend为空的情况
    if ([self.sharedSwitch isOn] && !self.editMovie.lentToFriend) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Select Friend" message:@"Please select friend you have shared movie with " delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    //设置movie新属性
    NSString *movieTitle = [self.movieTitle text];
    [self.editMovie setTitle:movieTitle];
    
    NSString *movieDesc = [self.movieDescription text];
    [self.editMovie setMovieDescription:movieDesc];
    
    BOOL sharedBool = [self.sharedSwitch isOn];
    NSNumber *shared = [NSNumber numberWithBool:sharedBool];
    [self.editMovie setLent:shared];
    
    //同步更新CoreData
    NSManagedObjectContext *moc = [[RESCoreDataManager sharedManager] managedObjectContext];
    NSError *saveError = nil;
    [moc save:&saveError];
    if (saveError) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error saving movie" message:[saveError localizedDescription] delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        NSLog(@"Changes to movie saved.");
    }
    
    //传递editMovie至delegate
    [self.delegate movieChanged:self.editMovie];
    
    //关闭当前视图
    [self.navigationController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)cancelButtonTouched:(id)sender
{
    //回滚coredata
    if ([[[RESCoreDataManager sharedManager] managedObjectContext] hasChanges]) {
        [[[RESCoreDataManager sharedManager] managedObjectContext] rollback];
        NSLog(@"Rolled back changes");
    }
    //关闭当前视图
    [self.navigationController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)sharedSwitchChanged:(id)sender
{
    if ([self.sharedSwitch isOn]) {
        [self.sharedFriendLabel setText:@"Please Select"];
        
        //设置当前时间
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        NSString *sharedDateText = [dateFormatter stringFromDate:[NSDate date]];
        [self.sharedOnDateLabel setText:sharedDateText];
        [self.editMovie setLentOn:[NSDate date]];
        //打开日期,朋友单元格
        [self.sharedFriendCell setHidden:NO];
        [self.sharedDateCell setHidden:NO];
        
    } else
    {
        [self.sharedFriendCell setHidden:YES];
        [self.editMovie setLentToFriend:nil];
        
        [self.sharedDateCell setHidden:YES];
        [self.editMovie setLentOn:nil];
    }
    
    [self.tableView reloadData];
}


#pragma mark - Table view data source
/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {


    return 0;
}
*/




#pragma mark - tableViewCell segue Navigation


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    //yearSelected
    if ([[segue identifier] isEqualToString:@"yearSelected"]) {
        RESYearChooserViewController *mYVC = (RESYearChooserViewController *)[segue destinationViewController];
        [mYVC setSelectedYear:[self.editMovie year]];
        [mYVC setDelegate:self];
    }
    
    //dateSelected
    if ([[segue identifier] isEqualToString:@"dateSelected"]) {
        RESDateChooserViewController *mDVC = (RESDateChooserViewController *)[segue destinationViewController];
        
        NSDate *selDate = [self.editMovie lentOn];
        if (!selDate) {
            selDate = [NSDate date];
        }
        [mDVC setSelectedDate:selDate];
        
        [mDVC setDelegate:self];
    }
    
    
    //friendSelected
    if ([[segue identifier] isEqualToString:@"friendSelected"]) {
        RESFriendChooserViewController *mFVC = (RESFriendChooserViewController *)[segue destinationViewController];
        
        [mFVC setTitle:@"Choose Friend"];
        [mFVC setSelectedFriend:[self.editMovie lentToFriend]];
        [mFVC setDelegate:self];
    }
    
}


#pragma mark - Year,Date,Friend,textField,textView chooser delegate
- (void)chooserSelectedYear:(NSString *)year
{
    [self.editMovie setYear:year];
    [self.movieYearLabel setText:year];
}

- (void)chooserSelectedDate:(NSDate *)date
{
    [self.editMovie setLentOn:date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    
    NSString *sharedDateText = [dateFormatter stringFromDate:[self.editMovie lentOn]];
    [self.sharedOnDateLabel setText:sharedDateText];
}

- (void)chooserSelectedFriend:(RESFriendManagedObject *)friendMO
{
    [self.editMovie setLentToFriend:friendMO];
    [self.sharedFriendLabel setText:[friendMO valueForKey:@"friendName"]];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

@end
