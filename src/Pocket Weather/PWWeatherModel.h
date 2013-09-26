//
//  PWWeatherModel.h
//  Pocket Weather
//
//  Created by Jamey McElveen on 9/11/13.
//  Copyright (c) 2013 AppsAmuck. All rights reserved.
//

#import <Foundation/Foundation.h>
#define WEATHER_MODEL_CHANGED @"com.appsamuck.pocketweather.weather_model_changed"

@class PWConditionModel;

@interface PWWeatherModel : NSObject
@property (nonatomic, strong) NSString *cityName;
@property (nonatomic, strong) NSDate *lastUpdated;
@property (nonatomic, assign, readonly) BOOL isLoading;
@property (nonatomic, strong) NSArray *sevenDayForecast;
@property (nonatomic, assign) BOOL lastLoadFailed;
- (void)loadLocation:(NSString*)location;
- (void)reloadSavedLocation;
+ (instancetype)sharedInstance;
@end

@interface PWForecastModel : NSObject
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) PWConditionModel *conditions;
@property (nonatomic, strong) NSString *wind;
@property (nonatomic, strong) NSString *humidity;
@property (nonatomic, strong) NSString *temperature;
@property (nonatomic, strong) NSString *temperatureLow;
@property (nonatomic, strong) NSString *temperatureHigh;
+ (instancetype)forecastModelFromDictionary:(NSDictionary*)dictionary;
@end

@interface PWConditionModel : NSObject
@property (assign, nonatomic) NSInteger conditionCode;
@property (strong, nonatomic) NSString *condition;
@property (strong, nonatomic) NSString *description;
+ (instancetype)conditionModelFromDictionary:(NSDictionary*)dictionary;
@end
