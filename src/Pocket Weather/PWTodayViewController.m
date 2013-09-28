//
//  PWFirstViewController.m
//  Pocket Weather
//
//  Created by Chris Craft on 9/2/13.
//  Copyright (c) 2013 AppsAmuck. All rights reserved.
//
//  This is the today controller that manages forecast page

#import "PWTodayViewController.h"
#import "PWSettingsModel.h"
#import "PWWeatherModel.h"
#import "PWHelper.h"
#import "UIView+PWExtensions.h"
#import "NSDate+PWExtensions.h"

@interface PWTodayViewController ()
@property (nonatomic, weak) PWSettingsModel* settingsModel;
@property (nonatomic, weak) PWWeatherModel* weatherModel;
@property (weak, nonatomic) IBOutlet UIView *container;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingActivityIndicator;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIImageView *conditionImageView;
@property (weak, nonatomic) IBOutlet UIImageView *appsAmuck;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *conditionsLabel;
@property (weak, nonatomic) IBOutlet UILabel *windLabel;
@property (weak, nonatomic) IBOutlet UILabel *humidityLabel;
@property (weak, nonatomic) IBOutlet UILabel *tempatureLabel;
@property (weak, nonatomic) IBOutlet UILabel *tempatureLowLabel;
@property (weak, nonatomic) IBOutlet UILabel *tempatureHighLabel;

- (void)weatherChanged:(id)sender;
- (void)styleControlsForDarkBackground;
@end

@implementation PWTodayViewController

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

// this method will open the AppsAmuck web site
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

// updated the user interface controls
- (void)updateControls {
    if (!self.weatherModel.lastUpdated) {
        return;
    }
    
    PWForecastModel *forecast = self.weatherModel.sevenDayForecast[0];
    
    NSString *iconName = [PWHelper iconFileNameForConditionCode:forecast.conditions.conditionCode];
    NSString *backgroundName = [PWHelper backgroundFileNameForConditionCode:forecast.conditions.conditionCode asDaytime:[[NSDate date] isDayTime]];
    if (![[NSDate date] isDayTime]) {
        [self styleControlsForDarkBackground];
    }
    
    self.locationLabel.text = [NSString stringWithFormat:@"%@",self.weatherModel.cityName];
    self.dateLabel.text = [[NSDate date] stringWithFormat:@"EE, MMM d"];
    self.backgroundImageView.image = [UIImage imageNamed:backgroundName];
    self.conditionImageView.image = [UIImage imageNamed:iconName];
    self.conditionsLabel.text = [[NSString stringWithFormat:@"%@", forecast.conditions.description] uppercaseString];
    self.tempatureLabel.text = [NSString stringWithFormat:@"Temp: %@°F", forecast.temperature];
    self.tempatureLowLabel.text = [NSString stringWithFormat:@"Low: %@°F", forecast.temperatureLow];
    self.tempatureHighLabel.text = [NSString stringWithFormat:@"High: %@°F", forecast.temperatureHigh];
    self.windLabel.text = [NSString stringWithFormat:@"Wind: %@", forecast.wind];
    self.humidityLabel.text = [NSString stringWithFormat:@"Humidity: %@%%", forecast.humidity];
    [self.container setCornerRadius:3];

}

// it's night make sure we can read the text :D
- (void)styleControlsForDarkBackground {
    for (UILabel *label in [self.view subviewsWithClass:[UILabel class]]) {
        label.textColor = [UIColor whiteColor];
    }
}

@end
