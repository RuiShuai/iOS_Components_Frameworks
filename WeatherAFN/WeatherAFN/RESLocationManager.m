//
//  RESLocationManager.m
//  WeatherAFN
//
//  Created by taotao on 15/1/24.
//  Copyright (c) 2015年 RuiShuai Co., Ltd. All rights reserved.
//

#import "RESLocationManager.h"

@interface RESLocationManager()
@property (strong,nonatomic) NSMutableArray *completionBlocks;
@end

@implementation RESLocationManager



+ (RESLocationManager *)sharedLocationManager
{
    static RESLocationManager *_sharedLocationManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        _sharedLocationManager = [[RESLocationManager alloc] init];
    });
    return _sharedLocationManager;
}

- (id)init
{
    self = [super init];
    if (self) {
        //初始化CLLocationManager,completionBlocks
        [self setLocationManager:[[CLLocationManager alloc] init]];
        [self.locationManager setDelegate:self];
        
        [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        [self.locationManager setDistanceFilter:100.0f];
        
        //iOS 8
        [self.locationManager requestAlwaysAuthorization];
        [self.locationManager requestWhenInUseAuthorization];

        
        [self setCompletionBlocks:[[NSMutableArray alloc] initWithCapacity:3.0]];

    }
    return self;
}


- (void)getLocationWithCompletionBlock:(RESLocationUpdateCompletionBlock)block
{
    if (block) {
        [self.completionBlocks addObject:[block copy]];
    }
    
    if (self.hasLocation) {
        for (RESLocationUpdateCompletionBlock completionBlock in self.completionBlocks)
        {
            completionBlock(self.location,nil);
        }
        //执行完毕
        if ([self.completionBlocks count]==0) {
            //notify map view of change to location when not requested
            [[NSNotificationCenter defaultCenter] postNotificationName:@"locationUpdated" object:nil];
        }
        //移除所有回调
        [self.completionBlocks removeAllObjects];
    }
    
    if (self.locationError) {
        for (RESLocationUpdateCompletionBlock completionBlock in self.completionBlocks)
        {
            completionBlock(nil,self.locationError);
        }
        
        [self.completionBlocks removeAllObjects];
    }
    
}


#pragma mark - CLLocationManager Delegate method

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    NSLog(@"%@",NSStringFromSelector(_cmd));
    //Filter out inaccurate points
    CLLocation *lastLocation = [locations lastObject];
    
    if (lastLocation.horizontalAccuracy < 0) {
        return;
    }
    
    if ([lastLocation.timestamp timeIntervalSinceNow]>300) {
        return;
    }
    
    
    [self setLocation:lastLocation];
    [self setHasLocation:YES];
    [self setLocationError:nil];
    
    [self getLocationWithCompletionBlock:nil];
    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if ([error code] == kCLErrorDenied)
    {
        //访问被拒绝
    }
    if ([error code] == kCLErrorLocationUnknown) {
        //无法获取位置信息
    }
    
    //停止更新
    [self.locationManager stopUpdatingLocation];
    [self setLocationError:error];
    [self getLocationWithCompletionBlock:nil];
}


- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (status == kCLAuthorizationStatusDenied) {
        //Location services are disabled on the device.
        [self.locationManager stopUpdatingLocation];
        
        NSString *errorMessage = @"Location Services Permission Denied for this app. Visit Setting.app to allow";
        NSDictionary *errorInfo = @{NSLocalizedDescriptionKey : errorMessage};
        
        NSError *deniedError = [NSError errorWithDomain:@"RESLocationErrorDomain" code:1 userInfo:errorInfo];
        
        [self setLocationError:deniedError];
        [self getLocationWithCompletionBlock:nil];
        
    }
    

    
    if (status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        //Location services have just been authorized on the device,start updating now.
        [self.locationManager startUpdatingLocation];
        [self setLocationError:nil];
        
    }
    
}


@end
