//
//  CompassViewController.m
//  googleApp
//
//  Created by Fatima Zenine Villanueva on 10/21/15.
//  Copyright © 2015 apps. All rights reserved.
//

#import "CompassViewController.h"
#import "GeoPointCompass.h"

@interface CompassViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *arrow;
@property (weak, nonatomic) IBOutlet UITextField *lat;
@property (weak, nonatomic) IBOutlet UITextField *lng;

@property (nonatomic) float latFloat;
@property (nonatomic) float lngFloat;

@end

@implementation CompassViewController

GeoPointCompass *geoPointCompass;


#pragma mark - Drop Shadow
- (void)dropShadowSideBar {
    
    self.sideBarUIView.layer.masksToBounds = NO;
    self.sideBarUIView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.sideBarUIView.layer.shadowOffset = CGSizeMake(-4.0f, 1.0f);
    self.sideBarUIView.layer.shadowOpacity = 1.0f;
}

- (IBAction)backButton:(UIButton *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self.view endEditing:YES];
    
    return YES;
}
- (IBAction)compassButton:(UIButton *)sender {
    self.latFloat = [self.lat.text floatValue];
    self.lngFloat = [self.lng.text floatValue];
    
    geoPointCompass = [[GeoPointCompass alloc] init];
    
    // Add the image to be used as the compass on the GUI
    [geoPointCompass setArrowImageView:self.arrow];
    
    // Set the coordinates of the location to be used for calculating the angle
    geoPointCompass.latitudeOfTargetedPoint = self.latFloat;
    geoPointCompass.longitudeOfTargetedPoint = self.lngFloat;
}

- (void)viewDidLoad {
    
    self.lng.delegate = self;
    self.lat.delegate = self;
    
    [self dropShadowSideBar];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
