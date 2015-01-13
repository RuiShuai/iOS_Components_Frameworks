//
//  RESNotesListViewController.m
//  MyNotes2
//
//  Created by taotao on 15/1/9.
//  Copyright (c) 2015年 RuiShuai Co., Ltd. All rights reserved.
//

#import "RESNotesListViewController.h"
#import "RESNotesDetailViewController.h"
#import "RESMyNoteDocument.h"

@interface RESNotesListViewController ()

@end

@implementation RESNotesListViewController

#pragma mark - view life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // init noteList
    if (!noteList) {
        noteList = [[NSMutableArray alloc]init];
    }
    // init noteQuery
    if (!noteQuery) {
        noteQuery = [self noteListQuery];
    }
    
    //register notification message
    NSNotificationCenter *notifiCenter = [NSNotificationCenter defaultCenter];
    
    NSString *metaDataFinished = NSMetadataQueryDidFinishGatheringNotification;
    
    [notifiCenter addObserver:self selector:@selector(processFiles:) name:metaDataFinished object:nil];
    
    NSString *metaDataUpdated = NSMetadataQueryDidUpdateNotification;
    [notifiCenter addObserver:self selector:@selector(processFiles:) name:metaDataUpdated object:nil];
    
    NSString *keyValueStoreUpdated = NSUbiquitousKeyValueStoreDidChangeExternallyNotification;
    [notifiCenter addObserver:self selector:@selector(updateLastUpdatedNote:) name:keyValueStoreUpdated object:nil];

    //start query
    [noteQuery startQuery];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self updateLastUpdatedNote:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

#pragma mark - custom methods

- (NSMetadataQuery *)noteListQuery
{
    NSMetadataQuery *setupQuery = [[NSMetadataQuery alloc]init];
    
    [setupQuery setSearchScopes:@[NSMetadataQueryUbiquitousDocumentsScope]];
    
    NSString *filePattern = [NSString stringWithFormat:@"*.%@",kRESMyNoteDocumentExtension];
    
    [setupQuery setPredicate:[NSPredicate predicateWithFormat:@"%K LIKE %@",NSMetadataItemFSNameKey,filePattern]];
    
    return setupQuery;
    
    
}

- (void)processFiles:(NSNotification *)notification
{
    NSMutableArray *foundFiles = [[NSMutableArray alloc] init];
    //disableUpdates
    [noteQuery disableUpdates];
    
    NSArray *queryResults = [noteQuery results];
    for (NSMetadataItem *result in queryResults) {
        NSURL *fileURL = [result valueForAttribute:NSMetadataItemURLKey];
        
        NSNumber *isHidden = nil;
        [fileURL getResourceValue:&isHidden forKey:NSURLIsHiddenKey error:nil];
        
        if (isHidden && ![isHidden boolValue]) {
            [foundFiles addObject:fileURL];
        }
        
    }
    
    //output query result
    [noteList removeAllObjects];
    [noteList addObjectsFromArray:foundFiles];
    [self.tableView reloadData];
    
    //enableUpdates
    [noteQuery enableUpdates];
    
}

- (void)updateLastUpdatedNote:(NSNotification *)notification
{
    NSUbiquitousKeyValueStore *iCloudKeyValueStore = [NSUbiquitousKeyValueStore defaultStore];
    
    self.lastUpdateNote = [iCloudKeyValueStore stringForKey:kRESLastUpdatedNoteKey];
    
    [self.tableView reloadData];
    
}



- (IBAction)addButtonTouched:(id)sender
{
    [self.navigationItem.rightBarButtonItem setEnabled:NO];
    
    //async queue
    dispatch_queue_t background = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(background, ^{
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        //newNoteURL
        NSURL *newNoteURL = [fileManager URLForUbiquityContainerIdentifier:nil];
        newNoteURL = [newNoteURL URLByAppendingPathComponent:kRESDocumentDirectoryName isDirectory:YES];
        newNoteURL = [newNoteURL URLByAppendingPathComponent:[self newMyNoteName]];//[self newMyNoteName];
        
        //get_main_queue
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [noteList addObject:newNoteURL];
            
            NSIndexPath *newCellIndexPath = [NSIndexPath indexPathForRow:([noteList count]-1) inSection:0];
            
            [self.tableView insertRowsAtIndexPaths:@[newCellIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            
            [self.tableView selectRowAtIndexPath:newCellIndexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
            
            UITableViewCell *newNoteCell = [self.tableView cellForRowAtIndexPath:newCellIndexPath];
            //perform segue
            [self performSegueWithIdentifier:kRESDisplayNoteDetailSegue sender:newNoteCell];
            [self.navigationItem.rightBarButtonItem setEnabled:YES];
        });
        
    });
    
}

- (NSString *)newMyNoteName
{
    NSInteger noteCount = 1;
    NSString *newMyNoteName = nil;
    
    BOOL gotName = NO;
    while (!gotName) {
        
        newMyNoteName = [NSString stringWithFormat:@"MyNote %d.%@",noteCount,kRESMyNoteDocumentExtension];
        BOOL noteNameExists = NO;
        
        for (NSURL *noteURL in noteList) {
            if ([[noteURL lastPathComponent] isEqualToString:newMyNoteName]) {
                noteCount++;
                noteNameExists = YES;
            }
        }
        
        if (!noteNameExists) {
            gotName = YES;
        }
        
    }
    return newMyNoteName;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [noteList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kRESMyNoteCellIdentifier forIndexPath:indexPath];
    
    NSURL *myNoteURL = [noteList objectAtIndex:[indexPath row]];
    
    NSString *noteName = [[myNoteURL lastPathComponent] stringByDeletingPathExtension];
    
    if ([self.lastUpdateNote isEqualToString:noteName]) {
        NSString *lastUpdatedCellTitle = [NSString stringWithFormat:@"★ %@",noteName];
        [cell.textLabel setText:lastUpdatedCellTitle];
    }
    else{
        [cell.textLabel setText:noteName];
    }
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSURL *myNoteURL = [noteList objectAtIndex:[indexPath row]];
        
        //async queue
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            NSFileCoordinator *fileCoordinator = [[NSFileCoordinator alloc]initWithFilePresenter:nil];
            
            [fileCoordinator coordinateWritingItemAtURL:myNoteURL options:NSFileCoordinatorWritingForDeleting error:nil byAccessor:^(NSURL *newURL) {
                
                NSFileManager *fileManager = [[NSFileManager alloc]init];
                [fileManager removeItemAtURL:newURL error:nil];
                
            }];
            
            
        });
        
        
    }else if (editingStyle == UITableViewCellEditingStyleInsert){
        
    }
}


#pragma mark - Navigation


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:kRESDisplayNoteDetailSegue]) {
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        NSURL *mySelectedNote = noteList[indexPath.row];
        
        UITableViewCell *selectedCell = [self.tableView cellForRowAtIndexPath:indexPath];
        
        [[segue destinationViewController] setMyNoteURL:mySelectedNote    ];
        [[[segue destinationViewController] navigationItem] setTitle:[[selectedCell textLabel]text]];
        
        
    }
}


@end
