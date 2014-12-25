//
//  RESFriend.h
//  MyMovies
//
//  Created by taotao on 14/12/25.
//  Copyright (c) 2014年 RuiShuai Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RESFriend : NSObject

@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * friendName;
@property (nonatomic, retain) NSSet *lentMovies;

@end
