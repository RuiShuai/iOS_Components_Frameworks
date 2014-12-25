//
//  RESMovie.m
//  MyMovies
//
//  Created by taotao on 14/12/25.
//  Copyright (c) 2014年 RuiShuai Co., Ltd. All rights reserved.
//

#import "RESMovie.h"

@implementation RESMovie

@synthesize movieID;
@synthesize movieDescription;
@synthesize title;
@synthesize year;
@synthesize timesWatched;
@synthesize lent;
@synthesize lentOn;
@synthesize lentToFriend;

- (NSString *)cellTitle
{
    return [NSString stringWithFormat:@"%@ (%@)",self.title,self.year];
}

- (NSString *)yearAndTitle
{
    return [NSString stringWithFormat:@"(%@) %@",self.year,self.title];
}

@end
