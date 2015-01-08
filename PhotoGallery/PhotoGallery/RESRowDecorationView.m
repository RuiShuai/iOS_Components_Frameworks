//
//  RESRowDecorationView.m
//  PhotoGallery
//
//  Created by taotao on 15/1/8.
//  Copyright (c) 2015年 RuiShuai Co., Ltd. All rights reserved.
//

#import "RESRowDecorationView.h"
#import <QuartzCore/QuartzCore.h>
const NSString *kRESRowDecorationViewKind = @"RESRowDecorationView";

@implementation RESRowDecorationView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
    }
    return self;
}


-(void)drawRect:(CGRect)rect
{
    //General Declarations
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //Color Declarations
    UIColor *strokeColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
    UIColor *fillColor2 = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1];
    
    //Shadow Declarations
    UIColor *shadow = strokeColor;
    CGSize shadowOffset = CGSizeMake(0.1, 3.1);
    CGFloat shadowBlurRadius = 5;
    
    //Frames
    CGRect frame = CGRectMake(0, 0, 320, 25);
    
    //Bezier Drawing
    UIBezierPath *beizerPath = [UIBezierPath bezierPath];
    [beizerPath moveToPoint:CGPointMake(CGRectGetMinX(frame)+3.5, CGRectGetMinY(frame)+16.5)];
    [beizerPath addLineToPoint:CGPointMake(CGRectGetMinX(frame)+13.8, CGRectGetMinY(frame)+8.5)];
    [beizerPath addLineToPoint:CGPointMake(CGRectGetMinX(frame)+303.73, CGRectGetMinY(frame)+8.5)];
    [beizerPath addLineToPoint:CGPointMake(CGRectGetMinX(frame)+315.5, CGRectGetMinY(frame)+16.5)];
    [beizerPath addLineToPoint:CGPointMake(CGRectGetMinX(frame)+3.5, CGRectGetMinY(frame)+16.5)];
    [beizerPath closePath];
    
    CGContextSaveGState(context);
    CGContextSetShadowWithColor(context, shadowOffset, shadowBlurRadius, shadow.CGColor);
    [fillColor2 setFill];
    [beizerPath fill];
    CGContextRestoreGState(context);
    
    [fillColor2 setStroke];
    beizerPath.lineWidth = 1;
    [beizerPath stroke];
    
}

+(NSString *)kind
{
    return (NSString *)kRESRowDecorationViewKind;
}

@end
