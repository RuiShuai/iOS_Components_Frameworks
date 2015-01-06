//
//  UIImage+Scaling.m
//  ImagePlayground
//
//  Created by taotao on 14/12/31.
//  Copyright (c) 2014年 RuiShuai Co., Ltd. All rights reserved.
//

#import "UIImage+Scaling.h"

@implementation UIImage (Scaling)


-(UIImage *)scaleImageToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    
    CGFloat originX = 0.0;
    CGFloat originY = 0.0;
    CGRect destinationRect = CGRectMake(originX, originY, newSize.width, newSize.height);
    
    [self drawInRect:destinationRect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return newImage;
}

@end
