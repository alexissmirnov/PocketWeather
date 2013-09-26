//
//  UIView+PWExtensions.m
//  Pocket Weather
//
//  Created by Jamey McElveen on 9/13/13.
//  Copyright (c) 2013 AppsAmuck. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "UIView+PWExtensions.h"

@implementation UIView (PWExtensions)

- (NSArray*)subviewsWithClass:(Class)klass {
    NSMutableArray *result = [[NSMutableArray alloc] init];
    [UIView subviewsOfView:self class:klass subviews:result];
    return result;
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    [[self layer] setCornerRadius:cornerRadius];
}

+ (void)subviewsOfView:(UIView*)view class:(Class)klass subviews:(NSMutableArray*)subviews {
    for (id v in view.subviews) {
        if ([v isKindOfClass:klass]) {
            [subviews addObject:v];
        }
        [self subviewsOfView:v class:klass subviews:subviews];
    }
}

@end