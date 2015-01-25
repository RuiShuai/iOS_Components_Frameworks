//
//  RESWeatherHTTPClient.m
//  WeatherAFN
//
//  Created by taotao on 15/1/24.
//  Copyright (c) 2015年 RuiShuai Co., Ltd. All rights reserved.
//

#import "RESWeatherHTTPClient.h"

static NSString *const WorldWeatherOnlineAPIKey = @"89f2f1f758fa0057d9ac8583abb1f";
static NSString *const WorldWeatherOnlineURLString = @"http://api.worldweatheronline.com/free/v2/";

@implementation RESWeatherHTTPClient

#pragma mark - overhead
+(RESWeatherHTTPClient *)sharedWeatherHTTPClient
{
    static RESWeatherHTTPClient *_sharedWeatherHTTPClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        _sharedWeatherHTTPClient = [[self alloc]initWithBaseURL:[NSURL URLWithString:WorldWeatherOnlineURLString]];
    });
    return _sharedWeatherHTTPClient;
}

-(instancetype)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    if (self) {
        self.responseSerializer = [AFJSONResponseSerializer serializer];
        self.requestSerializer = [AFJSONRequestSerializer serializer];
    }
    return self;
}

-(void)updateWeatherAtLocation:(CLLocation *)location forNumberOfDays:(NSUInteger)number
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"num_of_days"]=@(number);
    parameters[@"q"]=[NSString stringWithFormat:@"%f,%f",location.coordinate.latitude,location.coordinate.longitude];
    parameters[@"format"]=@"json";
    parameters[@"key"]=WorldWeatherOnlineAPIKey;
    
    NSLog(@"%@",[NSString stringWithFormat:@"%@weather.ashx?q=%@&key=%@&num_of_days=%@&format=json",WorldWeatherOnlineURLString,parameters[@"q"],parameters[@"key"],parameters[@"num_of_days"]]);
    
    [self GET:@"weather.ashx" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if ([self.delegate respondsToSelector:@selector(weatherHTTPClient:didUpdateWithWeather:)])
        {
            [self.delegate weatherHTTPClient:self didUpdateWithWeather:responseObject];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        if ([self.delegate respondsToSelector:@selector(weatherHTTPClient:didFailWithError:)])
        {
            [self.delegate weatherHTTPClient:self didFailWithError:error];
        }
        
    }];
    
    
}

@end
