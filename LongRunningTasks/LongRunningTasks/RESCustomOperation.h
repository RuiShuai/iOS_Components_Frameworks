//
//  RESCustomOperation.h
//  LongRunningTasks
//
//  Created by taotao on 15/1/8.
//  Copyright (c) 2015年 RuiShuai Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RESCustomOperationDelegate <NSObject>

-(void)updateTableWithData:(NSArray *)moreData;

@end

@interface RESCustomOperation : NSOperation

@property (nonatomic,weak) id<RESCustomOperationDelegate> delegate;
@property (nonatomic,strong) NSNumber *iteration;

-(id)initWithIteration:(NSNumber *)iterationNumber andDelegate:(id)myDelegate;

@end
