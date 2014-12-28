//
//  RUSLocationManager.h
//  FavoritePlaces
//
//  Created by taotao on 14/12/22.
//  Copyright (c) 2014年 RuiShuai Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "RESCoreDataManager.h"
#import "RESFavoritePlaceManagedObject.h"

//定义回调block的格式签名
typedef void (^RESLocationUpdateCompletionBlock)(CLLocation *location, NSError *error);

@interface RESLocationManager : NSObject<CLLocationManagerDelegate>

+ (RESLocationManager *)sharedLocationManager;

@property (strong,nonatomic) CLLocation *location;
@property (strong,nonatomic) CLLocationManager *locationManager;
@property (nonatomic) BOOL hasLocation;
@property (nonatomic,strong) NSError *locationError;
@property (strong,nonatomic) CLGeocoder *geocoder;

- (void)getLocationWithCompletionBlock:(RESLocationUpdateCompletionBlock)block;

@end
