//
//  RESFriendManagedObject.h
//  MyMovies
//
//  Created by taotao on 14/12/25.
//  Copyright (c) 2014年 RuiShuai Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class RESMovieManagedObject;

@interface RESFriendManagedObject : NSManagedObject

@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * friendName;
@property (nonatomic, retain) NSSet *lentMovies;
@end

@interface RESFriendManagedObject (CoreDataGeneratedAccessors)

- (void)addLentMoviesObject:(RESMovieManagedObject *)value;
- (void)removeLentMoviesObject:(RESMovieManagedObject *)value;
- (void)addLentMovies:(NSSet *)values;
- (void)removeLentMovies:(NSSet *)values;

@end
