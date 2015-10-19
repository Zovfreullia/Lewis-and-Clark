//
//  MenuViewController.m
//  googleApp
//
//  Created by Fatima Zenine Villanueva on 10/10/15.
//  Copyright © 2015 apps. All rights reserved.
//

#import "MenuViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface MenuViewController () <CLLocationManagerDelegate>

// UI
@property (weak, nonatomic) IBOutlet UIWebView *background;
// Locations
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic) double lat;
@property (nonatomic) double lng;
@property (nonatomic) NSArray *results;
@property (nonatomic) NSString *pathImage;
@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;

@end


@implementation MenuViewController

/*
    Pull the open weather API and based on the main API keyword,
    this will change the gif background on the MenuViewController.
    Use the AFNetworking to pull from open weather API.
 */

#pragma mark - Location Manager Setup

- (void)locationManagerSetup {
self.locationManager = [[CLLocationManager alloc] init];
self.locationManager.delegate = self;
self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
[self.locationManager requestWhenInUseAuthorization];
[self.locationManager startUpdatingLocation];
NSLog(@"ViewDidLoad -- Lat: %f   Lng: %f", self.lat, self.lng);
}

- (void)testingAFNetworking {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSString *weather = [NSString stringWithFormat:@"https://api.forecast.io/forecast/8040fc5b15adaaafabbe7de9c3ff5458/%f,%f",self.lat,self.lng];
    
    NSLog(@"Weather API: %@", weather);
    [manager GET:weather parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        self.results = [[responseObject objectForKey:@"daily"] objectForKey:@"data"];
        NSLog(@"Open weather JSON: %@", self.results);
        
        
        for (NSDictionary *result in self.results) {
            
            // Day eg. Mon, Tues, Wed
            NSNumber *dateTime = [result objectForKey:@"time"];
            NSDate *day = [NSDate dateWithTimeIntervalSinceReferenceDate:[dateTime doubleValue]];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"EEEE"];
            NSString *dayInWeek = [dateFormatter stringFromDate:day];
            
            
            // Summary
            //object.summary = [result objectForKey:@"summary"];
            
            // Rain
            double rain = [[result objectForKey:@"precipProbability"]doubleValue];
            //object.rain = [NSString stringWithFormat:@"%.02f",rain];
            
            // Humidity
            double humidity = [[result objectForKey:@"humidity"]doubleValue];
            //object.humidity = [NSString stringWithFormat:@"%.02f",humidity];
            
            // Wind
            double wind = [[result objectForKey:@"windSpeed"]doubleValue];
            //object.wind = [NSString stringWithFormat:@"%.02f",wind];
            
            // Image
            self.pathImage = [result objectForKey:@"icon"];
            
            // Temperature Max
            double tempMax = [[result objectForKey:@"temperatureMax"]doubleValue];
            //object.tempMax = [NSString stringWithFormat:@"%.02f",tempMax];
            
            // Temperaute Min
            double tempMin = [[result objectForKey:@"temperatureMin"]doubleValue];
            //object.tempMin = [NSString stringWithFormat:@"%.02f",tempMin];
            self.temperatureLabel.text = [NSString stringWithFormat:@"%f - %f", tempMin, tempMax];
            
            //[self.weatherArray addObject:object];
        }

        
        
    }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"Error: %@", error);
         }];
    

}

- (void)settingTheAnimatedBackground {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:self.pathImage ofType:@"gif"];
    NSData *gif = [NSData dataWithContentsOfFile:filePath];
    UIWebView *webViewBG = [[UIWebView alloc] initWithFrame:self.view.frame];
    NSURL *nullURL = nil;
    NSString *nullEncodingName = nil;
    
    [webViewBG loadData:gif
               MIMEType:@"image/gif"
       textEncodingName:nullEncodingName
                baseURL:nullURL];
    
    webViewBG.userInteractionEnabled = NO;
    self.background = webViewBG;
    self.background.frame = CGRectMake(0.0,0.0,self.view.frame.size.width,self.view.frame.size.height);
    
    [self.view addSubview:self.background];
}

- (void)viewDidLayoutSubviews {
    [self settingTheAnimatedBackground];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self testingAFNetworking];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
