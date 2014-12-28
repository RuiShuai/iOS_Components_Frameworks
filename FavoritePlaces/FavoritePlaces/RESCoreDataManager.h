//
//  RUSCoreDataDAO.h
//  FavoritePlaces
//
//  Created by taotao on 14/12/22.
//  Copyright (c) 2014年 RuiShuai Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

//CoreData文件
#define MODEL_NAME @"FavoritePlaces"
//数据库文件
#define MODEL_STORE_NAME @"FavoritePlaces.sqlite"

@interface RESCoreDataManager : NSObject

@property (readonly,strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly,strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly,strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;


+(RESCoreDataManager *)sharedManager;

- (NSURL *)applicationDocumentsDirectory;



@end
