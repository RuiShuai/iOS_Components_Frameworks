//
//  RUSFavoritePlaceViewController.h
//  FavoritePlaces
//
//  Created by taotao on 14/12/22.
//  Copyright (c) 2014年 RuiShuai Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreData/CoreData.h>
#import "RUSLocationManager.h"
#import "RUSFavoritePlaceDAO.h"

//委托协议
@class RUSFavoritePlaceViewController;

@protocol RUSFavoritePlaceViewControllerDelegate

- (void)favoritePlaceViewControllerDidFinish:(RUSFavoritePlaceViewController *)controller;
- (MKMapItem *)currentLocationMapItem;
- (void)displayDirectionsForRoute:(MKRoute *)route;

@end

//FavoritePlace视图控制器
@interface RUSFavoritePlaceViewController : UIViewController

//delegate委托对象
@property (weak,nonatomic) id<RUSFavoritePlaceViewControllerDelegate> delegate;
@property (nonatomic,strong) NSManagedObjectID *favoritePlaceID;

@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) IBOutlet UITextField *addressTextField;
@property (strong, nonatomic) IBOutlet UITextField *cityTextField;
@property (strong, nonatomic) IBOutlet UITextField *stateTextField;
@property (strong, nonatomic) IBOutlet UITextField *postalTextField;
@property (strong, nonatomic) IBOutlet UITextField *latitudeTextField;
@property (strong, nonatomic) IBOutlet UITextField *longitudeTextField;
@property (strong, nonatomic) IBOutlet UILabel *geofenceLabel;
@property (strong, nonatomic) IBOutlet UISwitch *displayProximitySwitch;
@property (strong, nonatomic) IBOutlet UILabel *displayRadiusLabel;
@property (strong, nonatomic) IBOutlet UISlider *displayRadiusSlider;
@property (strong, nonatomic) IBOutlet UIButton *geocodeNowButton;


- (IBAction)saveButtonTouched:(id)sender;
- (IBAction)cancelButtonTouched:(id)sender;
- (IBAction)geocodeLocationTouched:(id)sender;
- (IBAction)displayProxitySwitchChanged:(id)sender;
- (IBAction)displayProxityRadiusChanged:(id)sender;
- (IBAction)getDirectionsButtonTouched:(id)sender;
- (IBAction)getDirectionsToButtonTouched:(id)sender;




@end
