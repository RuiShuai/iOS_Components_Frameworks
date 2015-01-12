//
//  RESCustomTextView.m
//  TextKit
//
//  Created by taotao on 15/1/12.
//  Copyright (c) 2015年 RuiShuai Co., Ltd. All rights reserved.
//

#import "RESCustomTextView.h"

@implementation RESCustomTextView

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    
    //points are falling 10 pixels below where they should be, this adjust the point to where it needs to be.
    touchPoint.y -= 10;
    
    NSInteger characterIndex = [self.layoutManager characterIndexForPoint:touchPoint inTextContainer:self.textContainer fractionOfDistanceBetweenInsertionPoints:0];
    
    if (characterIndex != 0) {
        //calculate the start and stop of the word
        NSRange start = [self.text rangeOfCharacterFromSet:[NSCharacterSet whitespaceAndNewlineCharacterSet] options:NSBackwardsSearch range:NSMakeRange(0, characterIndex)];
        NSRange stop = [self.text rangeOfCharacterFromSet:[NSCharacterSet whitespaceAndNewlineCharacterSet] options:NSCaseInsensitiveSearch range:NSMakeRange(characterIndex, self.text.length-characterIndex)];
        
        int length = (int)(stop.location - start.location);
        NSString *fullWord = [self.text substringWithRange:NSMakeRange(start.location, length)];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Selected Word" message:fullWord delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        [alert show];
        
    }
    
    [super touchesBegan:touches withEvent:event];
    
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
