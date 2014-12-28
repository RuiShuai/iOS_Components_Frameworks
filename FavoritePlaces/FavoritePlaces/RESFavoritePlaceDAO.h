//
//  RUSFavoritePlaceDAO.h
//  FavoritePlaces
//
//  Created by taotao on 14/12/22.
//  Copyright (c) 2014年 RuiShuai Co., Ltd. All rights reserved.
//

#import "RESCoreDataManager.h"
#import "RESFavoritePlace.h"
#import "RESFavoritePlaceManagedObject.h"

@interface RESFavoritePlaceDAO : RESCoreDataManager

+ (RESFavoritePlaceDAO *)sharedManager;


- (int)create:(RESFavoritePlace *)model;
- (int)remove:(RESFavoritePlace *)model;
- (int)modify:(RESFavoritePlace *)model;
- (NSMutableArray *)findAll;
- (RESFavoritePlace *)findById:(RESFavoritePlace *)model;

@end
