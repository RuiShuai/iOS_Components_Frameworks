//
//  MasterViewController.m
//  MyMovies
//
//  Created by taotao on 14/12/25.
//  Copyright (c) 2014年 RuiShuai Co., Ltd. All rights reserved.
//

#import "RESMovieListViewController.h"
#import "RESMovieDisplayViewController.h"
#import "RESMovieManagedObject.h"


@interface RESMovieListViewController ()

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

@end

@implementation RESMovieListViewController

@synthesize fetchedResultsController = _fetchedResultsController;

#pragma mark - View Life Cycle

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    //init coredataManager managedObjectContext
    self.managedObjectContext = [[RESCoreDataManager sharedManager] managedObjectContext];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //获取section中的记录数
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    //设置section标题
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    if ([[sectionInfo indexTitle] isEqualToString:@"1"]) {
        return @"Shared";
    }
    else
    {
        return @"Not Shared";
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell"];
    //调用专用API配置单元格
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        //获得被删除对象
        NSManagedObject *objectToBeDeleted = [self.fetchedResultsController objectAtIndexPath:indexPath];
        [context deleteObject:objectToBeDeleted];
        //同步更新coredata
        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"Error deleting movie, %@",[error userInfo]);
        }
    }
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {

    //拿到movie对象
    RESMovieManagedObject *movieMO = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.textLabel.text = [movieMO cellTitle];
    cell.detailTextLabel.text = [movieMO movieDescription];
    
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    //showDetail
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        
        //拿到movieMO对象
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        RESMovieManagedObject *movieMO = [[self fetchedResultsController] objectAtIndexPath:indexPath];
        
        //show转场MovieDisplayVC
        RESMovieDisplayViewController *movieDisplayVC = (RESMovieDisplayViewController *)[segue destinationViewController];
        [movieDisplayVC setMovieDetailID:[movieMO objectID]];
        
    }
    
    //addMovie
    if ([[segue identifier] isEqualToString:@"addMovie"]) {
        //拿到managedObjectContext工作区
        NSManagedObjectContext *moc = [self managedObjectContext];//[[RESCoreDataManager sharedManager] managedObjectContext];
        
        //newMovie default
        RESMovieManagedObject *newMovieMO = [NSEntityDescription insertNewObjectForEntityForName:@"Movie" inManagedObjectContext:moc];
        NSLog(@"newMovieMO objectID:%@",[newMovieMO objectID]);
        [newMovieMO setTitle:@"New Movie"];
        [newMovieMO setYear:@"2014"];
        [newMovieMO setMovieDescription:@"New movie description"];
        [newMovieMO setLent:@NO];
        [newMovieMO setLentOn:nil];
        [newMovieMO setTimesWatched:@0];

        //同步更新CoreData
        NSError *mocSaveError = nil;
        if (![moc save:&mocSaveError]) {
            NSLog(@"Save did not complete successfully. Error: %@",[mocSaveError localizedDescription]);
        }
        
        //modal转场nc + EditVC
        UINavigationController *nc = (UINavigationController *)[segue destinationViewController];
        RESMovieEditViewController *mEVC = (RESMovieEditViewController *)[nc visibleViewController];
        
        [mEVC setEditMovieID:[newMovieMO objectID]];
        //为什么要设置delegate为nil?
        [mEVC setDelegate:nil];
    }
    
}

#pragma mark - Fetched results controller

//构建liaison联络者
- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSManagedObjectContext *moc = [[RESCoreDataManager sharedManager] managedObjectContext];//self.managedObjectContext;//
    
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Movie" inManagedObjectContext:moc];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES];
    NSSortDescriptor *sharedSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"lent" ascending:NO];
    
    NSArray *sortDescriptors = @[sortDescriptor,sharedSortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest                  managedObjectContext:moc sectionNameKeyPath:@"lent" cacheName:nil];
    
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return _fetchedResultsController;
}    

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
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

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

/*
// Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed. 
 
 - (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    // In the simplest, most efficient, case, reload the table view.
    [self.tableView reloadData];
}
 */

@end
