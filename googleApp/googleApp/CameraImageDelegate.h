//
//  CameraImageDelegate.h
//  googleApp
//
//  Created by Fatima Zenine Villanueva on 10/2/15.
//  Copyright © 2015 apps. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MainFeedCellXib;

@protocol CameraImageDelegate <NSObject>

- (void)customCellDidHitCameraButton:(MainFeedCellXib *)cell;
- (void)userHitsCameraButton:(NSString *)imageCamera;


@end
