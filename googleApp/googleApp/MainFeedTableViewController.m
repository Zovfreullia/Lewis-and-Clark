//
//  FirstViewController.m
//  googleApp
//
//  Created by Fatima Zenine Villanueva on 10/2/15.
//  Copyright © 2015 apps. All rights reserved.
//

#import "MainFeedTableViewController.h"
#import "MainFeedCellXib.h"
#import "CameraImageDelegate.h"
#import "UserPinClass.h"
#import "NoteSingleton.h"

@interface MainFeedTableViewController () <UITableViewDataSource, UITableViewDelegate, CameraImageDelegate, UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic) NSMutableArray *pins; // NoteSingleton Storage

@property (nonatomic) UIImage *pinnedImage;
@property (nonatomic) NSMutableArray *imageContainer;
@property (weak, nonatomic) IBOutlet UIButton *settingsButton;
@property (nonatomic) NSIndexPath *selectedIndexPath;

@end

@implementation MainFeedTableViewController


- (void) viewWillAppear:(BOOL)animated {
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.picker = [[UIImagePickerController alloc] init];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MainFeedCellXib" bundle:nil] forCellReuseIdentifier:@"CellIdentifier"];
    
    self.pins = [NoteSingleton sharedManager].pinsArray;
    
    NSLog(@"Pins Array: %@", self.pins);
    
    self.imageContainer = [[NSMutableArray alloc]init];
    
}


#pragma mark - Table View Setup

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 150;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"%lu", (unsigned long)self.pins.count);
    return self.pins.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MainFeedCellXib *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier" forIndexPath:indexPath];
    
    UserPinClass *pin = [self.pins objectAtIndex:indexPath.row];
    
    cell.delegate = self;
    cell.longitudeLabel.text = [NSString stringWithFormat:@"Longitude: %@", pin.longitude];
    cell.latitudeLabel.text = [NSString stringWithFormat:@"Latitude: %@", pin.latitude];
    
    cell.selectedPinnedImage.image = pin.pinnedImage;
    cell.selectedPinnedImage.layer.cornerRadius = cell.selectedPinnedImage.frame.size.width / 2;
    cell.selectedPinnedImage.clipsToBounds = YES;
    cell.selectedPinnedImage.layer.borderWidth = 3.0f;
    cell.selectedPinnedImage.layer.borderColor = [UIColor blackColor].CGColor;
    cell.selectedPinnedImage.layer.cornerRadius = 10.0f;
    cell.cameraButton.hidden = pin.hasUserImage;
    
    return cell;
}

# pragma mark - Camera and Photo Setup

- (void)alertTheViewAboutCamera {
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error"
                                                   message:@"No camera found"
                                                  delegate:self
                                         cancelButtonTitle:@"OK"
                                         otherButtonTitles:nil];
    
    [alert show];
}

- (void)customCellDidHitCameraButton:(MainFeedCellXib *)cell {
    
    self.selectedIndexPath = [self.tableView indexPathForCell:cell];
    
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypeCamera]) {
        self.picker.delegate = self;
        self.picker.allowsEditing = YES;
        self.picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:self.picker
                           animated:YES
                         completion:NULL];
        NSLog(@"working camera");
    }
    
    
    else if ([UIImagePickerController isSourceTypeAvailable:
              UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
        self.picker.delegate = self;
        self.picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        self.picker.allowsEditing = NO;
        [self presentViewController:self.picker
                           animated:YES
                         completion:nil];
        NSLog(@"working photo album");
    }
    
    else {
        [self alertTheViewAboutCamera];
    }
}

#pragma mark - Camera and Image Picker Controller

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UserPinClass *pin = [self.pins objectAtIndex:self.selectedIndexPath.row];
    [self dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
//    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil); ** saves this to photos
    
    pin.pinnedImage = image;
    
    NSLog(@"Images inside container: %@", self.imageContainer);
    
    [self.tableView reloadData];
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    self.pinnedImage = image;
    
    [self.imageContainer addObject:self.pinnedImage];
    
    NSLog(@"Images inside container: %@", self.imageContainer);
    
    [self.tableView reloadData];
}


@end
