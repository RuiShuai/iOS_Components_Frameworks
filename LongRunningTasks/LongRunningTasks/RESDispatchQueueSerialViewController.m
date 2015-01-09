//
//  RESDispatchQueueSerialViewController.m
//  LongRunningTasks
//
//  Created by taotao on 15/1/8.
//  Copyright (c) 2015年 RuiShuai Co., Ltd. All rights reserved.
//

#import "RESDispatchQueueSerialViewController.h"

@interface RESDispatchQueueSerialViewController ()
-(void)performLongRunningTaskForIteration:(id)iteration;
-(void)updateTableData:(id)moreData;
@end

@implementation RESDispatchQueueSerialViewController

#pragma mark - view life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.displayItems = [[NSMutableArray alloc]initWithCapacity:5];
    [self.displayItems addObject:@[
                                   @"Item Initial-1",
                                   @"Item Initial-2",
                                   @"Item Initial-3",
                                   @"Item Initial-4",
                                   @"Item Initial-5"
                                   ]];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //定义队列
    dispatch_queue_t workQueue = dispatch_queue_create("com.RuiShuai.serialQueue", NULL);
    
    for (int i=1; i<=5; i++) {
        NSNumber *iteration = [NSNumber numberWithInt:i];
        
        dispatch_async(workQueue, ^{
            [self performLongRunningTaskForIteration:iteration];
        });
    }
    
}

-(void)performLongRunningTaskForIteration:(id)iteration
{
    NSNumber *iterationNumber = (NSNumber *)iteration;
    NSMutableArray *newArray = [[NSMutableArray alloc]initWithCapacity:10];
    for (int i=1; i<=10; i++) {
        [newArray addObject:[NSString stringWithFormat:@"Item %@-%d",iterationNumber,i]];
        [NSThread sleepForTimeInterval:0.1];
        NSLog(@"DpQ Serial Added %@-%d",iterationNumber,i);
    }
    
    //调用主线程更新UI
    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateTableData:newArray];
    });
    
}

-(void)updateTableData:(id)moreData
{
    NSArray *newArray = (NSArray *)moreData;
    [self.displayItems addObject:newArray];
    [self.tableView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [self.displayItems count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.displayItems objectAtIndex:section] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier =@"RESDispatchQueueSerialCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSMutableArray *itemsForRow = [self.displayItems objectAtIndex:indexPath.section];
    NSString *labelForRow = [itemsForRow objectAtIndex:indexPath.row];
    [cell.textLabel setText:labelForRow];
    
    return cell;
}

#pragma mark - Table view delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%d section, %d row is selected",indexPath.section,indexPath.row);
}

@end
