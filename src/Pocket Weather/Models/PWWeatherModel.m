//
//  PWWeatherModel.m
//  Pocket Weather
//
//  Created by Jamey McElveen on 9/11/13.
//  Copyright (c) 2013 AppsAmuck. All rights reserved.
//
//  This is the weather model which stores weather information related to the user's location

#import "PWWeatherModel.h"
#import "PWSettingsModel.h"

// URL to Open Weather Map's API
#define OPEN_WEATHER_ENDPOINT @"http://api.openweathermap.org/data/2.5/forecast/daily?q=%@&cnt=7&units=imperial"

@interface PWWeatherModel ()
- (void)loadWithJson:(NSString*)json;
- (void)handleLoadSuccess;
- (void)handleLoadFailureWithMessage:(NSString*)message;
@end

@implementation PWWeatherModel

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static id singleton = nil;
    dispatch_once(&onceToken, ^{
        singleton = [[self alloc] init];
    });
    return singleton;
}

- (PWForecastModel*)forcastAtIndex:(NSInteger)index; {
    return [self.sevenDayForecast objectAtIndex:index];
}

// This method will retreive the weather data for the given location
- (void)loadLocation:(NSString*)location {
    
    _isLoading = YES;
    NSString *serviceEndpoint = [NSString stringWithFormat:OPEN_WEATHER_ENDPOINT, location];
    
    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:serviceEndpoint]];
    [NSURLConnection sendAsynchronousRequest:req
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
    {
        if (response) {
            NSString *message = [NSString stringWithFormat:@"Cannot find the location '%@'", location];
            [self handleLoadFailureWithMessage:message];
        }
                               
        NSString *json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        [self loadWithJson:json];
    }];
}

- (void)reloadSavedLocation {
    NSString *location = [[PWSettingsModel sharedInstance] location];
    [self loadLocation:location];
}

// This method will load the json data from the loadLocation call
- (void)loadWithJson:(NSString*)json {
    NSError *error = nil;
    NSData *data = [json dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options: NSJSONReadingMutableContainers error: &error];
    
    if (!jsonDictionary) {
        NSString *message = [NSString stringWithFormat:@"Error parsing JSON: %@", error];
        [self handleLoadFailureWithMessage:message];
        return;
    } else {
        // cityName
        if (!jsonDictionary[@"city"] ||
            !jsonDictionary[@"city"][@"name"]) {
            [self handleLoadFailureWithMessage:@"Error parsing JSON"];
            return;
        }
        self.cityName = jsonDictionary[@"city"][@"name"];
        NSMutableArray *sevenDayForcast = [[NSMutableArray alloc] init];
        NSArray *list = jsonDictionary[@"list"];
        if(!list) {
            [self handleLoadFailureWithMessage:@"Error parsing JSON"];
            return;
        }
        for(NSDictionary *forecastDictionary in list) {
            PWForecastModel *forecastModel = [PWForecastModel forecastModelFromDictionary:forecastDictionary];
            if(!forecastModel) {
                [self handleLoadFailureWithMessage:@"Error parsing JSON"];
            }
            [sevenDayForcast addObject:forecastModel];
        }
        self.sevenDayForecast = sevenDayForcast;
        self.lastLoadFailed = NO;
        [self handleLoadSuccess];
    }
}

// this method is called if everything worked
- (void)handleLoadSuccess {
    self.lastUpdated = [NSDate date];
    _isLoading = NO;
    self.lastLoadFailed = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:WEATHER_MODEL_CHANGED object:self];
}

// this method is called if something went wrong
- (void)handleLoadFailureWithMessage:(NSString*)message {
    //self.sevenDayForecast = nil;
    _isLoading = NO;
    NSLog(@"%@", message);
    self.lastLoadFailed = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:WEATHER_MODEL_CHANGED object:self];
}

@end

@implementation PWForecastModel

+ (instancetype)forecastModelFromDictionary:(NSDictionary*)dictionary {
    PWForecastModel *fm = [[PWForecastModel alloc] init];
    
    // conditions
    if (!dictionary[@"weather"] ||
        !dictionary[@"weather"][0] ) {
        return nil;
    }
    PWConditionModel *conditions = [PWConditionModel conditionModelFromDictionary:dictionary[@"weather"][0]];
    if (!conditions) {
        return nil;
    }
    fm.conditions = conditions;
    
    // date
    if (!dictionary[@"dt"]) {
        return nil;
    }
    NSInteger unixTime = [dictionary[@"dt"] doubleValue];
    fm.date = [NSDate dateWithTimeIntervalSince1970:unixTime];
    
    // humidity
    if (!dictionary[@"humidity"]) {
        return nil;
    }
    fm.humidity = [dictionary[@"humidity"] stringValue];
    
    // temperature
    if (!dictionary[@"temp"] ||
        !dictionary[@"temp"][@"day"]) {
        return nil;
    }
    fm.temperature = [dictionary[@"temp"][@"day"] stringValue];
    
    // temperatureHigh
    if (!dictionary[@"temp"] ||
        !dictionary[@"temp"][@"max"]) {
        return nil;
    }
    double temperatureHigh = [dictionary[@"temp"][@"max"] doubleValue];
    fm.temperatureHigh = [NSString stringWithFormat:@"%d", (NSInteger)temperatureHigh];
    
    // temperatureHigh
    if (!dictionary[@"temp"] ||
        !dictionary[@"temp"][@"min"]) {
        return nil;
    }
    double temperatureLow = [dictionary[@"temp"][@"min"] doubleValue];
    fm.temperatureLow = [NSString stringWithFormat:@"%d", (NSInteger)temperatureLow];
    
    // wind
    if (!dictionary[@"speed"]) {
        return nil;
    }
    fm.wind = [dictionary[@"speed"] stringValue];
    
    return fm;
}

@end

@implementation PWConditionModel

+ (instancetype)conditionModelFromDictionary:(NSDictionary*)dictionary {
    PWConditionModel *model = [[PWConditionModel alloc] init];
    if (!dictionary[@"main"] || !dictionary[@"description"] || !dictionary[@"id"]) {
        return nil;
    }
    model.conditionCode = [dictionary[@"id"] integerValue];
    model.condition = dictionary[@"main"];
    model.description = dictionary[@"description"];
    return model;
}

@end
