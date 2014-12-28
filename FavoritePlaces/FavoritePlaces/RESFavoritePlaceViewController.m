//
//  RUSFavoritePlaceViewController.m
//  FavoritePlaces
//
//  Created by taotao on 14/12/22.
//  Copyright (c) 2014年 RuiShuai Co., Ltd. All rights reserved.
//

#import "RESFavoritePlaceViewController.h"
#import "RESFavoritePlace.h"

@interface RESFavoritePlaceViewController ()
@property (nonatomic,strong) RESFavoritePlaceManagedObject *favoritePlaceMO;
@end

@implementation RESFavoritePlaceViewController


#pragma mark - initilization

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.favoritePlaceID) {
        
        //根据ID获取favoritePlace对象
        NSManagedObjectContext *moc = [[RESCoreDataManager sharedManager] managedObjectContext];
        [moc performBlock:^{
            self.favoritePlaceMO = (RESFavoritePlaceManagedObject *)[moc objectWithID:self.favoritePlaceID];
            
            //UI中显示对象数据
            [self.nameTextField setText:[self.favoritePlaceMO valueForKey:@"placeName"]];
            [self.addressTextField setText:[self.favoritePlaceMO valueForKey:@"placeStreetAddress"]];
            [self.cityTextField setText:[self.favoritePlaceMO valueForKey:@"placeCity"]];
            [self.stateTextField setText:[self.favoritePlaceMO valueForKey:@"placeState"]];
            [self.postalTextField setText:[self.favoritePlaceMO valueForKey:@"placePostal"]];
            [self.latitudeTextField setText:[[self.favoritePlaceMO valueForKey:@"latitude"] stringValue]];
            [self.longitudeTextField setText:[[self.favoritePlaceMO valueForKey:@"longitude"] stringValue]];
            [self.displayProximitySwitch setOn:[[self.favoritePlaceMO valueForKey:@"displayProximity"] boolValue]];
            [self.displayRadiusSlider setValue:[[self.favoritePlaceMO valueForKey:@"displayRadius"] floatValue]];
            BOOL hideDisplayRadius = [self.displayProximitySwitch isOn];
            [self.displayRadiusLabel setHidden:hideDisplayRadius];
            [self.displayRadiusSlider setHidden:hideDisplayRadius];
            [self displayProxityRadiusChanged:nil];
            
        }];
    } else {
        [self.displayProximitySwitch setOn:NO];
    }
    
    //Todo.. deprecated
    BOOL hideGeofence = ![CLLocationManager regionMonitoringAvailable];
    [self.displayProximitySwitch setHidden:hideGeofence];
    
    if (hideGeofence) {
        [self.geofenceLabel setText:@"Geofence N/A"];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


#pragma mark -
- (IBAction)saveButtonTouched:(id)sender
{

    NSManagedObjectContext *moc = [[RESCoreDataManager sharedManager] managedObjectContext];

    //保存新对象
    if (!self.favoritePlaceMO) {
        self.favoritePlaceMO = [NSEntityDescription insertNewObjectForEntityForName:@"FavoritePlace" inManagedObjectContext:moc];
    }
    
    //设置favoritePlaceMO对象属性
    [self.favoritePlaceMO setValue:[self.nameTextField text] forKeyPath:@"placeName"];
    [self.favoritePlaceMO setValue:[self.addressTextField text] forKeyPath:@"placeStreetAddress"];
    [self.favoritePlaceMO setValue:[self.cityTextField text] forKeyPath:@"placeCity"];
    [self.favoritePlaceMO setValue:[self.stateTextField text] forKeyPath:@"placeState"];
    [self.favoritePlaceMO setValue:[self.postalTextField text] forKeyPath:@"placePostal"];
    NSNumber *latNumber = [NSNumber numberWithFloat:[self.latitudeTextField.text floatValue]];
    [self.favoritePlaceMO setValue:latNumber forKeyPath:@"latitude"];
    NSNumber *longNumber = [NSNumber numberWithFloat:[self.longitudeTextField.text floatValue]];
    [self.favoritePlaceMO setValue:longNumber forKeyPath:@"longitude"];
    NSNumber *displayProximity = [NSNumber numberWithBool:[self.displayProximitySwitch isOn]];
    [self.favoritePlaceMO setValue:displayProximity forKeyPath:@"displayProximity"];
    NSNumber *displayRadius = [NSNumber numberWithFloat:[self.displayRadiusSlider value]];
    [self.favoritePlaceMO setValue:displayRadius forKeyPath:@"displayRadius"];

    //同步到coredata
    NSError *saveError = nil;
    [moc save:&saveError];
    
    if (saveError) {
        NSLog(@"Core Data save error %@, %@",saveError,[saveError userInfo]);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Core Data Error" message:saveError.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    } else {
        //调用委托协议
        [self.delegate favoritePlaceViewControllerDidFinish:self];
    }

    /*
    [moc performBlock:^{
        if (!self.favoritePlaceMO) {
            //保存新对象
            self.favoritePlaceMO = [NSEntityDescription insertNewObjectForEntityForName:@"FavoritePlace" inManagedObjectContext:moc];
        }
        //设置favoritePlaceMO对象属性
        [self.favoritePlaceMO setValue:[self.nameTextField text] forKeyPath:@"placeName"];
        [self.favoritePlaceMO setValue:[self.addressTextField text] forKeyPath:@"placeStreetAddress"];
        [self.favoritePlaceMO setValue:[self.cityTextField text] forKeyPath:@"placeCity"];
        [self.favoritePlaceMO setValue:[self.stateTextField text] forKeyPath:@"placeState"];
        [self.favoritePlaceMO setValue:[self.postalTextField text] forKeyPath:@"placePostal"];
        NSNumber *latNumber = [NSNumber numberWithFloat:[self.latitudeTextField.text floatValue]];
        [self.favoritePlaceMO setValue:latNumber forKeyPath:@"latitude"];
        NSNumber *longNumber = [NSNumber numberWithFloat:[self.longitudeTextField.text floatValue]];
        [self.favoritePlaceMO setValue:longNumber forKeyPath:@"longitude"];
        NSNumber *displayProximity = [NSNumber numberWithBool:[self.displayProximitySwitch isOn]];
        [self.favoritePlaceMO setValue:displayProximity forKeyPath:@"displayProximity"];
        NSNumber *displayRadius = [NSNumber numberWithFloat:[self.displayRadiusSlider value]];
        [self.favoritePlaceMO setValue:displayRadius forKeyPath:@"displayRadius"];
        
        //同步到coredata
        NSError *saveError = nil;
        [moc save:&saveError];
        
        if (saveError) {
            NSLog(@"Core Data save error %@, %@",saveError,[saveError userInfo]);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Core Data Error" message:saveError.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        } else {
            //调用委托协议
            [self.delegate favoritePlaceViewControllerDidFinish:self];
        }
        
    }];
    */
    
}

- (IBAction)cancelButtonTouched:(id)sender
{
    [self.delegate favoritePlaceViewControllerDidFinish:self];
    
}

- (IBAction)geocodeLocationTouched:(id)sender
{
    //准备数据
    NSString *geocodeString = @"";
    if ([self.addressTextField.text length]>0) {
        geocodeString = self.addressTextField.text;
    }
    if ([self.cityTextField.text length]>0) {
        if ([geocodeString length]>0) {
            geocodeString = [geocodeString stringByAppendingFormat:@", %@",self.cityTextField.text];
        }else {
            geocodeString = self.cityTextField.text;
        }
    }
    
    if ([self.stateTextField.text length]>0) {
        if ([geocodeString length] > 0) {
            geocodeString = [geocodeString stringByAppendingFormat:@", %@",self.stateTextField.text];
        } else {
            geocodeString = self.stateTextField.text;
        }
    }
    
    if ([self.postalTextField.text length] >0) {
        if ([geocodeString length]>0) {
            geocodeString = [geocodeString stringByAppendingFormat:@" %@",self.postalTextField.text];
        } else {
            geocodeString = self.postalTextField.text;
        }
    }
    
    [self.latitudeTextField setText:@"Geocoding..."];
    [self.longitudeTextField setText:@"Geocoding..."];
    [self.geocodeNowButton setTitle:@"Geocoding now..." forState:UIControlStateDisabled];
    [self.geocodeNowButton setEnabled:NO];
    
    //调用LocationManager的geocoder服务
    CLGeocoder *geocoder = [[RESLocationManager sharedLocationManager] geocoder];
    [geocoder geocodeAddressString:geocodeString completionHandler:^(NSArray *placemarks, NSError *error) {
        
        [self.geocodeNowButton setEnabled:YES];
        if (error) {
            //有错
            [self.latitudeTextField setText:@"Not found"];
            [self.longitudeTextField setText:@"Not found"];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Geocoding Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            
        } else {
            //将地标显示在UI中
            if ([placemarks count] > 0) {
                CLPlacemark *placemark = [placemarks lastObject];
                
                NSString *latString = [NSString stringWithFormat:@"%f",placemark.location.coordinate.latitude];
                [self.latitudeTextField setText:latString];
                
                NSString *longString = [NSString stringWithFormat:@"%f",placemark.location.coordinate.longitude];
                [self.longitudeTextField setText:longString];
                
            }
        }
        
        
    }];
    
}

- (IBAction)displayProxitySwitchChanged:(id)sender
{
    BOOL hideDisplayRadius = ![self.displayProximitySwitch isOn];
    [self.displayRadiusLabel setHidden:hideDisplayRadius];
    [self.displayRadiusSlider setHidden:hideDisplayRadius];
    [self displayProxityRadiusChanged:nil];
    
}

- (IBAction)displayProxityRadiusChanged:(id)sender
{
    
    NSString *radiusString = [NSString stringWithFormat:@"Geofence Proximity Radius (%3.0f m):",[self.displayRadiusSlider value]];
    [self.displayRadiusLabel setText:radiusString];
}
//获得方向
- (IBAction)getDirectionsButtonTouched:(id)sender
{
    //坐标
    CLLocationCoordinate2D destination = [self.favoritePlaceMO coordinate];
    //地标
    MKPlacemark *destinationPlacemark = [[MKPlacemark alloc] initWithCoordinate:destination addressDictionary:nil];
    //
    MKMapItem *destinationItem = [[MKMapItem alloc] initWithPlacemark:destinationPlacemark];
    destinationItem.name = [self.favoritePlaceMO valueForKey:@"placeName"];
    //地图
    NSDictionary *launchOptions = @{MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving,MKLaunchOptionsMapTypeKey:[NSNumber numberWithInt:MKMapTypeStandard]};
    NSArray *mapItems = @[destinationItem];
    
    BOOL success = [MKMapItem openMapsWithItems:mapItems launchOptions:launchOptions];
    
    if (!success) {
        NSLog(@"Failed to open Maps.app");
    }
    
    
}

- (IBAction)getDirectionsToButtonTouched:(id)sender
{
    CLLocationCoordinate2D destination = [self.favoritePlaceMO coordinate];
    
    MKPlacemark *destinationPlacemark = [[MKPlacemark alloc] initWithCoordinate:destination addressDictionary:nil];
    
    MKMapItem *destinationItem = [[MKMapItem alloc] initWithPlacemark:destinationPlacemark];
    //调用委托协议
    MKMapItem *currentMapItem = [self.delegate currentLocationMapItem];
    
    MKDirectionsRequest *directionsRequest = [[MKDirectionsRequest alloc]init];
    
    [directionsRequest setDestination:destinationItem];
    [directionsRequest setSource:currentMapItem];
    
    MKDirections *directions = [[MKDirections alloc] initWithRequest:directionsRequest];
    //计算航向
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
        if (error) {
            NSString *dirMessage = [NSString stringWithFormat:@"Failed to get directions: %@",error.localizedDescription];
            
            UIAlertView *dirAlert = [[UIAlertView alloc]initWithTitle:@"Directions Error" message:dirMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            
            [dirAlert show];
            
        } else {
            
            if ([response.routes count] > 0) {
                MKRoute *firstRoute = response.routes[0];
                NSLog(@"Directions received. Steps for route 1 are: ");
                NSInteger stepNumber = 1;
                for (MKRouteStep *step in firstRoute.steps) {
                    NSLog(@"Step %ld, %f meters: %@",stepNumber,step.distance,step.instructions);
                    stepNumber ++ ;
                }
                //调用委托协议
                [self.delegate displayDirectionsForRoute:firstRoute];
            } else {
                NSString *dirMessage = @"No directions available";
                UIAlertView *dirAlert = [[UIAlertView alloc]initWithTitle:@"No Directions" message:dirMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [dirAlert show];
            }
            
        }
    }];
    
}

@end
