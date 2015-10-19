//
//  Note+CoreDataProperties.m
//  googleApp
//
//  Created by Fatima Zenine Villanueva on 10/17/15.
//  Copyright © 2015 apps. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Note+CoreDataProperties.h"

@implementation Note (CoreDataProperties)

@dynamic createdAt;
@dynamic latitude;
@dynamic longitude;
@dynamic title;
@dynamic hasUserImage;
@dynamic summary;
@dynamic audioData;
@dynamic photo;
@dynamic savedImage;


- (BOOL)hasUserImage {
    return self.savedImage != nil;
}

- (UIImage *)photo {
    if (self.savedImage != nil) {
        return self.savedImage;
    }
    return [UIImage imageNamed:@"addimage"];
}

- (void)setPinnedImage:(UIImage *)photo {
    self.savedImage = photo;
}


@end
