//
//  PWHelper.h
//  Pocket Weather
//
//  Created by Jamey McElveen on 9/13/13.
//  Copyright (c) 2013 AppsAmuck. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PWHelper : NSObject
+ (NSString*)iconFileNameForConditionCode:(NSInteger)conditionCode;
+ (NSString*)backgroundFileNameForConditionCode:(NSInteger)conditionCode asDaytime:(BOOL)daytime;
@end
