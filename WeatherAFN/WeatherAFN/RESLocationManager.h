//
//  RESLocationManager.h
//  WeatherAFN
//
//  Created by taotao on 15/1/24.
//  Copyright (c) 2015年 RuiShuai Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

typedef void (^RESLocationUpdateCompletionBlock)(CLLocation *location, NSError *error);

@interface RESLocationManager : NSObject<CLLocationManagerDelegate>

+ (RESLocationManager *)sharedLocationManager;

@property (strong,nonatomic) CLLocation *location;
@property (strong,nonatomic) CLLocationManager *locationManager;
@property (nonatomic) BOOL hasLocation;
@property (nonatomic,strong) NSError *locationError;

- (void)getLocationWithCompletionBlock:(RESLocationUpdateCompletionBlock)block;

@end
