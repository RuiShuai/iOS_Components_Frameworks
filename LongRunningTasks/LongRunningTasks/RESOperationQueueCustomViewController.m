//
//  RESOperationQueueCustomViewController.m
//  LongRunningTasks
//
//  Created by taotao on 15/1/8.
//  Copyright (c) 2015年 RuiShuai Co., Ltd. All rights reserved.
//

#import "RESOperationQueueCustomViewController.h"

@interface RESOperationQueueCustomViewController ()

-(void)updateTableData:(id)moreData;

@end

@implementation RESOperationQueueCustomViewController


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
    self.processingQueue = [[NSOperationQueue alloc]init];
    [self.tableView setTableHeaderView:self.statusView];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //模拟堆栈
    NSMutableArray *operationsToAdd = [[NSMutableArray alloc]init];

    RESCustomOperation *prevOperation = nil;
    
    for (int i=1; i<=5; i++) {
        NSNumber *iteration = [NSNumber numberWithInt:i];
        
        //定义操作
        RESCustomOperation *operation = [[RESCustomOperation alloc]initWithIteration:iteration andDelegate:self];
        
        NSLog(@"...not cancelled, execute logic here");
        if (prevOperation) {
            [operation addDependency:prevOperation];
        }
        [operationsToAdd addObject:operation];
    }
    
    //顺次添加操作至进程队列
    for (RESCustomOperation *operation in operationsToAdd) {
        [self.processingQueue addOperation:operation];
    }
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
#pragma mark - RESCustomOperationDelegate

-(void)updateTableWithData:(NSArray *)moreData
{
    //调用主线程更新UI
    [self performSelectorOnMainThread:@selector(updateTableData:) withObject:moreData waitUntilDone:YES];
}

-(void)updateTableData:(id)moreData
{
    NSArray *newArray = (NSArray *)moreData;
    [self.displayItems addObject:newArray];
    [self.tableView reloadData];
}

#pragma mark - user action
- (IBAction)cancelButtonTouched:(id)sender
{
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
    
    static NSString *CellIdentifier =@"RESOperationQueueCustomCell";
    
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
