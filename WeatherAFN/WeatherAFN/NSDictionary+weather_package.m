//
//  NSDictionary+weather_package.m
//  WeatherTutorial
//
//  Created by Scott on 26/01/2013.
//  Updated by Joshua Greene 16/12/2013.
//
//  Copyright (c) 2013 Scott Sherwood. All rights reserved.
//

#import "NSDictionary+weather_package.h"

@implementation NSDictionary (weather_package)

- (NSDictionary *)currentCondition
{
    NSDictionary *dict = self[@"data"];
    NSArray *ar = dict[@"current_condition"];
    return ar[0];
}

- (NSDictionary *)request
{
    NSDictionary *dict = self[@"data"];
    NSArray *ar = dict[@"request"];
    return ar[0];
}

- (NSArray *)upcomingWeatherInDays:(NSUInteger)numOfDays withHourlyIndex:(NSUInteger)index
{
    
    //array index = 5day
    NSDictionary *dict = self[@"data"];
    NSArray *weatherArray = dict[@"weather"];
    
    //
    NSMutableArray *outputWeather = [[NSMutableArray alloc] initWithCapacity:numOfDays];

    
    for (NSDictionary *dict in weatherArray) {//5
        //dict
        NSString *currentDay = dict[@"date"];
        NSArray *hourlyArr = dict[@"hourly"];
        //hourly 0-7
        NSDictionary *bodyDict = hourlyArr[index];
        NSMutableDictionary *postDict = [NSMutableDictionary dictionaryWithDictionary:bodyDict];
        [postDict setObject:currentDay forKey:@"date"];
        
        [outputWeather addObject:postDict];
        
    }
    
    
    return outputWeather;
}



@end