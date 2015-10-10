//
//  UserPinClass.m
//  googleApp
//
//  Created by Fatima Zenine Villanueva on 10/2/15.
//  Copyright © 2015 apps. All rights reserved.
//

#import "UserPinClass.h"

@interface UserPinClass()

@property (nonatomic) UIImage *savedImage;

@end

@implementation UserPinClass

- (BOOL)hasUserImage {
    return self.savedImage != nil;
}

- (UIImage *)pinnedImage {
    if (self.savedImage != nil) {
        return self.savedImage;
    }
    return [UIImage imageNamed:@"addimage"];
}

- (void)setPinnedImage:(UIImage *)pinnedImage {
    self.savedImage = pinnedImage;
}

@end
