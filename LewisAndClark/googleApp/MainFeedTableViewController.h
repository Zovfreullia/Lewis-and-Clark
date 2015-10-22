//
//  FirstViewController.h
//  googleApp
//
//  Created by Fatima Zenine Villanueva on 10/2/15.
//  Copyright © 2015 apps. All rights reserved.
//

// Frameworks
#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <AFNetworking/AFNetworking.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreData/CoreData.h>
#import "AppDelegate.h"

// Classes
#import "UserPinClass.h"
#import "NoteSingleton.h"
#import "MainFeedDetailViewController.h"

// Core Data
#import "Note.h"


// UI
#import "CameraImageDelegate.h"
#import "MainFeedCellXib.h"
#import "SWRevealViewController.h"

// Delegate
#import "SpeciesDelegate.h"

@interface MainFeedTableViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, NSFetchedResultsControllerDelegate, SpeciesDelegate>

@property (nonatomic) UIImagePickerController *picker;

@property (weak, nonatomic) IBOutlet UIImageView *imageCameraImage;

@end
