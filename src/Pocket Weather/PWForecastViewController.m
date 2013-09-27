//
//  PWSecondViewController.m
//  Pocket Weather
//
//  Created by Chris Craft on 9/2/13.
//  Copyright (c) 2013 AppsAmuck. All rights reserved.
//

#import "PWForecastViewController.h"
#import "PWWeatherModel.h"
#import "PWSettingsModel.h"
#import "PWHelper.h"
#import "NSDate+PWExtensions.h"
#import "UIView+PWExtensions.h"

@interface PWForecastViewController ()

@property (strong, nonatomic) PWWeatherModel* weatherModel;
@property (strong, nonatomic) PWSettingsModel* settingsModel;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIImageView *appsAmuck;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingActivityIndicator;

@property (weak, nonatomic) IBOutlet UILabel *date1Label;
@property (weak, nonatomic) IBOutlet UIImageView *condition1Image;
@property (weak, nonatomic) IBOutlet UILabel *conditions1Label;
@property (weak, nonatomic) IBOutlet UILabel *tempatureHigh1Label;
@property (weak, nonatomic) IBOutlet UILabel *tempatureLow1Label;
@property (weak, nonatomic) IBOutlet UIView *container1View;

@property (weak, nonatomic) IBOutlet UILabel *date2Label;
@property (weak, nonatomic) IBOutlet UIImageView *condition2Image;
@property (weak, nonatomic) IBOutlet UILabel *conditions2Label;
@property (weak, nonatomic) IBOutlet UILabel *tempatureHigh2Label;
@property (weak, nonatomic) IBOutlet UILabel *tempatureLow2Label;
@property (weak, nonatomic) IBOutlet UIView *container2View;

@property (weak, nonatomic) IBOutlet UILabel *date3Label;
@property (weak, nonatomic) IBOutlet UIImageView *condition3Image;
@property (weak, nonatomic) IBOutlet UILabel *conditions3Label;
@property (weak, nonatomic) IBOutlet UILabel *tempatureHigh3Label;
@property (weak, nonatomic) IBOutlet UILabel *tempatureLow3Label;
@property (weak, nonatomic) IBOutlet UIView *container3View;

@property (weak, nonatomic) IBOutlet UILabel *date4Label;
@property (weak, nonatomic) IBOutlet UIImageView *condition4Image;
@property (weak, nonatomic) IBOutlet UILabel *conditions4Label;
@property (weak, nonatomic) IBOutlet UILabel *tempatureHigh4Label;
@property (weak, nonatomic) IBOutlet UILabel *tempatureLow4Label;
@property (weak, nonatomic) IBOutlet UIView *container4View;

- (void)weatherChanged:(id)sender;
- (void)updateControls;
- (void)styleControlsForDarkBackground;

@end

@implementation PWForecastViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.settingsModel = [PWSettingsModel sharedInstance];
    self.weatherModel = [PWWeatherModel sharedInstance];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(weatherChanged:)
                                                 name:WEATHER_MODEL_CHANGED object:nil];
    [self.weatherModel reloadSavedLocation];
    if(self.weatherModel.isLoading) {
        [self.loadingActivityIndicator startAnimating];
    }
    
    UITapGestureRecognizer * tapGestureRecognizer = [[UITapGestureRecognizer alloc] init];
    [tapGestureRecognizer addTarget:self action:@selector(openWebSite)];
    [tapGestureRecognizer setNumberOfTapsRequired:1];
    [self.appsAmuck addGestureRecognizer:tapGestureRecognizer];
}

- (void)openWebSite
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.appsamuck.com/"]];
}

-(void)weatherChanged:(id)sender {
    [self updateControls];
    if(!self.weatherModel.isLoading) {
        [self.loadingActivityIndicator stopAnimating];
    }
}

- (void)updateControls {
    if (!self.weatherModel.lastUpdated) {
        return;
    }
    
    PWForecastModel *forecast = self.weatherModel.sevenDayForecast[0];
    NSString *iconName;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"EE, MMM d";
    NSString *location = [NSString stringWithFormat:@"%@",self.weatherModel.cityName];
    self.locationLabel.text = location;
    
    NSString *backgroundName = [PWHelper backgroundFileNameForConditionCode:forecast.conditions.conditionCode asDaytime:[[NSDate date] isDayTime]];
    if (![[NSDate date] isDayTime]) {
        [self styleControlsForDarkBackground];
    }
    self.backgroundImageView.image = [UIImage imageNamed:backgroundName];

    forecast = self.weatherModel.sevenDayForecast[1];
    iconName = [PWHelper iconFileNameForConditionCode:forecast.conditions.conditionCode];
    self.condition1Image.image = [UIImage imageNamed:iconName];
    self.date1Label.text = [dateFormatter stringFromDate:forecast.date];
    self.conditions1Label.text = [NSString stringWithFormat:@"%@", forecast.conditions];
    self.tempatureLow1Label.text = [NSString stringWithFormat:@"L: %@°F", forecast.temperatureLow];
    self.tempatureHigh1Label.text = [NSString stringWithFormat:@"H: %@°F", forecast.temperatureHigh];
    [self.container1View setCornerRadius:3];

    forecast = self.weatherModel.sevenDayForecast[2];
    iconName = [PWHelper iconFileNameForConditionCode:forecast.conditions.conditionCode];
    self.condition2Image.image = [UIImage imageNamed:iconName];
    self.date2Label.text = [dateFormatter stringFromDate:forecast.date];
    self.conditions2Label.text = [NSString stringWithFormat:@"%@", forecast.conditions];
    self.tempatureLow2Label.text = [NSString stringWithFormat:@"L: %@°F", forecast.temperatureLow];
    self.tempatureHigh2Label.text = [NSString stringWithFormat:@"H: %@°F", forecast.temperatureHigh];
    [self.container2View setCornerRadius:3];
    
    forecast = self.weatherModel.sevenDayForecast[3];
    iconName = [PWHelper iconFileNameForConditionCode:forecast.conditions.conditionCode];
    self.condition3Image.image = [UIImage imageNamed:iconName];
    self.date3Label.text = [dateFormatter stringFromDate:forecast.date];
    self.conditions3Label.text = [NSString stringWithFormat:@"%@", forecast.conditions];
    self.tempatureLow3Label.text = [NSString stringWithFormat:@"L: %@°F", forecast.temperatureLow];
    self.tempatureHigh3Label.text = [NSString stringWithFormat:@"H: %@°F", forecast.temperatureHigh];
    [self.container3View setCornerRadius:3];
    
    forecast = self.weatherModel.sevenDayForecast[4];
    iconName = [PWHelper iconFileNameForConditionCode:forecast.conditions.conditionCode];
    self.condition4Image.image = [UIImage imageNamed:iconName];
    self.date4Label.text = [dateFormatter stringFromDate:forecast.date];
    self.conditions4Label.text = [NSString stringWithFormat:@"%@", forecast.conditions];
    self.tempatureLow4Label.text = [NSString stringWithFormat:@"L: %@°F", forecast.temperatureLow];
    self.tempatureHigh4Label.text = [NSString stringWithFormat:@"H: %@°F", forecast.temperatureHigh];
    [self.container4View setCornerRadius:3];
}

- (void)styleControlsForDarkBackground {
    for (UILabel *label in [self.view subviewsWithClass:[UILabel class]]) {
        label.textColor = [UIColor whiteColor];
    }
}

@end
