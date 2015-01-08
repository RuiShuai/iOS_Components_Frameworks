//
//  RESCustomFlowViewController.m
//  PhotoGallery
//
//  Created by taotao on 15/1/7.
//  Copyright (c) 2015年 RuiShuai Co., Ltd. All rights reserved.
//

#import "RESCustomFlowLayoutViewController.h"
#import "RESPhotoAssetsManager.h"
#import "RESSectionHeader.h"
#import "RESThumbnailCell.h"
#import "RESCustomFlowLayout.h"
#import "RESRowDecorationView.h"

@interface RESCustomFlowLayoutViewController ()
@property (nonatomic,strong) NSMutableArray *assetArray;
@property (nonatomic,strong) NSMutableArray *assetGroupArray;
@property (nonatomic,strong) UICollectionViewFlowLayout *pageLayout;
@property (nonatomic,strong) RESPhotoAssetsManager *photoAssetsManager;
@end

@implementation RESCustomFlowLayoutViewController

static NSString * const reuseIdentifier = @"Cell";
static NSString * const kCustomThumbnailCell = @"kCustomThumbnailCell";
static NSString * const kCustomSectionHeader = @"kCustomSectionHeader";

#pragma mark - view life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置flowlayout
    [self.collectionView setCollectionViewLayout:[[RESCustomFlowLayout alloc] init]];
    [self.collectionView setAllowsMultipleSelection:YES];
    
    //注册SectionHeader
    [self.collectionView registerNib:[UINib nibWithNibName:@"RESSectionHeader" bundle:[NSBundle mainBundle]] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kCustomSectionHeader];
    
    //获取Asset
    self.photoAssetsManager = [[RESPhotoAssetsManager alloc]init];
    [self.photoAssetsManager setDelegate:self];
    self.assetGroupArray = [self.photoAssetsManager assetGroupArray];//[[NSMutableArray alloc]init];
    self.assetArray = [self.photoAssetsManager assetArray];//[[NSMutableArray alloc] init];
 
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


#pragma mark - RESFetchPhotoAssets delegate methods

-(void)updateCollectionView:(UICollectionView *)collectionView withAssetGroupArray:(NSMutableArray *)assetGroupArray andAssetArray:(NSMutableArray *)assetArray withGroupEnumError:(NSError *)error
{
    //NSLog(@"%@",NSStringFromSelector(_cmd));
    if (error) {
        
        NSString *msgError = [[error userInfo] valueForKey:NSLocalizedDescriptionKey];
        NSLog(@"%@",msgError);
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:msgError delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        return;
    };
    
    [self setAssetGroupArray:[assetGroupArray mutableCopy]];
    [self setAssetArray:[assetArray mutableCopy]];
    NSLog(@"delegate - assetGroupArray:%d,assetArray:%d",[self.assetGroupArray count],[self.assetArray count]);
    [self.collectionView reloadData];
    
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [self.assetGroupArray count];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSArray *sectionAssets = self.assetArray[section];
    return [sectionAssets count];
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    RESSectionHeader *sectionHeader = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kCustomSectionHeader forIndexPath:indexPath];
    [sectionHeader.headerLabel setText:self.assetGroupArray[indexPath.section]];
    return sectionHeader;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RESThumbnailCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCustomThumbnailCell forIndexPath:indexPath];
    
    ALAsset *assetForPath = self.assetArray[indexPath.section][indexPath.row];
    UIImage *assetThumb = [UIImage imageWithCGImage:[assetForPath thumbnail]];
    [cell.thumbnailImageView setImage:assetThumb];
    
    return cell;
}
@end
