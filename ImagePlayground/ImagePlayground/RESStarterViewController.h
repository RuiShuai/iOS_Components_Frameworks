//
//  ViewController.h
//  ImagePlayground
//
//  Created by taotao on 14/12/29.
//  Copyright (c) 2014年 RuiShuai Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>


#define kRESFilterCellIdentifier @"FilterListCell"
#define kRESCategoryListCellIdentifier @"CategoryListCell"
#define kRESFilterInCategoryCellIdentifier @"FilterInCategoryCell"
#define kRESSelectFilterCategorySegue @"selectCategory"
#define kRESSelectFilterSegue @"selectFilter"
#define kRESAddFilterSegue @"addFilterPopover"

#define kRESInputImageCellIdentifier @"inputImageCell"
#define kRESInputColorCellIdentifier @"inputColorCell"
#define kRESInputNumberCellIdentifier @"inputNumberCell"
#define kRESInputVectorCellIdentifier @"inputVectorCell"
#define kRESInputTransformCellIdentifier @"inputTransformCell"


@protocol RESFilterProcessingDelegate <NSObject>

-(void)addFilter:(CIFilter *)filter;
-(void)cancelAddingFilter;
-(UIImage *)imageWithLastFilterApplied;
-(UINavigationController *)currentFilterController;
-(UIPopoverController *)currentPopoverController;

@end


@interface RESStarterViewController : UIViewController<RESFilterProcessingDelegate,UIImagePickerControllerDelegate,UIPopoverControllerDelegate,UINavigationControllerDelegate>

@property (strong, nonatomic) IBOutlet UIView *sourceImageContainer;
@property (strong, nonatomic) IBOutlet UIImageView *sourceImageView;
@property (strong, nonatomic) IBOutlet UIView *resultImageContainer;
@property (strong, nonatomic) IBOutlet UIImageView *resultImageView;
@property (strong, nonatomic) IBOutlet UIView *filterListContainer;
@property (strong, nonatomic) IBOutlet UITableView *filterList;
@property (strong, nonatomic) IBOutlet UITextView *faceInfoTextView;

@property (strong, nonatomic) IBOutlet UIButton *selectImageButton;
@property (strong, nonatomic) IBOutlet UIButton *takePhotoButton;

@property (nonatomic,strong) UIPopoverController *filterPopoverController;
@property (nonatomic,strong) UINavigationController *filterNavigationController;
@property (nonatomic,strong) UIPopoverController *imagePopoverController;


- (IBAction)clearFacesTouched:(id)sender;
- (IBAction)detectFacesTouched:(id)sender;
- (IBAction)selectImageTouched:(id)sender;
- (IBAction)takePhotoTouched:(id)sender;
- (IBAction)clearAllFiltersTouched:(id)sender;
- (IBAction)saveToCameraRollTouched:(id)sender;


@end

