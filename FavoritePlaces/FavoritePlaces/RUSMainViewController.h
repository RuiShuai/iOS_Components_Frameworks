//
//  RUSMainViewController.h
//  FavoritePlaces
//
//  Created by taotao on 14/12/22.
//  Copyright (c) 2014年 RuiShuai Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "RUSFavoritePlaceViewController.h"//protocol


@interface RUSMainViewController : UIViewController<UIPopoverControllerDelegate,MKMapViewDelegate,RUSFavoritePlaceViewControllerDelegate>


@property (strong,nonatomic) UIPopoverController *favoritePlacePopoverController;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;

- (IBAction)mapTypeSelectionChanged:(id)sender;
- (IBAction)togglePopover:(id)sender;


@end
