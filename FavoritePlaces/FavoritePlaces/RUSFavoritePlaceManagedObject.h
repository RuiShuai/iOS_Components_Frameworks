//
//  RUSFavoritePlaceManagedObject.h
//  FavoritePlaces
//
//  Created by taotao on 14/12/23.
//  Copyright (c) 2014年 RuiShuai Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <MapKit/MapKit.h>

@interface RUSFavoritePlaceManagedObject : NSManagedObject<MKAnnotation,MKOverlay>


@property (nonatomic, retain) NSNumber * displayProximity;
@property (nonatomic, retain) NSNumber * displayRadius;
@property (nonatomic, retain) NSNumber * goingNext;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSString * placeCity;
@property (nonatomic, retain) NSString * placeName;
@property (nonatomic, retain) NSString * placeState;
@property (nonatomic, retain) NSString * placeStreetAddress;

@end
