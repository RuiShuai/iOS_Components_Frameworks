//
//  RESCustomLayoutViewController.m
//  PhotoGallery
//
//  Created by taotao on 15/1/7.
//  Copyright (c) 2015年 RuiShuai Co., Ltd. All rights reserved.
//

#import "RESCustomLayoutViewController.h"
#import "RESPhotoAssetsManager.h"
#import "RESCustomSectionHeader.h"
#import "RESThumbnailCell.h"
#import "RESCustomLayout.h"
#import "RESAnimatingFlowLayout.h"

NSString *kCustomCell = @"kCustomCell";
NSString *kCustomSectionHeader = @"kCustomSectionHeader";

@interface RESCustomLayoutViewController ()
@property (nonatomic,strong) NSMutableArray *assetArray;
@property (nonatomic,strong) NSMutableArray *assetGroupArray;
@property (nonatomic,strong) RESPhotoAssetsManager *photoAssetsManager;
@property (nonatomic,strong) RESCustomLayout *customLayout;
@property (nonatomic,strong) NSIndexPath *pinchedIndexPath;
@property (nonatomic,strong) UIPinchGestureRecognizer *pinchIn;
@property (nonatomic,strong) UIPinchGestureRecognizer *pinchOut;
@end

@implementation RESCustomLayoutViewController

static NSString * const reuseIdentifier = @"Cell";

#pragma mark - view life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //collectionView
    [self.collectionView setCollectionViewLayout:[[RESCustomLayout alloc]init]];
    [self.collectionView registerNib:[UINib nibWithNibName:@"RESCustomSectionHeader" bundle:[NSBundle mainBundle]] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kCustomSectionHeader];
    
    //get assets
    self.photoAssetsManager = [[RESPhotoAssetsManager alloc]init];
    self.photoAssetsManager.delegate = self;
    self.assetGroupArray = [self.photoAssetsManager assetGroupArray];
    self.assetArray = [self.photoAssetsManager assetArray];
    
    //add gesture
    self.pinchIn = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchInReceived:)];
    self.pinchOut = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchOutReceived:)];
    //默认pinchOut(sine layout)
    [self.collectionView addGestureRecognizer:self.pinchOut];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - gesture methods
-(void)pinchInReceived:(UIGestureRecognizer *)pinchRecognizer
{
    if (pinchRecognizer.state == UIGestureRecognizerStateBegan) {
        CGPoint pinchPoint = [pinchRecognizer locationInView:self.collectionView];
        self.pinchedIndexPath = [self.collectionView indexPathForItemAtPoint:pinchPoint];
    }
    if (pinchRecognizer.state == UIGestureRecognizerStateEnded) {
        [self.collectionView removeGestureRecognizer:self.pinchIn];
        
        //sine layout
        RESCustomLayout *customLayout = [[RESCustomLayout alloc]init];
        
        __weak UICollectionView *weakCollectionView = self.collectionView;
        __weak UIPinchGestureRecognizer *weakPinchOut = self.pinchOut;
        __weak NSIndexPath *weakPinchedIndexPath = self.pinchedIndexPath;
        
        void (^finishedBlock)(BOOL) = ^(BOOL finished){
            [weakCollectionView scrollToItemAtIndexPath:weakPinchedIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:YES];
            
            [weakCollectionView addGestureRecognizer:weakPinchOut];
        };
        
        [self.collectionView setCollectionViewLayout:customLayout animated:YES completion:finishedBlock];
        
    }
    
}

-(void)pinchOutReceived:(UIGestureRecognizer *)pinchRecognizer
{
    if (pinchRecognizer.state == UIGestureRecognizerStateBegan) {
        CGPoint pinchPoint = [pinchRecognizer locationInView:self.collectionView];
        self.pinchedIndexPath = [self.collectionView indexPathForItemAtPoint:pinchPoint];
    }
    if (pinchRecognizer.state == UIGestureRecognizerStateEnded) {
        [self.collectionView removeGestureRecognizer:self.pinchOut];
        
        //animatingFlowLayout
        UICollectionViewFlowLayout *individualLayout = [[RESAnimatingFlowLayout alloc]init];
        
        __weak UICollectionView *weakCollectionView = self.collectionView;
        __weak UIPinchGestureRecognizer *weakPinchIn = self.pinchIn;
        __weak NSIndexPath *weakPinchedIndexPath = self.pinchedIndexPath;
        
        void (^finishedBlock)(BOOL) = ^(BOOL finished){
            [weakCollectionView scrollToItemAtIndexPath:weakPinchedIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:YES];
            [weakCollectionView addGestureRecognizer:weakPinchIn];
        };
        
        [self.collectionView setCollectionViewLayout:individualLayout animated:YES completion:finishedBlock];
    }
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
    RESCustomSectionHeader *sectionHeader = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kCustomSectionHeader forIndexPath:indexPath];
    [sectionHeader.headerLabel setText:self.assetGroupArray[indexPath.section]];
    return sectionHeader;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RESThumbnailCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCustomCell forIndexPath:indexPath];
    ALAsset *assetForPath = self.assetArray[indexPath.section][indexPath.row];
    UIImage *assetThumb = [UIImage imageWithCGImage:[assetForPath thumbnail]];
    [cell.thumbnailImageView setImage:assetThumb];
    return cell;
}


@end
