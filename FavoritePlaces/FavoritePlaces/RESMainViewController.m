//
//  RUSMainViewController.m
//  FavoritePlaces
//
//  Created by taotao on 14/12/22.
//  Copyright (c) 2014年 RuiShuai Co., Ltd. All rights reserved.
//

#import "RESMainViewController.h"

@interface RESMainViewController ()

- (void)updateMapAnnotations;
- (void)zoomMapToFitAnnotations;
- (void)locationUpdated:(NSNotification *)notification;
- (void)updateFavoritePlace:(RESFavoritePlaceManagedObject *)placeMO withPlaceMark:(CLPlacemark *)placemark;
- (void)reverseGeocodeDraggedAnnotation:(RESFavoritePlaceManagedObject *)placeMO forAnnotationView:(MKAnnotationView *)annotationView;

@end

@implementation RESMainViewController


#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    //更新地标
    [self updateMapAnnotations];
}

- (void)viewWillAppear:(BOOL)animated
{
    RESLocationManager *appLocationManager = [RESLocationManager sharedLocationManager];
    
    [appLocationManager getLocationWithCompletionBlock:^(CLLocation *location, NSError *error) {
        if (error) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Location Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        
        //缩放地图以适应地标
        [self zoomMapToFitAnnotations];
        //注册locationUpdated通知事件观察
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationUpdated:) name:@"locationUpdated" object:nil];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


#pragma mark - Map Methods
- (void)updateMapAnnotations
{
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView removeOverlays:self.mapView.overlays];
    
    CLLocationManager *locManager = [[RESLocationManager sharedLocationManager] locationManager];
    
    NSSet *monitoredRegions = [locManager monitoredRegions];
    for (CLRegion *region in monitoredRegions) {
        [locManager stopMonitoringForRegion:region];
    }
    //获取数据
    NSFetchRequest *placesRequest = [[NSFetchRequest alloc]initWithEntityName:@"FavoritePlace"];
    NSManagedObjectContext *moc = [[RESCoreDataManager sharedManager] managedObjectContext];
    NSError *error = nil;
    
    NSArray *placesMO = [moc executeFetchRequest:placesRequest error:&error];
    NSLog(@"placeMO: %li",[placesMO count]);
    if (error) {
        NSLog(@"Core Data fetch error %@, %@",error,[error userInfo]);
    }
    [self.mapView addAnnotations:placesMO];
    
    for (RESFavoritePlaceManagedObject *favPlaceMO in placesMO) {
        BOOL displayOverlay = [[favPlaceMO valueForKeyPath:@"displayProximity"] boolValue];
        if (displayOverlay) {
            [self.mapView addOverlay:favPlaceMO];
            
            NSString *placeObjectID = [[[favPlaceMO objectID] URIRepresentation] absoluteString];
            
            CLLocationDistance monitorRadius = [[favPlaceMO valueForKeyPath:@"displayRadius"] floatValue];
            
            CLRegion *region = [[CLRegion alloc] initCircularRegionWithCenter:[favPlaceMO coordinate] radius:monitorRadius identifier:placeObjectID];
            [locManager startMonitoringForRegion:region];
        }
    }
    
}


- (void)zoomMapToFitAnnotations
{
    CLLocationCoordinate2D maxCoordinate = CLLocationCoordinate2DMake(-90.0, -180.0);
    
    CLLocationCoordinate2D minCoordinate = CLLocationCoordinate2DMake(90.0, 180.0);
    
    NSMutableArray *currentPlaces = [[NSMutableArray alloc] initWithArray:[self.mapView annotations]];
    
    [currentPlaces removeObject:self.mapView.userLocation];
    
    maxCoordinate.latitude = [[currentPlaces valueForKeyPath:@"@max.latitude"] doubleValue];
    minCoordinate.latitude = [[currentPlaces valueForKeyPath:@"@min.latitude"] doubleValue];
    
    maxCoordinate.longitude = [[currentPlaces valueForKeyPath:@"@max.longitude"] doubleValue];
    minCoordinate.longitude = [[currentPlaces valueForKeyPath:@"@min.longitude"] doubleValue];
    
    CLLocationCoordinate2D centerCoordinate;
    centerCoordinate.longitude = (minCoordinate.longitude + maxCoordinate.longitude) /2.0;
    centerCoordinate.latitude = (minCoordinate.latitude + maxCoordinate.latitude) /2.0;
    
    MKCoordinateSpan span;
    span.longitudeDelta = (maxCoordinate.longitude - minCoordinate.longitude) * 1.2;
    span.latitudeDelta = (maxCoordinate.latitude - minCoordinate.latitude) * 1.2;
    
    MKCoordinateRegion newRegion = MKCoordinateRegionMake(centerCoordinate, span);
    
    [self.mapView setRegion:newRegion animated:YES];
    
}


- (void)locationUpdated:(NSNotification *)notification
{
    
}


- (void)updateFavoritePlace:(RESFavoritePlaceManagedObject *)placeMO withPlaceMark:(CLPlacemark *)placemark
{
    //存储新坐标
    NSManagedObjectContext *moc = [RESCoreDataManager sharedManager].managedObjectContext;
    [moc performBlock:^{
        NSString *newName = [NSString stringWithFormat:@"Next: %@",placemark.name];
        [placeMO setValue:newName forKey:@"placeName"];
        
        NSString * newStreetAddress = [NSString stringWithFormat:@"%@ %@",placemark.subThoroughfare,placemark.thoroughfare];
        
        [placeMO setValue:newStreetAddress forKey:@"placeStreetAddress"];
        [placeMO setValue:placemark.subAdministrativeArea forKey:@"placeCity"];
        [placeMO setValue:placemark.postalCode forKey:@"placePostal"];
        [placeMO setValue:placemark.administrativeArea forKey:@"placeState"];
        
        NSError *saveError = nil;
        [moc save:&saveError];
        if (saveError) {
            NSLog(@"Save Error: %@",saveError.localizedDescription);
        }
        
    }];
    
}


- (void)reverseGeocodeDraggedAnnotation:(RESFavoritePlaceManagedObject *)placeMO forAnnotationView:(MKAnnotationView *)annotationView
{
    CLGeocoder *geoCoder = [[RESLocationManager sharedLocationManager] geocoder];
    CLLocationCoordinate2D draggedCoord = [placeMO coordinate];
    CLLocation *draggedLocation = [[CLLocation alloc] initWithLatitude:draggedCoord.latitude longitude:draggedCoord.longitude];
    
    [geoCoder reverseGeocodeLocation:draggedLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        UIImage *arrowImage = [UIImage imageNamed:@"annotation_view_arrow"];
        UIImageView *leftView = [[UIImageView alloc]initWithImage:arrowImage];
        
        [annotationView setLeftCalloutAccessoryView:leftView];
        
        if (error) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Geocoding Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        } else
        {
            if ([placemarks count] >0) {
                CLPlacemark *placemark = [placemarks lastObject];
                [self updateFavoritePlace:placeMO withPlaceMark:placemark];
            }
        }
        
    }];
}



#pragma mark - Favorite Place View Controller
- (void)favoritePlaceViewControllerDidFinish:(RESFavoritePlaceViewController *)controller
{
    //关闭悬浮窗体
    if (self.favoritePlacePopoverController) {
        [self.favoritePlacePopoverController dismissPopoverAnimated:YES];
        self.favoritePlacePopoverController = nil;
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
    //更新地标,地图
    [self updateMapAnnotations];
    [self zoomMapToFitAnnotations];

}

- (MKMapItem *)currentLocationMapItem
{
    CLLocation *currentLocation = self.mapView.userLocation.location;
    CLLocationCoordinate2D currentCoordinate = currentLocation.coordinate;
    MKPlacemark *currentPlacemark = [[MKPlacemark alloc] initWithCoordinate:currentCoordinate addressDictionary:nil];
    MKMapItem *currentItem = [[MKMapItem alloc] initWithPlacemark:currentPlacemark];
    return currentItem;
}

- (void)displayDirectionsForRoute:(MKRoute *)route
{
    [self.mapView addOverlay:route.polyline];
    if (self.favoritePlacePopoverController) {
        [self.favoritePlacePopoverController dismissPopoverAnimated:YES];
        
        self.favoritePlacePopoverController = nil;
    } else
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}



#pragma mark - MapViewDelegate methods

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if (annotation == mapView.userLocation) {
        return nil;
    }
    
    MKAnnotationView *view = nil;
    
    RESFavoritePlaceManagedObject *placeMO = (RESFavoritePlaceManagedObject *)annotation;
    
    if ([[placeMO valueForKeyPath:@"goingNext"] boolValue])
    {
        //初始化view
        view = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"arrow"];
        if (view == nil) {
            view = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"arrow"];
        }
        [view setCanShowCallout:YES];
        [view setDraggable:YES];
        [view setImage:[UIImage imageNamed:@"next_arrow"]];
        
        UIImageView *leftView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"annotation_view_arrow"]];
        [view setLeftCalloutAccessoryView:leftView];
        [view setRightCalloutAccessoryView:nil];
    } else
    {
        //初始化pinAnnotationView
        MKPinAnnotationView *pinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"pin"];
        if (pinView == nil) {
            pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"pin"];
        }
        [pinView setPinColor:MKPinAnnotationColorRed];
        [pinView setCanShowCallout:YES];
        [pinView setDraggable:NO];
        
        UIImageView *leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"annotation_view_star"]];
        
        [pinView setLeftCalloutAccessoryView:leftView];
        
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        [pinView setRightCalloutAccessoryView:rightButton];
        view = pinView;
        
    }
    
    return view;
}


-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    MKCoordinateRegion newRegion = [mapView region];
    CLLocationCoordinate2D center = newRegion.center;
    MKCoordinateSpan span = newRegion.span;
    
    NSLog(@"New map region center : <%f/%f>, span: <%f/%f>",center.latitude,center.longitude,span.latitudeDelta,span.longitudeDelta);
    
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    MKOverlayRenderer *returnView = nil;
    if ([overlay isKindOfClass:[RESFavoritePlaceManagedObject class]]) {
        RESFavoritePlaceManagedObject *placeMO = (RESFavoritePlaceManagedObject *)overlay;
        CLLocationDistance radius = [[placeMO valueForKeyPath:@"displayRadius"] floatValue];
        MKCircle *circle = [MKCircle circleWithCenterCoordinate:[overlay coordinate] radius:radius];
        
        MKCircleRenderer *circleView = [[MKCircleRenderer alloc] initWithCircle:circle];
        circleView.fillColor = [[UIColor redColor] colorWithAlphaComponent:0.2];
        circleView.strokeColor = [[UIColor redColor] colorWithAlphaComponent:0.7];
        circleView.lineWidth = 3;
        returnView = circleView;
    }
    
    if ([overlay isKindOfClass:[MKPolyline class]]) {
        MKPolyline *line = (MKPolyline *)overlay;
        MKPolylineRenderer *polylineRenderer = [[MKPolylineRenderer alloc]initWithPolyline:line];
        
        [polylineRenderer setLineWidth:3.0];
        [polylineRenderer setFillColor:[UIColor blueColor]];
        [polylineRenderer setStrokeColor:[UIColor blueColor]];
        returnView = polylineRenderer;
    }
    return returnView;
}


- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    [self performSegueWithIdentifier:@"showFavoritePlaceDetail" sender:view];
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view didChangeDragState:(MKAnnotationViewDragState)newState fromOldState:(MKAnnotationViewDragState)oldState
{
    //停止拖动
    if (newState == MKAnnotationViewDragStateEnding) {
        RESFavoritePlaceManagedObject *draggedPlaceMO = (RESFavoritePlaceManagedObject *)[view annotation];
        UIActivityIndicatorViewStyle whiteStyle = UIActivityIndicatorViewStyleWhite;
        
        UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:whiteStyle];
        
        [activityView startAnimating];
        [view setLeftCalloutAccessoryView:activityView];
        
        [self reverseGeocodeDraggedAnnotation:draggedPlaceMO forAnnotationView:view];
    }
}


#pragma mark - Navigation Bar methods

- (IBAction)togglePopover:(id)sender
{
    //关闭之前的悬浮窗体
    if (self.favoritePlacePopoverController) {
        [self.favoritePlacePopoverController dismissPopoverAnimated:YES];
        self.favoritePlacePopoverController = nil;
    } else {
        //主动触发segue转场
        [self performSegueWithIdentifier:@"addFavoritePlace" sender:sender];
    }
    
}



- (IBAction)mapTypeSelectionChanged:(id)sender
{
    UISegmentedControl *mapSelection = (UISegmentedControl *)sender;
    switch (mapSelection.selectedSegmentIndex) {
        case 0:
            [self.mapView setMapType:MKMapTypeStandard];
            break;
        case 1:
            [self.mapView setMapType:MKMapTypeSatellite];
            break;
        case 2:
            [self.mapView setMapType:MKMapTypeHybrid];
            break;
        default:
            return;
    }
    
}


-(void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    self.favoritePlacePopoverController = nil;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"addFavoritePlace"]) {
        //RUSMainViewController * __weak weakSelf = self;
        [[segue destinationViewController] setDelegate:self];
        
        
       
        
        UIPopoverController *popoverController = [(UIStoryboardPopoverSegue *)segue popoverController];
        self.favoritePlacePopoverController = popoverController;
        popoverController.delegate = self;
    }
    
    if ([[segue identifier] isEqualToString:@"showFavoritePlaceDetail"]) {
        //发送地标ID
        MKAnnotationView *view = (MKAnnotationView *)sender;
        RESFavoritePlaceManagedObject *placeMO = (RESFavoritePlaceManagedObject *)[view annotation];
        
        RESFavoritePlaceViewController *fpvc = (RESFavoritePlaceViewController *)[segue destinationViewController];
        [fpvc setDelegate:self];
        [fpvc setFavoritePlaceID:[placeMO objectID]];
        
    }
    
}




@end
