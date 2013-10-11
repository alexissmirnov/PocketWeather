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
@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;  //temperature
@property (weak, nonatomic) IBOutlet UILabel *temperatureLowLabel;
@property (weak, nonatomic) IBOutlet UILabel *temperatureHighLabel;

- (void)styleControlsForDarkBackground;
- (void)registerAsObserver;

@end

@implementation PWTodayViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.weatherModel = [PWWeatherModel sharedInstance];
    [self registerAsObserver];

    [self.weatherModel reloadSavedLocation];
    if(self.weatherModel.isLoading) {
        [self.loadingActivityIndicator startAnimating];
    }
    
    UITapGestureRecognizer * tapGestureRecognizer = [[UITapGestureRecognizer alloc] init];
    [tapGestureRecognizer addTarget:self action:@selector(openWebSite)];
    [tapGestureRecognizer setNumberOfTapsRequired:1];
    [self.appsAmuck addGestureRecognizer:tapGestureRecognizer];
}

- (void)registerAsObserver
{
    /*
     Register 'self' to receive change notifications for the "lastUpdated" property of
     the 'weatherModel' object and specify that both the old and new values of "lastUpdated"
     should be provided in the observe… method.
     */
    [self.weatherModel addObserver:self
                        forKeyPath:@"lastUpdated"
                           options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld)
                           context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{

    if ([keyPath isEqual:@"lastUpdated"]) {
        [self updateControls];
        if(!self.weatherModel.isLoading) {
            [self.loadingActivityIndicator stopAnimating];
        }
    }

    [super observeValueForKeyPath:keyPath
                         ofObject:object
                           change:change
                          context:context];
}

// this method will open the AppsAmuck web site
- (void)openWebSite
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.appsamuck.com/"]];
}

// updated the user interface controls
- (void)updateControls
{
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
    self.temperatureLabel.text = [NSString stringWithFormat:@"Temp: %@°F", forecast.temperature];
    self.temperatureLowLabel.text = [NSString stringWithFormat:@"Low: %@°F", forecast.temperatureLow];
    self.temperatureHighLabel.text = [NSString stringWithFormat:@"High: %@°F", forecast.temperatureHigh];
    self.windLabel.text = [NSString stringWithFormat:@"Wind: %@", forecast.wind];
    self.humidityLabel.text = [NSString stringWithFormat:@"Humidity: %@%%", forecast.humidity];
    [self.container setCornerRadius:3];

}

// it's night make sure we can read the text :D
- (void)styleControlsForDarkBackground
{
    for (UILabel *label in [self.view subviewsWithClass:[UILabel class]]) {
        label.textColor = [UIColor whiteColor];
    }
}

@end
