//
//  PWCodeViewController.m
//  Pocket Weather
//
//  Created by Jamey McElveen on 9/27/13.
//  Copyright (c) 2013 AppsAmuck. All rights reserved.
//
//  This is the code view controller that manages source code page

#import "PWCodeViewController.h"

// address to the source code on GitHub
#define SOURCE_CODE_ADDRESS @"https://github.com/AppsAmuck/PocketWeather"

@interface PWCodeViewController ()
@property(weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation PWCodeViewController


- (void)viewDidLoad {
    [super viewDidLoad];
	NSURL *websiteUrl = [NSURL URLWithString:SOURCE_CODE_ADDRESS];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:websiteUrl];
    [self.webView loadRequest:urlRequest];
}

@end
