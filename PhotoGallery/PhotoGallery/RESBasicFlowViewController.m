//
//  RESBasicFlowViewController.m
//  PhotoGallery
//
//  Created by taotao on 15/1/7.
//  Copyright (c) 2015年 RuiShuai Co., Ltd. All rights reserved.
//

#import "RESBasicFlowViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "RESThumbnailCell.h"
#import "RESSectionHeader.h"
#import "RESSectionFooter.h"
#import "RESPhotoAssetsManager.h"

//storyboard identifier
static NSString * const kThumbnailCell = @"kThumbnailCell";
static NSString * const kSectionHeader = @"kSectionHeader";
static NSString * const kSectionFooter = @"kSectionFooter";

@interface RESBasicFlowViewController ()

@property (nonatomic,strong) UICollectionViewFlowLayout *pageLayout;
@property (nonatomic,strong) RESPhotoAssetsManager *photoAssetsManager;
@end

@implementation RESBasicFlowViewController


#pragma mark - view life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.collectionView setAllowsMultipleSelection:YES];
    
    self.assetGroupArray = [[NSArray alloc]init];
    self.assetArray = [[NSArray alloc]init];
    
    self.photoAssetsManager = [[RESPhotoAssetsManager alloc]init];
    //self.photoAssetsManager = [RESPhotoAssetsManager sharedManager];
    [self.photoAssetsManager setDelegate:self];
    //[self.collectionView reloadData];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"viewWillAppear - assetGroupArray:%d,assetArray:%d",[self.assetGroupArray count],[self.assetArray count]);
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
    //return [[self.assetGroupArray[section] valueForKey:@"numberOfAssets"] integerValue];
    NSArray *sectionAssets = self.assetArray[section];
    return [sectionAssets count];
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // Configure the cell
    RESThumbnailCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kThumbnailCell forIndexPath:indexPath];

    ALAsset *assetForPath = self.assetArray[indexPath.section][indexPath.row];
    
    UIImage *assetThumbnail = [UIImage imageWithCGImage:[assetForPath thumbnail]];
    
    [cell.thumbnailImageView setImage:assetThumbnail];
    
    return cell;
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *supplementaryView = nil;
    
    //sectionHeader
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        RESSectionHeader *sectionHeader = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kSectionHeader forIndexPath:indexPath];
        
        [sectionHeader.headerLabel setText:self.assetGroupArray[indexPath.section]];
        
        supplementaryView = sectionHeader;
    }
    
    //sectionFooter
    if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        RESSectionFooter *sectionFooter = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kSectionFooter forIndexPath:indexPath];
        
        NSString *footerString = [NSString stringWithFormat:@"...end of %@",self.assetGroupArray[indexPath.section]];
        
        [sectionFooter.footerLabel setText:footerString];
        
        supplementaryView = sectionFooter;
        
    }
    
    return supplementaryView;
}

#pragma mark <UICollectionViewDelegate>

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Item selected at indexPath: %@",indexPath);
}

-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Item deselected at indexPath: %@",indexPath);
}


- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}



- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}



- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}


- (IBAction)actionTouched:(id)sender
{
    NSString *message = nil;
    
    if ([self.collectionView.indexPathsForSelectedItems count]==0) {
        message = @"There are no selected items.";
    }else if([self.collectionView.indexPathsForSelectedItems count]==1){
        message = @"There is 1 selected item.";
    }else if ([self.collectionView.indexPathsForSelectedItems count]>1){
        message = [NSString stringWithFormat:@"There are %d selected items.",[self.collectionView.indexPathsForSelectedItems count]];
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Selected Items" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
    
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}


@end
