//
//  CellFirstViewController.m
//  googleApp
//
//  Created by Fatima Zenine Villanueva on 10/2/15.
//  Copyright © 2015 apps. All rights reserved.
//

#import "MainFeedCellXib.h"

@implementation MainFeedCellXib

- (void)awakeFromNib {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)takePictureButton:(UIButton *)sender {
    [self.delegate customCellDidHitCameraButton:self];
    [self.delegate userHitsCameraButton:@"hi"];
}


- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}



@end
