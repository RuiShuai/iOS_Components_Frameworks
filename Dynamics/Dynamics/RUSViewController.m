//
//  RUSViewController.m
//  Dynamics
//
//  Created by taotao on 14/12/20.
//  Copyright (c) 2014年 RuiShuai Co., Ltd. All rights reserved.
//

#import "RUSViewController.h"
#import "RUSGravityViewController.h"
#import "RUSCollisionViewController.h"
#import "RUSAttachmentsViewController.h"
#import "RUSSpringViewController.h"
#import "RUSSnapViewController.h"
#import "RUSForceViewController.h"
#import "RUSPropertiesViewController.h"

@interface RUSViewController ()

@end

@implementation RUSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"UIKit Dynamics";
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_tableView deselectRowAtIndexPath:[_tableView indexPathForSelectedRow] animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - TableView DataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    switch ([indexPath row]) {
        case 0:
            cell.textLabel.text = @"Gravity";
            break;
        case 1:
            cell.textLabel.text = @"Collisions";
            break;
        case 2:
            cell.textLabel.text = @"Attachments";
            break;
        case 3:
            cell.textLabel.text = @"Springs";
            break;
        case 4:
            cell.textLabel.text = @"Snap";
            break;
        case 5:
            cell.textLabel.text = @"Forces";
            break;
        case 6:
            cell.textLabel.text = @"Properties";
            break;
        default:
            break;
    }
    
    return cell;
}

#pragma mark - TableView Delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *viewController = nil;
    switch ([indexPath row]) {
        case 0:
            viewController = [[RUSGravityViewController alloc]init];
            break;
        case 1:
            viewController = [[RUSCollisionViewController alloc]init];
            break;
        case 2:
            viewController = [[RUSAttachmentsViewController alloc]init];
            break;
        case 3:
            viewController = [[RUSSpringViewController alloc]init];
            break;
        case 4:
            viewController = [[RUSSnapViewController alloc]init];
            break;
        case 5:
            viewController = [[RUSForceViewController alloc]init];
            break;
        case 6:
            viewController = [[RUSPropertiesViewController alloc]init];
            break;
        default:
            break;
    }
    [self.navigationController pushViewController:viewController animated:YES];
    
}



@end
