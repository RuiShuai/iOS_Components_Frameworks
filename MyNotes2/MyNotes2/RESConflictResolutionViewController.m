//
//  RESConflictResolutionViewController.m
//  MyNotes2
//
//  Created by taotao on 15/1/9.
//  Copyright (c) 2015年 RuiShuai Co., Ltd. All rights reserved.
//

#import "RESConflictResolutionViewController.h"

@interface RESConflictResolutionViewController ()

@end

@implementation RESConflictResolutionViewController

#pragma mark - view life cycle

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupStartViewControllerWithPageViewController];

}

- (void)setupStartViewControllerWithPageViewController
{
    //init UIPageViewController
    self.pageViewController = [[UIPageViewController alloc]initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    
    self.pageViewController.delegate = self;
    
    
    //init ConflictVersion view controller
    
    RESConflictVersionViewController *startingVC = [self viewControllerAtIndex:0 storyboard:self.storyboard];
    
    NSArray *viewControllers = @[startingVC];
    
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:NULL];
    
    self.pageViewController.dataSource = self;
    
    // add child view controller - nested
    
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    
    //Set the page view controller's bounds using an inset rect so that self's view is visible around the edges of the pages
    CGRect pageViewRect = self.view.bounds;
    self.pageViewController.view.frame = pageViewRect;
    
    [self.pageViewController didMoveToParentViewController:self];
    
    //Add the page view controller's gesture recoginzers to the book view controller's view so that the gestures are started more easily.
    
    self.view.gestureRecognizers = self.pageViewController.gestureRecognizers;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


#pragma mark - ConflictVersion ViewController
- (RESConflictVersionViewController *)viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard
{
    //Return the data view controller for the given index.
    if ([self.versionList count]==0 || (index>=[self.versionList count])) {
        return nil;
    }
    
    //Create a new view controller and pass suitable data.
    NSString *viewIdentifier = @"RESConflictVersionViewController";
    
    RESConflictVersionViewController *versionVC = [storyboard instantiateViewControllerWithIdentifier:viewIdentifier];
    
    [versionVC setFileVersion:self.versionList[index]];
    [versionVC setDelegate:self];
    
    return versionVC;
}


- (NSUInteger) indexOfViewController:(RESConflictVersionViewController *)viewController
{
    return [self.versionList indexOfObject:viewController.fileVersion];
}



#pragma mark - UIPageViewController data source
//上一页
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:(RESConflictVersionViewController *)viewController];
    if ((index==0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index storyboard:viewController.storyboard];
}

//下一页
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:(RESConflictVersionViewController *)viewController];
    if (index==NSNotFound) {
        return nil;
    }
    index++;
    if (index == [self.versionList count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index storyboard:viewController.storyboard];
}

#pragma mark - UIPageViewController delegate
//书脊位置
- (UIPageViewControllerSpineLocation)pageViewController:(UIPageViewController *)pageViewController spineLocationForInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    // Set the spine position to "min" and the page view controller's view controllers array to contain just one view controller. Setting the spine position to 'UIPageViewControllerSpineLocationMid' in landscape orientation sets the doubleSided property to YES, so set it to NO here.
    UIViewController *currentVC = self.pageViewController.viewControllers[0];
    
    NSArray *viewControllers = @[currentVC];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:NULL];
    //单页
    self.pageViewController.doubleSided = NO;
    return UIPageViewControllerSpineLocationMin;
}



#pragma mark - RESConflictResolutionDelegate
-(void)conflictVersionSelected:(NSFileVersion *)selectedVersion
{
    BOOL isCurrentVersion = (selectedVersion == self.currentVersion);
    
    [self.delegate noteConflictResolved:selectedVersion forCurrentVersion:isCurrentVersion];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
