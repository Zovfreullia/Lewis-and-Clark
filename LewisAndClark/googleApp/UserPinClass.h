 //
//  UserPinClass.h
//  googleApp
//
//  Created by Fatima Zenine Villanueva on 10/2/15.
//  Copyright © 2015 apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UserPinClass : NSObject

@property (nonatomic) NSString *latitude;
@property (nonatomic) NSString *longitude;
@property (nonatomic) UIImage *pinnedImage;
@property (nonatomic) NSString *title;
@property (nonatomic) NSString *text;
@property (nonatomic) NSURL *audioURL;
@property (nonatomic) NSURL *imageURL;
@property (nonatomic) BOOL hasUserImage;

@end
