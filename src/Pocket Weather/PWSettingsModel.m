//
//  AASettingsModel.m
//  Pocket Weather
//
//  Created by Jamey McElveen on 9/15/13.
//  Copyright (c) 2013 AppsAmuck. All rights reserved.
//

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

- (NSString*)location {
    NSString *location = [[NSUserDefaults standardUserDefaults] objectForKey:@"location"];
    if (location) {
        _location = location;
    }
    return _location;
}

- (void)setLocation:(NSString*)location {
    if (location) {
        _location = location;
        [[NSUserDefaults standardUserDefaults] setValue:location forKey:@"location"];
    }
}

@end
