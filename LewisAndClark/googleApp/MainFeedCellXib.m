//
//  CellFirstViewController.m
//  googleApp
//
//  Created by Fatima Zenine Villanueva on 10/2/15.
//  Copyright © 2015 apps. All rights reserved.
//

#import "MainFeedCellXib.h"

@implementation MainFeedCellXib

- (IBAction)takePictureButton:(UIButton *)sender {
    [self.delegate customCellDidHitCameraButton:self];
}



@end
