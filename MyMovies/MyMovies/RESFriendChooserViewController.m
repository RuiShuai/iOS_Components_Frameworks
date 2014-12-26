//
//  RESFriendChooserViewController.m
//  MyMovies
//
//  Created by taotao on 14/12/25.
//  Copyright (c) 2014年 RuiShuai Co., Ltd. All rights reserved.
//

#import "RESFriendChooserViewController.h"

@interface RESFriendChooserViewController ()

@end

@implementation RESFriendChooserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSManagedObjectContext *moc = [[RESCoreDataManager sharedManager] managedObjectContext];
    NSFetchRequest *fetchReq = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Friend" inManagedObjectContext:moc];
    
    [fetchReq setEntity:entity];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"friendName" ascending:YES];
    
    NSArray *sortDescriptors = @[sortDescriptor];
    [fetchReq setSortDescriptors:sortDescriptors];
    
    NSError *error = nil;
    self.friendList = [moc executeFetchRequest:fetchReq error:&error];
    
    if (error) {
        NSString *errorDesc = [error localizedDescription];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error fetching friends" message:errorDesc delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        [alert show];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    return [self.friendList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
    // Configure the cell...
    static NSString *CellIdentifier = @"FriendChooserCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    RESFriendManagedObject *friendMO = [self.friendList objectAtIndex:indexPath.row];
    [[cell textLabel] setText:[friendMO valueForKey:@"friendName"]];
    if (friendMO == self.selectedFriend) {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }
    else
    {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    return cell;
}


#pragma mark - Table view delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //获取所有可见单元格,设置accessory为None
    NSArray *visibleIndexPaths = [tableView indexPathsForVisibleRows];
    for (NSIndexPath *ip in visibleIndexPaths) {
        UITableViewCell *clearCell = [tableView cellForRowAtIndexPath:ip];
        [clearCell setAccessoryType:UITableViewCellAccessoryNone];
    }
    //设置当前单元格accessory为checkmark
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    
    //传递selectedFriend参数
    [self.delegate chooserSelectedFriend:[self.friendList objectAtIndex:indexPath.row]];
    //show segue关闭视图
    [self.navigationController popViewControllerAnimated:YES];
    
}

@end
