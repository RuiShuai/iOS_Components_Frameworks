//
//  RESCustomOperation.m
//  LongRunningTasks
//
//  Created by taotao on 15/1/8.
//  Copyright (c) 2015年 RuiShuai Co., Ltd. All rights reserved.
//

#import "RESCustomOperation.h"

@implementation RESCustomOperation

-(id)initWithIteration:(NSNumber *)iterationNumber andDelegate:(id)myDelegate
{
    self = [super init];
    if (self) {
        self.iteration = iterationNumber;
        self.delegate = myDelegate;
    }
    return self;
}


-(void)main
{
    NSMutableArray *newArray = [[NSMutableArray alloc]initWithCapacity:10];
    
    for (int i=1; i<=10; i++) {
        if ([self isCancelled]) {
            break;
        }
        [newArray addObject:[NSString stringWithFormat:@"Item %@-%d",self.iteration,i]];
        [NSThread sleepForTimeInterval:0.1];
        NSLog(@"OpQ Custom Added %@-%d",self.iteration,i);
    }
    [self.delegate updateTableWithData:newArray];
}

@end
