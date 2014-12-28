//
//  RUSMainViewController.h
//  FavoritePlaces
//
//  Created by taotao on 14/12/22.
//  Copyright (c) 2014年 RuiShuai Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "RESFavoritePlaceViewController.h"//protocol
#import "RESFavoritePlaceManagedObject.h"
#import "RESLocationManager.h"
#import "RESCoreDataManager.h"

@interface RESMainViewController : UIViewController<UIPopoverControllerDelegate,MKMapViewDelegate,RESFavoritePlaceViewControllerDelegate>


@property (strong,nonatomic) UIPopoverController *favoritePlacePopoverController;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;

- (IBAction)mapTypeSelectionChanged:(id)sender;
- (IBAction)togglePopover:(id)sender;


@end
