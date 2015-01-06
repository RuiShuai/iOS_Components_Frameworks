//
//  RESAssetGroupViewController.m
//  AssetLibraryNavigator
//
//  Created by taotao on 15/1/6.
//  Copyright (c) 2015年 RuiShuai Co., Ltd. All rights reserved.
//

#import "RESAssetGroupViewController.h"
#import "RESAssetGroupTableCell.h"
#import "RESAssetDetailViewController.h"

@interface RESAssetGroupViewController ()
-(void)retrieveAssetGroupByURL;
-(void)enumerateGroupAssetsForGroup:(ALAssetsGroup *)group;
@end

@implementation RESAssetGroupViewController

#pragma mark - view life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:self.assetGroupName];
    
    //enable/disable addButton
    NSRange cameraRollLoc = [self.assetGroupName rangeOfString:@"Camera Roll"];
    if (cameraRollLoc.location == NSNotFound) {
        [self.addButton setEnabled:NO];
    }
    
    //initialize AssetsLibrary,AssetArray
    ALAssetsLibrary *setupAssetsLibrary = [[ALAssetsLibrary alloc] init];
    [self setAssetLibrary:setupAssetsLibrary];
    
    NSMutableArray *setupArray = [[NSMutableArray alloc]init];
    [self setAssetArray:setupArray];
    
    //retrieveAssetGroupByURL
    [self retrieveAssetGroupByURL];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [self setAssetDetailTableView:nil];
    [self setAddButton:nil];
    self.assetArray = nil;
    self.assetGroupURL = nil;
    self.assetGroupName = nil;
    self.assetLibrary = nil;
}



#pragma mark - Asset Methods

-(void)retrieveAssetGroupByURL
{
    //retrieveGroupBlock
    void (^retrieveGroupBlock)(ALAssetsGroup *) = ^(ALAssetsGroup* group){
        if (group) {
            //遍历group
            [self enumerateGroupAssetsForGroup:group];
        }else{
            NSLog(@"Error. Can't find group!");
        }
    };
    
    //handleAssetGroupErrorBlock
    void (^handleAssetGroupErrorBlock)(NSError *) = ^(NSError *error){
        NSString *errMsg = @"Error accessing group";
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:errMsg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertView show];
    };
    
    //url查找group
    [self.assetLibrary groupForURL:self.assetGroupURL
                       resultBlock:retrieveGroupBlock
                      failureBlock:handleAssetGroupErrorBlock];
}

-(void)enumerateGroupAssetsForGroup:(ALAssetsGroup *)group
{
    //遍历结束标记
    NSInteger lastIndex = [group numberOfAssets] - 1;
    //回调Block
    void (^addAsset)(ALAsset*,NSUInteger, BOOL*) = ^(ALAsset* result,NSUInteger index,BOOL* stop){
        //填充数据
        if (result != nil) {
            [self.assetArray addObject:result];
        }
        //更新表格视图
        if (index == lastIndex) {
            [self.assetDetailTableView reloadData];
        }
    };
    
    //遍历
    [group enumerateAssetsUsingBlock:addAsset];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    NSInteger returnCount = 0;
    
    if (self.assetArray && [self.assetArray count] >0) {
        if ([self.assetArray count] % 4 == 0) {
            returnCount = ([self.assetArray count] / 4);
        }else{
            returnCount = ([self.assetArray count] / 4)+1;
        }
    }
    
    return returnCount;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    NSString *cellID = @"RESAssetGroupTableCell";
    RESAssetGroupTableCell *cell = (RESAssetGroupTableCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    
    //first:0
    ALAsset *firstAsset = [self.assetArray objectAtIndex:indexPath.row *4];
    [cell.assetButton1 setImage:[UIImage imageWithCGImage:[firstAsset thumbnail]] forState:UIControlStateNormal];
    [cell.assetButton1 setTag:indexPath.row * 4];
    
    //second:1
    if (indexPath.row * 4 + 1 <[self.assetArray count]) {
        ALAsset *secondAsset = [self.assetArray objectAtIndex:indexPath.row *4 + 1];
        [cell.assetButton2 setImage:[UIImage imageWithCGImage:[secondAsset thumbnail]] forState:UIControlStateNormal];
        [cell.assetButton2 setTag:indexPath.row * 4 + 1];
        [cell.assetButton2 setEnabled:YES];
    }else{
        [cell.assetButton2 setImage:nil forState:UIControlStateNormal];
        [cell.assetButton2 setEnabled:NO];
    }
    
    //third:2
    if (indexPath.row * 4 + 2 <[self.assetArray count]) {
        ALAsset *thirdAsset = [self.assetArray objectAtIndex:indexPath.row *4 + 2];
        [cell.assetButton3 setImage:[UIImage imageWithCGImage:[thirdAsset thumbnail]] forState:UIControlStateNormal];
        [cell.assetButton3 setTag:indexPath.row * 4 + 2];
        [cell.assetButton3 setEnabled:YES];
    }else{
        [cell.assetButton3 setImage:nil forState:UIControlStateNormal];
        [cell.assetButton3 setEnabled:NO];
    }
    
    //fourth:3
    if (indexPath.row * 4 + 3 <[self.assetArray count]) {
        ALAsset *fourthAsset = [self.assetArray objectAtIndex:indexPath.row *4 + 3];
        [cell.assetButton4 setImage:[UIImage imageWithCGImage:[fourthAsset thumbnail]] forState:UIControlStateNormal];
        [cell.assetButton4 setTag:indexPath.row * 4 + 3];
        [cell.assetButton4 setEnabled:YES];
    }else{
        [cell.assetButton4 setImage:nil forState:UIControlStateNormal];
        [cell.assetButton4 setEnabled:NO];
    }
    
    return cell;
}




#pragma mark - ImagePickerController delegate

- (IBAction)addButtonTouched:(id)sender
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
        [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
        [imagePicker setDelegate:self];
        //modal方式跳转
        [self presentViewController:imagePicker animated:YES completion:nil];
    }else{
        NSString *errMsg = @"Camera Not Avaliable";
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:errMsg delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        [alertView show];
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *selectedImage = [info objectForKey:UIImagePickerControllerEditedImage];
    if (!selectedImage) {
        selectedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    
    //保存
    UIImageWriteToSavedPhotosAlbum(selectedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error!=nil) {
        NSLog(@"Error Saving:%@",[error localizedDescription]);
        return;
    }
    
    [self.assetArray removeAllObjects];
    
    //重新获取数据
    [self retrieveAssetGroupByURL];
    
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"ViewAssetDetail"]) {
        
        //判断来自哪个button
        NSInteger indexForAsset = [sender tag];
        ALAsset *selectedAsset = [self.assetArray objectAtIndex:indexForAsset];
        
        //转场
        RESAssetDetailViewController *assetDetailVC = segue.destinationViewController;
        ALAssetRepresentation *rep = [selectedAsset defaultRepresentation];
        UIImage *img = [UIImage imageWithCGImage:[rep fullScreenImage]];
        [assetDetailVC setAssetImage:img];
        
    }
}




@end
