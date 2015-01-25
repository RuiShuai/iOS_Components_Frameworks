//
//  RUSLocationManager.m
//  FavoritePlaces
//
//  Created by taotao on 14/12/22.
//  Copyright (c) 2014年 RuiShuai Co., Ltd. All rights reserved.
//

#import "RESLocationManager.h"

@interface RESLocationManager()
@property (strong,nonatomic) NSMutableArray *completionBlocks;
@end

@implementation RESLocationManager

static RESLocationManager *_sharedLocationManager;

+ (RESLocationManager *)sharedLocationManager
{
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
        [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        [self.locationManager setDistanceFilter:100.0f];
        [self.locationManager setDelegate:self];
        
        //iOS8
        [self.locationManager requestAlwaysAuthorization];
        [self.locationManager requestWhenInUseAuthorization];
        
        [self setCompletionBlocks:[[NSMutableArray alloc] initWithCapacity:3.0]];
        [self setGeocoder:[[CLGeocoder alloc] init]];
    }
    return self;
}

#pragma mark - customize completionBlock
- (void)getLocationWithCompletionBlock:(RESLocationUpdateCompletionBlock)block
{
    if (block) {
        [self.completionBlocks addObject:[block copy]];
    }
    
    if (self.hasLocation) {
        for (RESLocationUpdateCompletionBlock completionBlock in self.completionBlocks) {
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
        for (RESLocationUpdateCompletionBlock completionBlock in self.completionBlocks) {
            completionBlock(nil,self.locationError);
        }
        [self.completionBlocks removeAllObjects];
    }
    
}

#pragma mark - CLLocationManager Delegate method
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    //Filter out inaccurate points
    CLLocation *lastLocation = [locations lastObject];
    if (lastLocation.horizontalAccuracy < 0) {
        return;
    }
    [self setLocation:lastLocation];
    [self setHasLocation:YES];
    [self setLocationError:nil];
    
    CLLocationCoordinate2D coord = lastLocation.coordinate;
    NSLog(@"Location lat/long: %f,%f",coord.latitude,coord.longitude);
    
    CLLocationAccuracy horizontalAccuracy = lastLocation.horizontalAccuracy;
    NSLog(@"Horizontal accuracy: %f meters",horizontalAccuracy);
    
    CLLocationDistance altitude = lastLocation.altitude;
    NSLog(@"Location altitude: %f meters",altitude);
    
    CLLocationAccuracy verticalAccuracy = lastLocation.verticalAccuracy;
    NSLog(@"Vertical accuracy: %f meters",verticalAccuracy);
    
    NSDate *timestamp = lastLocation.timestamp;
    NSLog(@"Timestamp: %@",timestamp);
    
    CLLocationSpeed speed = lastLocation.speed;
    NSLog(@"Speed: %f meters per second",speed);
    
    CLLocationDirection direction = lastLocation.course;
    NSLog(@"Course: %f degrees from true north",direction);
    
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
        
        NSError *deniedError = [NSError errorWithDomain:@"RUSLocationErrorDomain" code:1 userInfo:errorInfo];
        
        [self setLocationError:deniedError];
        [self getLocationWithCompletionBlock:nil];
        
    }
    
    if (status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        //Location services have just been authorized on the device,start updating now.
        [self.locationManager startUpdatingLocation];
        [self setLocationError:nil];
        
    }
    
}


#pragma mark - Region Monitoring delegate methods

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    NSString *placeIdentifier = [region identifier];
    NSURL *placeIDURL = [NSURL URLWithString:placeIdentifier];
    
    NSManagedObjectContext *moc = [[RESCoreDataManager sharedManager] managedObjectContext];
    NSPersistentStoreCoordinator *psc = [[RESCoreDataManager sharedManager] persistentStoreCoordinator];
    
    NSManagedObjectID *placeObjectID = [psc managedObjectIDForURIRepresentation:placeIDURL];
    
    [moc performBlock:^{
        RESFavoritePlaceManagedObject *placeMO = (RESFavoritePlaceManagedObject *)[moc objectWithID:placeObjectID];
        
        NSNumber *distance = [placeMO valueForKey:@"displayRadius"];
        NSString *placeName = [placeMO valueForKey:@"placeName"];
        
        NSString *baseMessage = @"Favorite Place %@ nearby - within %@ meters.";
        
        NSString *proximityMessage = [NSString stringWithFormat:baseMessage,placeName,distance];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Favorite Nearby!" message:proximityMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }];
    
}


- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    NSString *placeIdentifier = [region identifier];
    NSURL *placeIDURL = [NSURL URLWithString:placeIdentifier];
    
    
    NSManagedObjectContext *moc = [[RESCoreDataManager sharedManager] managedObjectContext];
    NSPersistentStoreCoordinator *psc = [[RESCoreDataManager sharedManager] persistentStoreCoordinator];
    
    NSManagedObjectID *placeObjectID = [psc managedObjectIDForURIRepresentation:placeIDURL];
    
    [moc performBlock:^{
        RESFavoritePlaceManagedObject *placeMO = (RESFavoritePlaceManagedObject *)[moc objectWithID:placeObjectID];
        NSNumber *distance = [placeMO valueForKey:@"displayRadius"];
        NSString *placeName = [placeMO valueForKey:@"placeName"];
        
        NSString *baseMessage = @"Favorite Place %@ Geofence exited.";
        
        NSString *proximityMessage = [NSString stringWithFormat:baseMessage,placeName,distance];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Geofence exited" message:proximityMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
    }];
    
    
    
}


-(void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error
{
    NSLog(@"%@",NSStringFromSelector(_cmd));
}


@end
