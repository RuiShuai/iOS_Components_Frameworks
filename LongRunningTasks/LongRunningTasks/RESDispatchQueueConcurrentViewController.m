//
//  RESDispatchQueueConcurrentViewController.m
//  LongRunningTasks
//
//  Created by taotao on 15/1/8.
//  Copyright (c) 2015年 RuiShuai Co., Ltd. All rights reserved.
//

#import "RESDispatchQueueConcurrentViewController.h"

@interface RESDispatchQueueConcurrentViewController ()
-(void)performLongRunningTaskForIteration:(id)iteration;
-(void)updateTableData:(id)moreData;
@end

@implementation RESDispatchQueueConcurrentViewController


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
    
    //定义分发队列
    dispatch_queue_t workQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
   
    for (int i=1; i<=5; i++) {
        NSNumber *iteration = [NSNumber numberWithInt:i];
        //异步进程执行
        dispatch_async(workQueue, ^{
            [self performLongRunningTaskForIteration:iteration];
        });
        
    }
    
}

-(void)performLongRunningTaskForIteration:(id)iteration
{
    NSNumber *iterationNumber = (NSNumber *)iteration;
    
    __block NSMutableArray *newArray = [[NSMutableArray alloc]initWithCapacity:10];

    //定义分发队列
    dispatch_queue_t detailQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);
    
    //应用分发线程
    size_t loop = (size_t)[iterationNumber intValue];
    dispatch_apply(loop, detailQueue, ^(size_t i) {
        [newArray addObject:[NSString stringWithFormat:@"Item %@-%zu",iterationNumber,i+1]];
        [NSThread sleepForTimeInterval:0.1];
        NSLog(@"DpQ Concurrent Added %@-%zu",iterationNumber,i+1);
    });
    
    //调用主线程更新UI
    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateTableData:newArray];
    });
    
    /*
    for (int i=1; i<=10; i++) {
        [newArray addObject:[NSString stringWithFormat:@"Item %@-%d",iterationNumber,i]];
        [NSThread sleepForTimeInterval:0.1];
        NSLog(@"Background Added %@-%d",iterationNumber,i);
    }
    //调用主线程更新UI
    [self performSelectorOnMainThread:@selector(updateTableData:) withObject:newArray waitUntilDone:NO];
    */
    
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
    
    static NSString *CellIdentifier =@"RESDispatchQueueConcurrentCell";
    
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
