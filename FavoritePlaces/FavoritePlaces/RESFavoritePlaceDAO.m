//
//  RUSFavoritePlaceDAO.m
//  FavoritePlaces
//
//  Created by taotao on 14/12/22.
//  Copyright (c) 2014年 RuiShuai Co., Ltd. All rights reserved.
//

#import "RESFavoritePlaceDAO.h"

@implementation RESFavoritePlaceDAO

static RESFavoritePlaceDAO *_sharedManager = nil;

+ (RESFavoritePlaceDAO *)sharedManager
{
    static dispatch_once_t once;
    dispatch_once(&once,^{
        _sharedManager = [[RESFavoritePlaceDAO alloc] init];
        [_sharedManager managedObjectContext];
        
    });
    return _sharedManager;
}

-(id)init
{
    self = [super init];
    if (self) {
        //Custom initiliaztion      
    }
    return self;
}

- (int)create:(RESFavoritePlace *)model
{
    NSManagedObjectContext *moc = [self managedObjectContext];

    RESFavoritePlaceManagedObject *placeMO = [NSEntityDescription insertNewObjectForEntityForName:@"FavoritePlace" inManagedObjectContext:moc];
    [placeMO setValue:model.displayProximity forKey:@"displayProximity"];
    [placeMO setValue:model.displayRadius forKey:@"displayRadius"];
    [placeMO setValue:model.goingNext forKey:@"goingNext"];
    [placeMO setValue:model.latitude forKey:@"latitude"];
    [placeMO setValue:model.longitude forKey:@"longitude"];
    [placeMO setValue:model.placeCity forKey:@"placeCity"];
    [placeMO setValue:model.placeName forKey:@"placeName"];
    [placeMO setValue:model.placeState forKey:@"placeState"];
    [placeMO setValue:model.placeStreetAddress forKey:@"placeStreetAddress"];
    
    /*
    placeMO.displayProximity = model.displayProximity;
    placeMO.displayRadius = model.displayRadius;
    placeMO.goingNext = model.goingNext;
    placeMO.latitude = model.latitude;
    placeMO.longitude = model.longitude;
    placeMO.placeCity = model.placeCity;
    placeMO.placeName = model.placeName;
    placeMO.placeState = model.placeState;
    placeMO.placeStreetAddress = model.placeStreetAddress;
    */
    
    
    NSError *savingError = nil;
    if ([self.managedObjectContext save:&savingError]) {
        NSLog(@"插入数据成功");
    } else {
        NSLog(@"插入数据失败");
        return -1;
    }
    
    return 0;
}


- (int)remove:(RESFavoritePlace *)model
{
    NSManagedObjectContext *moc = [self managedObjectContext];
    NSEntityDescription *entityDescription  = [NSEntityDescription entityForName:@"FavoritePlace"  inManagedObjectContext:moc];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"latitude = %@",model.latitude];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *listPlaces = [moc executeFetchRequest:request error:&error];
    
    if ([listPlaces count]>0) {
        RESFavoritePlaceManagedObject *placeMO = [listPlaces lastObject];
        [moc deleteObject:placeMO];
        
        NSError *savingError = nil;
        if ([moc save:&savingError]) {
            NSLog(@"删除数据成功");
        } else {
            NSLog(@"删除数据失败");
            return -1;
        }
    }
    
    return 0;
}



- (int)modify:(RESFavoritePlace *)model
{
    
    
    return 0;
}


- (NSMutableArray *)findAll
{
    
    return nil;
}


- (RESFavoritePlace *)findById:(RESFavoritePlace *)model
{
    
    return nil;
}

@end
