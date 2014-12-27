//
//  RESFriendsEditViewController.m
//  MyMovies
//
//  Created by taotao on 14/12/25.
//  Copyright (c) 2014年 RuiShuai Co., Ltd. All rights reserved.
//

#import "RESFriendsEditViewController.h"

@interface RESFriendsEditViewController ()
@property (nonatomic ,strong) RESFriendManagedObject *editFriend;
@end

@implementation RESFriendsEditViewController


#pragma mark - view life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureView];
}

- (void)configureView
{
    if (self.editFriendID) {
        //通过ID读取对象
        NSManagedObjectContext *moc = [[RESCoreDataManager sharedManager] managedObjectContext];
        RESFriendManagedObject *friendMO = (RESFriendManagedObject *)[moc objectWithID:self.editFriendID];
        [self setEditFriend:friendMO];
        //更新UITextField
        [self.friendName setText:[friendMO valueForKey:@"friendName"]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)saveButtonTouched:(id)sender
{
    //更新friendName
    NSString *fName = [self.friendName text];
    [self.editFriend setValue:fName forKey:@"friendName"];
    
    NSManagedObjectContext *moc = [[RESCoreDataManager sharedManager] managedObjectContext];
    NSError *saveError = nil;
    [moc save:&saveError];
    
    if (saveError) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error saving friend" message:[saveError localizedDescription] delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        NSLog(@"Changes to friend saved.");
    }
    //关闭视图
    if (self.navigationController.presentingViewController) {
        //Modal segue
        [self.navigationController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        //Show segue
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

- (IBAction)cancelButtonTouched:(id)sender
{
    NSManagedObjectContext *moc = [[RESCoreDataManager sharedManager] managedObjectContext];
    //取消
    if ([moc hasChanges]) {
        [moc rollback];
        NSLog(@"Rolled back changes.");
    }
    //关闭视图
    if (self.navigationController.presentingViewController) {
        // modal segue
        [self.navigationController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {   // show segue
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}


@end
