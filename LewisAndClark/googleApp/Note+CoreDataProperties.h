//
//  Note+CoreDataProperties.h
//  googleApp
//
//  Created by Fatima Zenine Villanueva on 10/17/15.
//  Copyright © 2015 apps. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Note.h"
#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@interface Note (CoreDataProperties)

@property (nullable, nonatomic, retain) NSDate *createdAt;
@property (nullable, nonatomic, retain) NSString *latitude;
@property (nullable, nonatomic, retain) NSString *longitude;
@property (nullable, nonatomic, retain) NSString *title;
@property (nonatomic) BOOL hasUserImage;
@property (nullable, nonatomic, retain) NSString *summary;
@property (nullable, nonatomic, retain) NSString *audioData;
@property (nonatomic) UIImage *photo;
@property (nonatomic) UIImage *savedImage;


@end

NS_ASSUME_NONNULL_END
