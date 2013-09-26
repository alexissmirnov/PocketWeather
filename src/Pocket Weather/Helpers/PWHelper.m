//
//  PWHelper.m
//  Pocket Weather
//
//  Created by Jamey McElveen on 9/13/13.
//  Copyright (c) 2013 AppsAmuck. All rights reserved.
//

#import "PWHelper.h"

@implementation PWHelper

+ (NSString*)iconFileNameForConditionCode:(NSInteger)conditionCode {
    
    NSString *condition;
    
    switch (conditionCode) {
            // THUNDERSTORMS
        case 201: // thunderstorm with rain
        case 202: // thunderstorm with heavy rain
        case 210: // light thunderstorm
            condition = @"chance-of-thunder-storm";
            break;
        case 211: // thunderstorm
        case 212: // heavy thunderstorm
        case 221: // ragged thunderstorm
            condition = @"thunder-storm";
            break;
        case 230: // thunderstorm with light drizzle
        case 231: // thunderstorm with drizzle
        case 232: // thunderstorm with heavy drizzle
            condition = @"chance-of-storm";
            break;
            
            // DRIZZLE
        case 300: // light intensity drizzle
        case 301: // drizzle
        case 302: // heavy intensity drizzle
        case 310: // light intensity drizzle rain
        case 311: // drizzle rain
        case 312: // heavy intensity drizzle rain
        case 321: // shower drizzle
            condition = @"chance-of-rain";
            break;
            
            // RAIN
        case 500: // light rain
        case 501: // moderate rain
        case 502: // heavy intensity rain
        case 503: // very heavy rain
        case 504: // extreme rain
        case 511: // freezing rain
        case 520: // light intensity shower rain
        case 521: // shower rain
        case 522: // heavy intensity shower rain
            condition = @"rain";
            break;
            
            // SNOW
        case 600: // light snow
            condition = @"chance-of-snow";
            break;
        case 601: // snow
            condition = @"flurries";
            break;
        case 602: // heavy snow
            condition = @"icy";
            break;
        case 611: // sleet
            condition = @"sleet";
            break;
        case 621: // shower snow
            condition = @"snow";
            break;
            
            // HAZE & FOG
        case 701: // mist
            condition = @"mist";
            break;
        case 711: // smoke
            condition = @"smoke";
            break;
        case 721: // haze
            condition = @"haze";
            break;
        case 731: // Sand/Dust Whirls
            condition = @"dust";
            break;
        case 741: // Fog
            condition = @"fog";
            break;
            
            // CALM
        case 800: // sky is clear
            condition = @"sunny";
            break;
        case 801: // few clouds
            condition = @"mostly-sunny";
            break;
        case 802: // scattered clouds
            condition = @"partly-cloudy";
            break;
        case 803: // broken clouds
            condition = @"cloudy";
            break;
        case 804: // overcast clouds
            condition = @"mostly-cloudy";
            break;
            
            // STORMY
        case 900: // tornado
        case 901: // tropical storm
        case 902: // hurricane
        case 903: // cold
        case 904: // hot
        case 905: // windy
        case 906: // hail
            condition = @"storm";
            break;
            
        default:
            condition = @"sunny";
            break;
    }
    
    return [NSString stringWithFormat:@"tile-%@.png", condition];
}

+ (NSString*)backgroundFileNameForConditionCode:(NSInteger)conditionCode asDaytime:(BOOL)daytime {
    
    NSString *condition;
    NSString *dayNight = daytime ? @"day" : @"night";
    
    switch (conditionCode) {
            
        case 201: // thunderstorm with rain
        case 202: // thunderstorm with heavy rain
        case 210: // light thunderstorm
        case 211: // thunderstorm
        case 212: // heavy thunderstorm
        case 221: // ragged thunderstorm
        case 230: // thunderstorm with light drizzle
        case 231: // thunderstorm with drizzle
        case 232: // thunderstorm with heavy drizzle
            condition = @"stormy";
            break;
            
        case 300: // light intensity drizzle
        case 301: // drizzle
        case 302: // heavy intensity drizzle
        case 310: // light intensity drizzle rain
        case 311: // drizzle rain
        case 312: // heavy intensity drizzle rain
        case 321: // shower drizzle
        case 500: // light rain
        case 501: // moderate rain
        case 502: // heavy intensity rain
        case 503: // very heavy rain
        case 504: // extreme rain
        case 511: // freezing rain
        case 520: // light intensity shower rain
        case 521: // shower rain
        case 522: // heavy intensity shower rain
            condition = @"rainy";
            break;
            
        case 600: // light snow
        case 601: // snow
        case 602: // heavy snow
        case 611: // sleet
        case 621: // shower snow
            condition = @"snowy";
            break;
            
        case 701: // mist
        case 711: // smoke
        case 721: // haze
        case 731: // Sand/Dust Whirls
        case 741: // Fog
            condition = @"cloudy";
            break;
            
        case 800: // sky is clear
            condition = @"clear";
            break;
            
        case 801: // few clouds
        case 802: // scattered clouds
        case 803: // broken clouds
        case 804: // overcast clouds
            condition = @"cloudy";
            break;
            
        case 900: // tornado
        case 901: // tropical storm
        case 902: // hurricane
        case 903: // cold
        case 904: // hot
        case 905: // windy
        case 906: // hail
            condition = @"stormy";
            break;
            
        default:
            condition = @"clear";
            break;
    }
    
    return [NSString stringWithFormat:@"%@-%@-background.png", condition, dayNight];
    
}

@end
