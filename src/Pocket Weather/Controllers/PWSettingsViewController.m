//
//  AASettingsViewController.m
//  Pocket Weather
//
//  Created by Jamey McElveen on 9/15/13.
//  Copyright (c) 2013 AppsAmuck. All rights reserved.
//
//  This is the settings view controller that manages settings page

#import "PWSettingsViewController.h"
#import "PWWeatherModel.h"
#import "PWSettingsModel.h"
#import "UIView+PWExtensions.h"
#import "NSDate+PWExtensions.h"
#import "PWHelper.h"

@interface PWSettingsViewController ()
@property (weak, nonatomic) PWWeatherModel* weatherModel;
@property (weak, nonatomic) PWSettingsModel* settingsModel;
@property (weak, nonatomic) IBOutlet UIImageView *appsAmuck;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UITextField *locationTextField;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
- (void)styleControlsForDarkBackground;
- (void)configureControls;
@end

@implementation PWSettingsViewController

- (IBAction)saveTapped:(UIButton *)sender {
    if(![self.settingsModel.location isEqualToString:self.locationTextField.text]) {
        [self.weatherModel loadLocation:self.locationTextField.text];
        if(self.weatherModel.isLoading) {
            self.locationTextField.enabled = NO;
            self.saveButton.hidden = YES;
            self.activityIndicator.hidden = NO;
            [self.activityIndicator startAnimating];
        }
        if([self.locationTextField isFirstResponder]) {
            [self.locationTextField resignFirstResponder];
        }
    }
}

- (void)viewDidLoad {
    self.settingsModel = [PWSettingsModel sharedInstance];
    self.weatherModel = [PWWeatherModel sharedInstance];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(weatherChanged:)
                                                 name:WEATHER_MODEL_CHANGED object:nil];
    
    self.activityIndicator.hidden = YES;
    self.locationTextField.text = self.settingsModel.location;
    
    [self configureControls];

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
    [self configureControls];
}

// updated the user interface controls
- (void)configureControls {
    
    [self.activityIndicator stopAnimating];
    
    [UIView animateWithDuration:1.5 animations:^{
        
        if (self.weatherModel.lastLoadFailed) {
            self.locationTextField.enabled = YES;
            self.saveButton.hidden = NO;
            self.activityIndicator.hidden = YES;
            return;
        }
        
        self.settingsModel.location = self.locationTextField.text;
        
        
        PWForecastModel *forecast = self.weatherModel.sevenDayForecast[0];
        NSString *backgroundName = [PWHelper backgroundFileNameForConditionCode:forecast.conditions.conditionCode asDaytime:[[NSDate date] isDayTime]];
        if (![[NSDate date] isDayTime]) {
            [self styleControlsForDarkBackground];
        }
        self.backgroundImageView.image = [UIImage imageNamed:backgroundName];
        self.locationLabel.text = [NSString stringWithFormat:@"%@",self.weatherModel.cityName];
    }];
}

// it's night make sure we can read the text :D
- (void)styleControlsForDarkBackground {
    for (UILabel *label in [self.view subviewsWithClass:[UILabel class]]) {
        label.textColor = [UIColor whiteColor];
    }
}

@end
