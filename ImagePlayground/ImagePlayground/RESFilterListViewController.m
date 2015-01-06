//
//  RESFilterListViewController.m
//  ImagePlayground
//
//  Created by taotao on 14/12/31.
//  Copyright (c) 2014年 RuiShuai Co., Ltd. All rights reserved.
//

#import "RESFilterListViewController.h"
#import "RESFilterDetailViewController.h"

@interface RESFilterListViewController ()
@property (nonatomic,strong) NSArray *filterArray;
@property (nonatomic,strong) NSArray *filterNameArray;
@property (nonatomic,strong) NSArray *notImplementedArray;
@end

@implementation RESFilterListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.filterNameArray = [CIFilter filterNamesInCategory:self.selectedCategory];
    self.notImplementedArray = @[@"CIColorCube"];
    
    [self setContentSizeForViewInPopover:CGSizeMake(600, 600)];//540,512

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.filterNameArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Configure the cell...
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kRESFilterInCategoryCellIdentifier forIndexPath:indexPath];
    NSString *filterName = [self.filterNameArray objectAtIndex:indexPath.row];
    CIFilter *filter = [CIFilter filterWithName:filterName];
    NSDictionary *filterAttributes = [filter attributes];
    
    NSString *categoryName = [filterAttributes valueForKey:kCIAttributeFilterDisplayName];
    [cell.textLabel setText:categoryName];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *filterName = [self.filterNameArray objectAtIndex:indexPath.row];
    if ([self.notImplementedArray containsObject:filterName]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Not Implemented" message:@"This filter has not yet been implemented." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertView show];
    }else{
        [self performSegueWithIdentifier:kRESSelectFilterSegue sender:nil];
    }
}


#pragma mark - segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:kRESSelectFilterSegue]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSString *filterName = [self.filterNameArray objectAtIndex:indexPath.row];
        CIFilter *filter = [CIFilter filterWithName:filterName];
        [[segue destinationViewController] setSelectedFilter:filter];
        [[segue destinationViewController] setFilterDelegate:self.filterDelegate];
        [[[segue destinationViewController] navigationItem] setTitle:filterName];
    }
}


@end
