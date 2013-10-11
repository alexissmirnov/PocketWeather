//
//  AASettingsModel.m
//  Pocket Weather
//
//  Created by Jamey McElveen on 9/15/13.
//  Copyright (c) 2013 AppsAmuck. All rights reserved.
//
//  This is the settings model which handles storing the user's location

#import "PWSettingsModel.h"

@interface PWSettingsModel () {
    NSString *_location;
}
@end

@implementation PWSettingsModel

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static id singleton = nil;
    dispatch_once(&onceToken, ^{
        singleton = [[self alloc] init];
    });
    return singleton;
}

- (id)init {
    self = [super init];
    if (self) {
        _location = @"29501";
    }
    return self;
}

// Location stores the user's location
- (NSString*)location {
    NSString *location = [[NSUserDefaults standardUserDefaults] objectForKey:@"location"];
    if (location) {
        _location = location;
    }
    return _location;
}

// This method will set the user's location to the string location
- (void)setLocation:(NSString*)location {
    if (location) {
        _location = location;
        [[NSUserDefaults standardUserDefaults] setValue:location forKey:@"location"];
    }
}

@end
