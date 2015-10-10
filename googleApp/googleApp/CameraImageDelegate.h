//
//  CameraImageDelegate.h
//  googleApp
//
//  Created by Fatima Zenine Villanueva on 10/2/15.
//  Copyright © 2015 apps. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CellFirstViewController;

@protocol CameraImageDelegate <NSObject>

- (void)customCellDidHitCameraButton:(CellFirstViewController *)cell;
- (void)userHitsCameraButton:(NSString *)imageCamera;


@end
