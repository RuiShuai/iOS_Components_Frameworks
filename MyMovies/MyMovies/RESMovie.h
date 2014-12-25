//
//  RESMovie.h
//  MyMovies
//
//  Created by taotao on 14/12/25.
//  Copyright (c) 2014年 RuiShuai Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class RESFriendManagedObject;

@interface RESMovie : NSObject

@property (nonatomic, strong) NSManagedObjectID * movieID;
@property (nonatomic, strong) NSString * movieDescription;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * year;
@property (nonatomic, strong) NSNumber * timesWatched;
@property (nonatomic, strong) NSNumber * lent;
@property (nonatomic, strong) NSDate * lentOn;
@property (nonatomic, strong) RESFriendManagedObject *lentToFriend;


- (NSString *)cellTitle;
- (NSString *)yearAndTitle;

@end
