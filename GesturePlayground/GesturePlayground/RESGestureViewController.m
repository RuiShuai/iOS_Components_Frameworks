//
//  ViewController.m
//  GesturePlayground
//
//  Created by taotao on 15/1/8.
//  Copyright (c) 2015年 RuiShuai Co., Ltd. All rights reserved.
//

#import "RESGestureViewController.h"

@interface RESGestureViewController ()

@end

@implementation RESGestureViewController

#pragma mark - view life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*
    //tapRecognizer
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(myGestureViewTapped:)];
    [self.myGestureView addGestureRecognizer:tapRecognizer];
    */
    
    /*
    //soloPinchRecognizer
    UIPinchGestureRecognizer *soloPinchRecognizer = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(myGestureViewSoloPinched:)];
    [self.myGestureView addGestureRecognizer:soloPinchRecognizer];
    [self.view addGestureRecognizer:soloPinchRecognizer];
    */
    
    
    //pinchRecognizer
    UIPinchGestureRecognizer *pinchRecognizer = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(myGestureViewPinched:)];
    [pinchRecognizer setDelegate:self];
    [self.myGestureView addGestureRecognizer:pinchRecognizer];
    
    
    //rotationRecognizer
    UIRotationGestureRecognizer *rotateRecognizer = [[UIRotationGestureRecognizer alloc]initWithTarget:self action:@selector(myGestureViewRotated:)];
    [rotateRecognizer setDelegate:self];
    [self.myGestureView addGestureRecognizer:rotateRecognizer];
    
    
    /*
    //single,doubleTapRecognizer
    UITapGestureRecognizer *doubleTapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(myGestureViewDoubleTapped:)];
    [doubleTapRecognizer setNumberOfTapsRequired:2];
    [self.myGestureView addGestureRecognizer:doubleTapRecognizer];
    
    UITapGestureRecognizer *singleTapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(myGestureViewSingleTapped:)];
    [singleTapRecognizer requireGestureRecognizerToFail:doubleTapRecognizer];
    [self.myGestureView addGestureRecognizer:singleTapRecognizer];
    */
    
    //set defaults for scale and rotation
    [self setScaleFactor:1.0];
    [self setRotationFactor:0.0];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - UIGestureRecognizer delegate

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    
    return YES;
}


#pragma mark - GestureRecognizer handling methods

- (void)myGestureViewTapped:(UIGestureRecognizer *)tapGesture
{
    //alertView
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Tap Received" message:@"Received tap in myGestureView" delegate:nil cancelButtonTitle:@"OK Thanks" otherButtonTitles:nil];
    [alert show];
    
}

- (void)myGestureViewSingleTapped:(UIGestureRecognizer *)singleTapGesture
{
    NSLog(@"Single Tap Received");
}

- (void)myGestureViewDoubleTapped:(UIGestureRecognizer *)doubleTapGesture
{
    NSLog(@"Double Tap Received");
}

- (void)myGestureViewSoloPinched:(UIPinchGestureRecognizer *)soloPinchGesture
{
    CGFloat pinchScale = [soloPinchGesture scale];
    CGAffineTransform scaleTransform = CGAffineTransformMakeScale(pinchScale, pinchScale);
    [self.myGestureView setTransform:scaleTransform];
}

- (void)myGestureViewPinched:(UIPinchGestureRecognizer *)pinchGesture
{
    CGFloat newPinchDelta = [pinchGesture scale]-1;//scale starts at 1.0
    
    //set scaleDelta
    [self updateViewTransformWithScaleDelta:newPinchDelta andRotationDelta:0];
    if ([pinchGesture state] == UIGestureRecognizerStateEnded) {
        [self setScaleFactor:[self scaleFactor]+newPinchDelta];
        [self setCurrentScaleDelta:0.0];
    }
}

- (void)myGestureViewRotated:(UIRotationGestureRecognizer *)rotateGesture
{
    CGFloat newRotateRadians = [rotateGesture rotation];
    
    //set rotationDelta
    [self updateViewTransformWithScaleDelta:0.0 andRotationDelta:newRotateRadians];
    if ([rotateGesture state] == UIGestureRecognizerStateEnded) {
        CGFloat saveRotation = [self rotationFactor] + newRotateRadians;
        [self setRotationFactor:saveRotation];
        [self setCurrentRotationDelta:0.0];
    }
    
}

- (void)updateViewTransformWithScaleDelta:(CGFloat)scaleDelta andRotationDelta:(CGFloat)rotationDelta
{
    if (rotationDelta != 0) {
        [self setCurrentRotationDelta:rotationDelta];
    }
    if (scaleDelta != 0) {
        [self setCurrentScaleDelta:scaleDelta];
    }
    CGFloat scaleAmount = [self scaleFactor] + [self currentScaleDelta];
    CGAffineTransform scaleTransform = CGAffineTransformMakeScale(scaleAmount, scaleAmount);
    
    CGFloat rotationAmount = [self rotationFactor] + [self currentRotationDelta];
    CGAffineTransform rotationTransform = CGAffineTransformMakeRotation(rotationAmount);
    
    CGAffineTransform newTransform = CGAffineTransformConcat(scaleTransform, rotationTransform);
    [self.myGestureView setTransform:newTransform];
}



@end
