//
//  RESCustomSectionHeader.m
//  PhotoGallery
//
//  Created by taotao on 15/1/8.
//  Copyright (c) 2015年 RuiShuai Co., Ltd. All rights reserved.
//

#import "RESCustomSectionHeader.h"

@implementation RESCustomSectionHeader

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void)drawRect:(CGRect)rect
{
    //// Color Declarations
    UIColor* strokeColor = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 1];
    
    //// Frames
    CGRect frame = CGRectMake(0, 0, 320, 20);
    
    
    //// Bezier Drawing
    UIBezierPath* bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint: CGPointMake(CGRectGetMinX(frame) + 6, CGRectGetMinY(frame) + 3)];
    [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 6, CGRectGetMinY(frame) + 17) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 6, CGRectGetMinY(frame) + 14) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 6, CGRectGetMinY(frame) + 17)];
    [strokeColor setStroke];
    bezierPath.lineWidth = 2;
    [bezierPath stroke];
    
    
    //// Bezier 2 Drawing
    UIBezierPath* bezier2Path = [UIBezierPath bezierPath];
    [bezier2Path moveToPoint: CGPointMake(CGRectGetMinX(frame) + 314, CGRectGetMinY(frame) + 3)];
    [bezier2Path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 314, CGRectGetMinY(frame) + 17) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 314, CGRectGetMinY(frame) + 14) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 314, CGRectGetMinY(frame) + 17)];
    [strokeColor setStroke];
    bezier2Path.lineWidth = 2;
    [bezier2Path stroke];
    
    
    //// Bezier 3 Drawing
    UIBezierPath* bezier3Path = [UIBezierPath bezierPath];
    [bezier3Path moveToPoint: CGPointMake(CGRectGetMinX(frame) + 6, CGRectGetMinY(frame) + 10)];
    [bezier3Path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 313, CGRectGetMinY(frame) + 10) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 313, CGRectGetMinY(frame) + 10) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 313, CGRectGetMinY(frame) + 10)];
    [strokeColor setStroke];
    bezier3Path.lineWidth = 2;
    [bezier3Path stroke];
    
}

@end
