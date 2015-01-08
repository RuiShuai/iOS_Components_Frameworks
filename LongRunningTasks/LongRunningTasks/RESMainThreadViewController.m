//
//  RESMainThreadViewController.m
//  LongRunningTasks
//
//  Created by taotao on 15/1/8.
//  Copyright (c) 2015年 RuiShuai Co., Ltd. All rights reserved.
//

#import "RESMainThreadViewController.h"

@interface RESMainThreadViewController ()
-(void)performLongRunningTaskForIteration:(id)iteration;
@end

@implementation RESMainThreadViewController

#pragma mark - view life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.displayItems = [[NSMutableArray alloc]initWithCapacity:45];
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
    
    //main thread
    for (int i=1; i<=5; i++) {
        NSNumber *iteration = [NSNumber numberWithInt:i];
        //主进程中执行
        [self performLongRunningTaskForIteration:iteration];
    }
}


-(void)performLongRunningTaskForIteration:(id)iteration
{
    NSNumber *iterationNumber = (NSNumber *)iteration;
    
    NSMutableArray *newArray = [[NSMutableArray alloc]initWithCapacity:10];
    
    for (int i=0; i<=10; i++) {
        [newArray addObject:[NSString stringWithFormat:@"Item %@-%d",iterationNumber,i]];
        //模拟卡顿
        [NSThread sleepForTimeInterval:0.1];
        NSLog(@"Main Added %@-%d",iterationNumber,i);
    }
    
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
    
    static NSString *CellIdentifier =@"RESMainThreadCell";
    
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
