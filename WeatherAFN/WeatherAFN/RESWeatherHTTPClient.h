//
//  RESWeatherHTTPClient.h
//  WeatherAFN
//
//  Created by taotao on 15/1/24.
//  Copyright (c) 2015年 RuiShuai Co., Ltd. All rights reserved.
//

#import "AFHTTPSessionManager.h"
#import <CoreLocation/CoreLocation.h>

@protocol RESWeatherHTTPClientDelegate;

@interface RESWeatherHTTPClient : AFHTTPSessionManager

@property (weak,nonatomic) id<RESWeatherHTTPClientDelegate> delegate;

+(RESWeatherHTTPClient *)sharedWeatherHTTPClient;
-(instancetype)initWithBaseURL:(NSURL *)url;
-(void)updateWeatherAtLocation:(CLLocation *)location forNumberOfDays:(NSUInteger)number;

@end

//protocol
@protocol RESWeatherHTTPClientDelegate <NSObject>

@optional
-(void)weatherHTTPClient:(RESWeatherHTTPClient *)client didUpdateWithWeather:(id)weather;
-(void)weatherHTTPClient:(RESWeatherHTTPClient *)client didFailWithError:(NSError *)error;

@end