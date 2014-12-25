//
//  RUSFavoritePlace.h
//  FavoritePlaces
//
//  Created by taotao on 14/12/22.
//  Copyright (c) 2014年 RuiShuai Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <MapKit/MapKit.h>
@interface RUSFavoritePlace : NSObject<MKAnnotation,MKOverlay>

@property (nonatomic,strong) NSManagedObjectID *objectID;
@property (nonatomic, strong) NSNumber * displayProximity;
@property (nonatomic, strong) NSNumber * displayRadius;
@property (nonatomic, strong) NSNumber * goingNext;
@property (nonatomic, strong) NSNumber * latitude;
@property (nonatomic, strong) NSNumber * longitude;
@property (nonatomic, strong) NSString * placeCity;
@property (nonatomic, strong) NSString * placeName;
@property (nonatomic, strong) NSString * placeState;
@property (nonatomic, strong) NSString * placeStreetAddress;


 
@end
