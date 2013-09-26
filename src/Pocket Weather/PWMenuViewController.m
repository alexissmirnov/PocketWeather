//
//  PWMenuViewController.m
//  Pocket Weather
//
//  Created by Jamey McElveen on 9/25/13.
//  Copyright (c) 2013 AppsAmuck. All rights reserved.
//

#import "PWMenuViewController.h"

#define IOS_7 ([[[UIDevice currentDevice] systemVersion] compare:@"7.0.0" options:NSNumericSearch] != NSOrderedAscending)

@interface PWMenuViewController ()

@end

@implementation PWMenuViewController

- (void)awakeFromNib {
    if (IOS_7) {
        self.tabBar.barStyle = UIBarStyleDefault;
        self.tabBar.translucent = YES;
    }
}

@end
