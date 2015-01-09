//
//  ViewController.h
//  GesturePlayground
//
//  Created by taotao on 15/1/8.
//  Copyright (c) 2015年 RuiShuai Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RESGestureViewController : UIViewController<UIGestureRecognizerDelegate>

@property (strong, nonatomic) IBOutlet UIView *myGestureView;
@property (nonatomic, assign) CGFloat scaleFactor;
@property (nonatomic, assign) CGFloat rotationFactor;
@property (nonatomic, assign) CGFloat currentScaleDelta;
@property (nonatomic, assign) CGFloat currentRotationDelta;

- (void)myGestureViewTapped:(UIGestureRecognizer *)tapGesture;
- (void)myGestureViewPinched:(UIPinchGestureRecognizer *)pinchGesture;
- (void)myGestureViewRotated:(UIRotationGestureRecognizer *)rotateGesture;

@end

