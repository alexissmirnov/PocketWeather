//
//  NSDate+PWExtensions.m
//  Pocket Weather
//
//  Created by Jamey McElveen on 9/15/13.
//  Copyright (c) 2013 AppsAmuck. All rights reserved.
//

#import "NSDate+PWExtensions.h"

@implementation NSDate (PWExtensions)

- (NSString*)stringWithFormat:(NSString*)format {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = format;
    return [dateFormatter stringFromDate:self];
}

// define daytime as 5am - 8pm
- (BOOL)isDayTime {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSHourCalendarUnit fromDate:self];
    NSInteger hour = [components hour];
    return hour > 5 && hour < 20;
}

@end
