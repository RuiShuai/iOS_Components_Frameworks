//
//  RUSFavoritePlaceDAO.h
//  FavoritePlaces
//
//  Created by taotao on 14/12/22.
//  Copyright (c) 2014年 RuiShuai Co., Ltd. All rights reserved.
//

#import "RUSCoreDataDAO.h"
#import "RUSFavoritePlace.h"
#import "RUSFavoritePlaceManagedObject.h"

@interface RUSFavoritePlaceDAO : RUSCoreDataDAO

+ (RUSFavoritePlaceDAO *)sharedManager;

- (int)create:(RUSFavoritePlace *)model;
- (int)remove:(RUSFavoritePlace *)model;
- (int)modify:(RUSFavoritePlace *)model;
- (NSMutableArray *)findAll;
- (RUSFavoritePlace *)findById:(RUSFavoritePlace *)model;

@end
