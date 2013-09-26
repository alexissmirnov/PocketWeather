//
//  NSDate+PWExtensions.h
//  Pocket Weather
//
//  Created by Jamey McElveen on 9/15/13.
//  Copyright (c) 2013 AppsAmuck. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (PWExtensions)
- (NSString*)stringWithFormat:(NSString*)format;
- (BOOL)isDayTime;
@end
