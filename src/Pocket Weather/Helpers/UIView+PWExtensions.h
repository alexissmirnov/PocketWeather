//
//  UIView+PWExtensions.h
//  Pocket Weather
//
//  Created by Jamey McElveen on 9/13/13.
//  Copyright (c) 2013 AppsAmuck. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (PWExtensions)
- (NSArray*)subviewsWithClass:(Class)klass;
- (void)setCornerRadius:(CGFloat)cornerRadius;
@end
