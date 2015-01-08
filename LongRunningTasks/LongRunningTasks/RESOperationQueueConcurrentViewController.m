//
//  RESOperationQueueConcurrentViewController.m
//  LongRunningTasks
//
//  Created by taotao on 15/1/8.
//  Copyright (c) 2015年 RuiShuai Co., Ltd. All rights reserved.
//

#import "RESOperationQueueConcurrentViewController.h"

@interface RESOperationQueueConcurrentViewController ()
-(void)performLongRunningTaskForIteration:(id)iteration;
-(void)updateTableData:(id)moreData;
@end

@implementation RESOperationQueueConcurrentViewController

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
    //定义队列
    self.processingQueue = [[NSOperationQueue alloc]init];
    //设置表头视图
    [self.tableView setTableHeaderView:self.statusView];

}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    SEL taskSelector = @selector(performLongRunningTaskForIteration:);
    
    for (int i=1; i<=5; i++) {
        NSNumber *iteration = [NSNumber numberWithInt:i];
        
        //定义操作
        NSInvocationOperation *operation = [[NSInvocationOperation alloc]initWithTarget:self selector:taskSelector object:iteration];
        //定义回调
        [operation setCompletionBlock:^{
            NSLog(@"Operation #%d completed.",i);
        }];
        
        //添加操作至队列
        [self.processingQueue addOperation:operation];
    }
    
}

-(void)performLongRunningTaskForIteration:(id)iteration
{
    NSNumber *iterationNumber = (NSNumber *)iteration;
    NSMutableArray *newArray = [[NSMutableArray alloc]initWithCapacity:10];
    for (int i=1; i<=10; i++) {
        [newArray addObject:[NSString stringWithFormat:@"Item %@-%d",iterationNumber,i]];
        [NSThread sleepForTimeInterval:0.1];
        NSLog(@"OpQ Concurrent Added %@-%d",iterationNumber,i);
    }
    
    //调用主进程更新UI
    [self performSelectorOnMainThread:@selector(updateTableData:)
                           withObject:newArray
                        waitUntilDone:NO];
    
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

#pragma mark - user action
- (IBAction)cancelButtonTouched:(id)sender
{
    NSLog(@"%@",NSStringFromSelector(_cmd));
    [self.processingQueue cancelAllOperations];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [self.displayItems count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.displayItems objectAtIndex:section] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier =@"RESOperationQueueConcurrentCell";
    
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
