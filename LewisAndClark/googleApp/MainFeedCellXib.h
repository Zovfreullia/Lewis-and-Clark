//
//  CellFirstViewController.h
//  googleApp
//
//  Created by Fatima Zenine Villanueva on 10/2/15.
//  Copyright © 2015 apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CameraImageDelegate.h"

@interface MainFeedCellXib : UITableViewCell <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *selectedPinnedImage;
@property (weak, nonatomic) IBOutlet UILabel *longitudeLabel;
@property (weak, nonatomic) IBOutlet UILabel *latitudeLabel;
@property (weak, nonatomic) IBOutlet UILabel *speciesNameLabel;



@property (nonatomic, weak) id <CameraImageDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *cameraButton;

@end

