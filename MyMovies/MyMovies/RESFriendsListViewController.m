//
//  RESFriendsListViewController.m
//  MyMovies
//
//  Created by taotao on 14/12/25.
//  Copyright (c) 2014年 RuiShuai Co., Ltd. All rights reserved.
//

#import "RESFriendsListViewController.h"

@interface RESFriendsListViewController ()
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
@end

@implementation RESFriendsListViewController

@synthesize fetchedResultsController = _fetchedResultsController;

#pragma mark - view life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    // Configure the cell...
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FriendCell"];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        NSManagedObjectContext *moc = [[RESCoreDataManager sharedManager] managedObjectContext];
        //获得被删除的对象
        NSManagedObject *objectToBeDeleted = [self.fetchedResultsController objectAtIndexPath:indexPath];
        
        //同步更新coredata
        [moc deleteObject:objectToBeDeleted];
        
        NSError *error = nil;
        if (![moc save:&error]) {
            
            if ([[[error userInfo] objectForKey:NSValidationKeyErrorKey] isEqualToString:@"lentMovies"]) {
                //提示警告
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error deleting friend" message:@"Can't delete friend - they still have your movie." delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
                [alert show];
                //coredata 回滚
                [moc rollback];
            }
            else
            {
                NSLog(@"Unresolved error %@, %@",error,[error userInfo]);
            }
            
        }
        // Delete the row from the data source
        //[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return NO;
}



- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    RESFriendManagedObject *friendMO = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.textLabel.text = [friendMO valueForKey:@"friendName"];
    NSInteger numShares = [[friendMO valueForKey:@"lentMovies"] count];
    
    NSString *subtitle = @"";
    switch (numShares) {
        case 0:
            subtitle = @"Not borrowing any movies.";
            break;
        case 1:
            subtitle = @"Borrowing 1 movie.";
            break;
        default:
            subtitle = [NSString stringWithFormat:@"Borrowing %d movies.",numShares];
            break;
    }
    cell.detailTextLabel.text = subtitle;
}

#pragma mark - NSFetchedResultsController delegate
-(NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    NSManagedObjectContext *moc = [[RESCoreDataManager sharedManager] managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]  init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Friend" inManagedObjectContext:moc];
    [fetchRequest setEntity:entity];
    
    [fetchRequest setFetchBatchSize:20];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"friendName" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:moc sectionNameKeyPath:nil cacheName:@"friendsList"   ];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        NSLog(@"UnResolved error %@, %@",error,[error userInfo]);
    }
    return _fetchedResultsController;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
    
}


-(void)controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
        default:
            return;
    }
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
    
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    //editFriend
    if ([[segue identifier] isEqualToString:@"editFriend"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        RESFriendManagedObject *friendMO = [self.fetchedResultsController objectAtIndexPath:indexPath];
        
        //show转场
        RESFriendsEditViewController *fEVC = (RESFriendsEditViewController *)[segue destinationViewController];
        [fEVC setEditFriendID:[friendMO objectID]];
        
    }
    
    
    //addFriend
    if ([[segue identifier] isEqualToString:@"addFriend"]) {
        //新建对象
        NSManagedObjectContext *moc = [[RESCoreDataManager sharedManager] managedObjectContext];
        RESFriendManagedObject *newFriendMO = [NSEntityDescription insertNewObjectForEntityForName:@"Friend" inManagedObjectContext:moc];
        [newFriendMO setValue:@"New Friend" forKey:@"friendName"];
        //更新coredata
        NSError *mocSaveError = nil;
        if (![moc save:&mocSaveError]) {
            NSLog(@"Save did not complete successfully. Error :%@",[mocSaveError localizedDescription]);
        }
        
        UINavigationController *nc = (UINavigationController *)[segue destinationViewController];
        RESFriendsEditViewController *fEVC = (RESFriendsEditViewController *)[nc visibleViewController];
        [fEVC setEditFriendID:[newFriendMO objectID]];
    }
    
    
}


@end
