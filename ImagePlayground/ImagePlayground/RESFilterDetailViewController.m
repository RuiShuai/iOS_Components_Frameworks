//
//  RESFilterDisplayViewController.m
//  ImagePlayground
//
//  Created by taotao on 14/12/31.
//  Copyright (c) 2014年 RuiShuai Co., Ltd. All rights reserved.
//

#import "RESFilterDetailViewController.h"
#import "RESInputInfoCell.h"
#import "RESInputImageTableCell.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "UIImage+Scaling.h"

@interface RESFilterDetailViewController ()
@property (nonatomic,strong) NSIndexPath *imageSelectionIndexPath;
- (IBAction)cancelButtonTouched:(id)sender;
- (IBAction)addFilterButtonTouched:(id)sender;
- (IBAction)previewButtonTouched:(id)sender;
@end

@implementation RESFilterDetailViewController

#pragma mark - view life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"Filter attributes: %@",[self.selectedFilter attributes]);
    NSLog(@"Filter input keys: %@",[self.selectedFilter inputKeys]);
    NSLog(@"Filter output keys: %@",[self.selectedFilter outputKeys]);
    
    CGColorRef darkGreyColor = [[UIColor darkGrayColor] CGColor];
    CGColorRef whiteColor = [[UIColor whiteColor] CGColor];
    [self.previewImageContainer.layer setBorderColor:whiteColor];
    [self.previewImageContainer.layer setBorderWidth:4.0f];
    
    [self.previewImageContainer.layer setShadowColor:darkGreyColor];
    [self.previewImageContainer.layer setShadowOpacity:0.8f];
    [self.previewImageContainer.layer setShadowRadius:6.0f];
    
    NSString *filterName = [[self.selectedFilter attributes] valueForKey:kCIAttributeFilterDisplayName];
    [self.filterNameLabel setText:filterName];
    
    [self setContentSizeForViewInPopover:CGSizeMake(600,600)];//540,512
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


#pragma mark - UIButton methods
- (IBAction)cancelButtonTouched:(id)sender
{
    [self.filterDelegate cancelAddingFilter];
}

- (IBAction)addFilterButtonTouched:(id)sender
{
    [self.filterDelegate addFilter:self.selectedFilter];
}

- (IBAction)previewButtonTouched:(id)sender
{
    CIContext *context = [CIContext contextWithOptions:nil];
    CIFilter *filter = self.selectedFilter;
    CIImage *resultImage = [filter valueForKey:kCIOutputImageKey];
    CGRect imageRect = CGRectMake(0, 0, 200, 200);
    
    CGImageRef resultCGImage = [context createCGImage:resultImage fromRect:imageRect];
    UIImage *resultUIImage = [UIImage imageWithCGImage:resultCGImage];
    [self.previewImageView setImage:resultUIImage];
}


#pragma mark - Table view
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.selectedFilter inputKeys] count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat rowHeight = 64.0f;
    NSString *attributeName = [[self.selectedFilter inputKeys] objectAtIndex:indexPath.row];
    NSDictionary *attributeDict = [[self.selectedFilter attributes] valueForKey:attributeName];
    NSString *attributeType = [attributeDict valueForKey:kCIAttributeType];
    
    NSString *attributeClass = [attributeDict valueForKey:kCIAttributeClass];
    
    if ([attributeType isEqualToString:kCIAttributeTypeColor]||[attributeClass isEqualToString:@"CIColor"]) {
        rowHeight = 120.0f;
    }
    
    if ([attributeType isEqualToString:kCIAttributeTypeImage]) {
        rowHeight = 80.0f;
    }
    return rowHeight;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *attributeName = [[self.selectedFilter inputKeys] objectAtIndex:indexPath.row];
    NSDictionary *attributeInfo = [[self.selectedFilter attributes] valueForKey:attributeName];
    
    NSString *cellIdentifier = [self getCellIdentifierForAttributeType:attributeInfo];

    RESInputInfoCell *cell = (RESInputInfoCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    [cell configureForInfo:attributeInfo andKey:attributeName];
    [cell setEditDelegate:self];
    
    if ([attributeName isEqualToString:@"inputImage"]) {
        UIImage *sourceImage = [self.filterDelegate imageWithLastFilterApplied];
        [[(RESInputImageTableCell *)cell inputImageView] setImage:sourceImage];
        
        CIImage *inputImage = nil;
        if ([sourceImage CIImage]) {
            inputImage = [sourceImage CIImage];
        }else{
            CGImageRef inputImageRef = [sourceImage CGImage];
            inputImage = [CIImage imageWithCGImage:inputImageRef];
        }
        
        [self.selectedFilter setValue:inputImage forKey:attributeName];
        
    }
    return cell;
}

-(NSString *)getCellIdentifierForAttributeType:(NSDictionary *)attributeInfo
{
    NSString *attributeType = @"";
    if ([attributeInfo objectForKey:kCIAttributeType]) {
        attributeType = [attributeInfo objectForKey:kCIAttributeType];
    }
    NSString *attributeClass = [attributeInfo objectForKey:kCIAttributeClass];
    
    NSString *cellIdentifier = @"";
    if ([attributeType isEqualToString:kCIAttributeTypeColor]|| [attributeClass isEqualToString:@"CIColor"]) {
        cellIdentifier = kRESInputColorCellIdentifier;
    }
    
    if ([attributeType isEqualToString:kCIAttributeTypeImage]||[attributeClass isEqualToString:@"CIImage"]) {
        cellIdentifier = kRESInputImageCellIdentifier;
    }
    
    if ([attributeType isEqualToString:kCIAttributeTypeScalar]||[attributeType isEqualToString:kCIAttributeTypeDistance]||[attributeType isEqualToString:kCIAttributeTypeAngle]||[attributeType isEqualToString:kCIAttributeTypeTime]) {
        cellIdentifier = kRESInputNumberCellIdentifier;
    }
    
    if ([attributeType isEqualToString:kCIAttributeTypePosition]||[attributeType isEqualToString:kCIAttributeTypeOffset]||[attributeType isEqualToString:kCIAttributeTypeRectangle]||[attributeClass isEqualToString:@"CIVector"]) {
        cellIdentifier = kRESInputVectorCellIdentifier;
    }
    
    if ([attributeClass isEqualToString:@"NSValue"]) {
        cellIdentifier = kRESInputTransformCellIdentifier;
    }
    return cellIdentifier;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RESInputInfoCell *cell = (RESInputInfoCell *)[tableView cellForRowAtIndexPath:indexPath];
    if ([cell isMemberOfClass:[RESInputImageTableCell class]]) {
        [self setImageSelectionIndexPath:indexPath];
        
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        [imagePicker setAllowsEditing:YES];
        [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        [imagePicker setMediaTypes:@[(NSString *)kUTTypeImage]];
        [imagePicker setDelegate:self];

        //转场
        UIPopoverController *popover = [self.filterDelegate currentPopoverController];
        [popover setContentViewController:imagePicker animated:YES];
        [popover setPopoverContentSize:[imagePicker contentSizeForViewInPopover] animated:YES];

    }
}

#pragma mark - RESFilterEditingDelegate method
-(void)updateFilterAttribute:(NSString *)attributeKey withValue:(id)value
{
    [self.selectedFilter setValue:value forKey:attributeKey];
}

#pragma mark - UIImagePickerControllerDelegate method
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{

    UIImage *selectedImage = [info objectForKey:UIImagePickerControllerEditedImage];
    CGSize scaleSize = CGSizeMake(200.0f, 200.0f);
    UIImage *scaleImage = [selectedImage scaleImageToSize:scaleSize];
    
    RESInputImageTableCell *cell = (RESInputImageTableCell *)[self.filterTableView cellForRowAtIndexPath:self.imageSelectionIndexPath];
    [cell.inputImageView setImage:scaleImage];
    
    CGImageRef scaleImageRef = [scaleImage CGImage];
    CIImage *scaleCIImage = [CIImage imageWithCGImage:scaleImageRef];
    
    [self updateFilterAttribute:cell.attributeKey withValue:scaleCIImage];
    [self setImageSelectionIndexPath:nil];
    
    //转场
    UIPopoverController *popover = [self.filterDelegate currentPopoverController];
    UINavigationController *navController = [self.filterDelegate currentFilterController];
    [popover setContentViewController:navController animated:YES];
    [popover setPopoverContentSize:[navController contentSizeForViewInPopover] animated:YES];
}



@end
