//
//  RESFilterCategoryViewController.m
//  ImagePlayground
//
//  Created by taotao on 14/12/31.
//  Copyright (c) 2014年 RuiShuai Co., Ltd. All rights reserved.
//

#import "RESFilterCategoryViewController.h"
#import "RESFilterListViewController.h"

@interface RESFilterCategoryViewController ()
@property (strong,nonatomic) NSDictionary *categoryList;
@property (strong,nonatomic) NSArray *categoryKeys;
@end

@implementation RESFilterCategoryViewController


#pragma mark - View Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.categoryList = @{
        @"Blur":kCICategoryBlur,
        @"Color Adjustment":kCICategoryColorAdjustment,
        @"Color Effect":kCICategoryColorEffect,
        @"Composite":kCICategoryCompositeOperation,
        @"Distortion":kCICategoryDistortionEffect,
        @"Generator":kCICategoryGenerator,
        @"Geometry Adjustment":kCICategoryGeometryAdjustment,
        @"Gradient":kCICategoryGradient,
        @"Halftone Effect":kCICategoryHalftoneEffect,
        @"Sharpen":kCICategorySharpen,
        @"Stylize":kCICategoryStylize,
        @"Tile":kCICategoryTileEffect,
        @"Transition":kCICategoryTransition
                          };
    self.categoryKeys = [self.categoryList allKeys];
    
    [self setContentSizeForViewInPopover:CGSizeMake(600,600)];//540,512
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [self.categoryList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    // Configure the cell...
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kRESCategoryListCellIdentifier forIndexPath:indexPath];
    NSString *categoryName = [self.categoryKeys objectAtIndex:indexPath.row];
    [cell.textLabel setText:categoryName];
    
    return cell;
}

#pragma mark - segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:kRESSelectFilterCategorySegue]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSString *displayName = self.categoryKeys[indexPath.row];
        UITableViewCell *selectedCell = [self.tableView cellForRowAtIndexPath:indexPath];
        NSString *category = [self.categoryList valueForKey:displayName];
        [[segue destinationViewController] setSelectedCategory:category];
        [[segue destinationViewController] setFilterDelegate:self.filterDelegate];
        [[[segue destinationViewController] navigationItem] setTitle:[[selectedCell textLabel] text]];
    }
    
}


@end
