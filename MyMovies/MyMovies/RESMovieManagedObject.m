//
//  RESMovieManagedObject.m
//  MyMovies
//
//  Created by taotao on 14/12/25.
//  Copyright (c) 2014年 RuiShuai Co., Ltd. All rights reserved.
//

#import "RESMovieManagedObject.h"
#import "RESFriendManagedObject.h"


@implementation RESMovieManagedObject

@dynamic movieDescription;
@dynamic title;
@dynamic year;
@dynamic timesWatched;
@dynamic lent;
@dynamic lentOn;
@dynamic lentToFriend;

- (NSString *)cellTitle
{
    return [NSString stringWithFormat:@"%@ (%@)",self.title,self.year];
}

- (NSString *)yearAndTitle
{
    return [NSString stringWithFormat:@"(%@) %@",self.year,self.title];
}

@end
