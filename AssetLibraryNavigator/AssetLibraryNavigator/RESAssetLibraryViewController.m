//
//  RESAssertLibraryViewController.m
//  AssetLibraryNavigator
//
//  Created by taotao on 15/1/6.
//  Copyright (c) 2015年 RuiShuai Co., Ltd. All rights reserved.
//

#import "RESAssetLibraryViewController.h"
#import "RESAssetLibraryTableCell.h"
#import "RESAssetGroupViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>

#define kGroupLabelText @"groupLabelText"
#define kGroupInfoText @"groupInfoText"
#define kGroupURL @"groupURL"
#define kGroupPosterImage @"groupPosterImage"

@interface RESAssetLibraryViewController ()

@end

@implementation RESAssetLibraryViewController

#pragma mark - view life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"Asset Groups"];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [self setupAssetData];
}


-(void)setupAssetData
{
    ALAssetsLibrary *al = [[ALAssetsLibrary alloc] init];
    NSMutableArray *setupArray = [[NSMutableArray alloc]init];
    
    //enumerateAssetGroupsBlock
    void (^enumerateAssetGroupsBlock)(ALAssetsGroup*,BOOL*) = ^(ALAssetsGroup* group,BOOL* stop){
        if (group) {
            NSUInteger numAssets = [group numberOfAssets];
            
            //prepare key/values
            NSString *groupName = [group valueForProperty:ALAssetsGroupPropertyName];
            NSLog(@"Group: %@, editable: %d",groupName,[group isEditable]);
            
            NSURL *groupURL = [group valueForProperty:ALAssetsGroupPropertyURL];
            
            NSString *groupLabelText = [NSString stringWithFormat:@"%@ (%d)",groupName,numAssets];
            
            UIImage *posterImage = [UIImage imageWithCGImage:[group posterImage]];
            
            [group setAssetsFilter:[ALAssetsFilter allPhotos]];
            NSInteger groupPhotos = [group numberOfAssets];
            
            [group setAssetsFilter:[ALAssetsFilter allVideos]];
            NSInteger groupVideos = [group numberOfAssets];
            
            NSString *info = @"%d photos, %d videos in group";
            NSString *groupInfoText = [NSString stringWithFormat:info,groupPhotos,groupVideos];
            
            NSDictionary *groupDict = @{
                    kGroupLabelText:groupLabelText,
                    kGroupURL:groupURL,
                    kGroupPosterImage:posterImage,
                    kGroupInfoText:groupInfoText
                };
            //add to array
            [setupArray addObject:groupDict];
        }else{
            //遍历完成之后,设置到assetGroupArray全局属性值
            [self setAssetGroupArray:[NSArray arrayWithArray:setupArray]];
            //更新表格数据
            [self.assetGroupTableView reloadData];
        }
    };
    
    
    //assetGroupEnumErrorBlock
    void (^assetGroupEnumErrorBlock)(NSError*) = ^(NSError* error){
        NSString *msgError = @"Cannot access asset library groups. \n"
        "Visit Privacy | Photos in Settings.app \n"
        "to restore permission.";
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:msgError delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        
    };
    
    //遍历
    [al enumerateGroupsWithTypes:ALAssetsGroupAll
                      usingBlock:enumerateAssetGroupsBlock
                    failureBlock:assetGroupEnumErrorBlock];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [self setAssetGroupTableView:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger returnCount = 0;
    if (_assetGroupArray) {
        returnCount = [_assetGroupArray count];
    }
    return returnCount;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellID = @"RESAssetLibraryTableCell";
    RESAssetLibraryTableCell *cell = (RESAssetLibraryTableCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    
    NSDictionary *cellDict = [_assetGroupArray objectAtIndex:indexPath.row];
    [cell.assetGroupNameLabel setText:[cellDict objectForKey:kGroupLabelText]];
    [cell.assetGroupInfoLabel setText:[cellDict objectForKey:kGroupInfoText]];
    [cell.assetGroupImageView setImage:[cellDict objectForKey:kGroupPosterImage]];
    
    return cell;
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ViewAssetGroup"]) {
        NSIndexPath *indexPath = [self.assetGroupTableView indexPathForSelectedRow];
        
        NSDictionary *selectedDict = [self.assetGroupArray objectAtIndex:indexPath.row];
        [self setSelectedGroupURL:[selectedDict objectForKey:kGroupURL]];
        
        //转场
        RESAssetGroupViewController *assetGroupVC = segue.destinationViewController;
        [assetGroupVC setAssetGroupURL:[self selectedGroupURL]];
        [assetGroupVC setAssetGroupName:[selectedDict objectForKey:kGroupLabelText]];
        
        [self.assetGroupTableView deselectRowAtIndexPath:indexPath animated:NO];
        
    }
}


@end
