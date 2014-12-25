//
//  RESMovie.h
//  MyMovies
//
//  Created by taotao on 14/12/25.
//  Copyright (c) 2014年 RuiShuai Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RESFriendManagedObject;

@interface RESMovie : NSObject

@property (nonatomic, retain) NSString * movieDescription;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * year;
@property (nonatomic, retain) NSNumber * timesWatched;
@property (nonatomic, retain) NSNumber * lent;
@property (nonatomic, retain) NSDate * lentOn;
@property (nonatomic, retain) RESFriendManagedObject *lentToFriend;


- (NSString *)cellTitle;
- (NSString *)yearAndTitle;

@end
