//
//  FirstViewController.m
//  googleApp
//
//  Created by Fatima Zenine Villanueva on 10/2/15.
//  Copyright © 2015 apps. All rights reserved.
//

#import "MainFeedTableViewController.h"


@interface MainFeedTableViewController () <UITableViewDataSource, UITableViewDelegate, CameraImageDelegate, UIImagePickerControllerDelegate>

// UI
@property (weak, nonatomic) IBOutlet UIView *sideBarUIVIEW;

// Storage
@property (nonatomic) NSMutableArray *pins; // NoteSingleton Storage
@property (nonatomic) UIImage *pinnedImage; // pinned

// Core Data
@property (nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic) Note *note;

// Table View
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSIndexPath *selectedIndexPath;

// Camera
@property (nonatomic) UIImage *placeHolderImage;

@end

@implementation MainFeedTableViewController




#pragma mark - Core Data Setup
- (void)coreDataSetup {

    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    
    
    self.note = [NSEntityDescription insertNewObjectForEntityForName:@"Note" inManagedObjectContext:delegate.managedObjectContext];
    
    
    // 1) create an instance of NSFetchRequest with an entity name
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Note"];
    
    // 2) create a sort descriptor
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"createdAt" ascending:NO];
    
    // 3) set the sortDescriptors on the fetchRequest
    fetchRequest.sortDescriptors = @[sort];
    
    // 4) create a fetchedResultsController with a fetchRequest and a managedObjectContext,
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:delegate.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    
    self.fetchedResultsController.delegate = self;
    
    [self.fetchedResultsController performFetch:nil];
    
    NSLog(@"Fetched Results Controller: /n %@", self.fetchedResultsController.fetchedObjects);
    
    NSManagedObjectContext *context =
    [self.fetchedResultsController managedObjectContext];
    
    NSError *error = nil;
    if (![context save:&error])
    {
        NSLog(@"Error deleting, %@", [error userInfo]);
    }
    
    NSLog(@"Objects in Core Data: %u", self.fetchedResultsController.fetchedObjects.count);
    
    
    NSArray *coreDataObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    NSLog(@"Core Data Objects: %@", coreDataObjects);
    
    
    for (int i = 0; i < coreDataObjects.count; i++){
        Note *note = [coreDataObjects objectAtIndex:i];
        
        if (note.latitude == nil && note.longitude == nil){
        NSManagedObject *objectToBeDeleted = [self.fetchedResultsController.fetchedObjects objectAtIndex:i];
        [context deleteObject:objectToBeDeleted];
        
        [delegate.managedObjectContext save:nil];
        }
    }
    
    
    [self.tableView reloadData];
}

#pragma mark - View Did Load

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self coreDataSetup];
    
    [self testingShadow];
    
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    
    [self swRevealController];
    
    [self tableViewMainFeedSetup];
    
}

#pragma mark - Drop Shadow
- (void)testingShadow {
    self.sideBarUIVIEW.layer.masksToBounds = NO;
    self.sideBarUIVIEW.layer.shadowColor = [UIColor blackColor].CGColor;
    self.sideBarUIVIEW.layer.shadowOffset = CGSizeMake(-4.0f, 10.0f);
    self.sideBarUIVIEW.layer.shadowOpacity = 1.0f;
}

# pragma mark - View Setup
- (void) swRevealController {
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController ) {
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    /* 
        This code will be added if I want to use a button to reveal the SW - View Controller Menu
        [self.settingsBarButtonItem setTarget: self.revealViewController];
        [self.settingsBarButtonItem setAction: @selector( revealToggle: )];
    */
}

#pragma mark - Table View Cell and Delegate

- (void) tableViewMainFeedSetup{
    
    self.picker = [[UIImagePickerController alloc] init];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MainFeedCellXib" bundle:nil] forCellReuseIdentifier:@"CellIdentifier"];
}

- (void) viewWillAppear:(BOOL)animated {
    NSLog(@"Objects in Core Data: %u", self.fetchedResultsController.fetchedObjects.count);
    
    [self.tableView reloadData];
}

#pragma mark - Table View Setup

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 150;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.fetchedResultsController.fetchedObjects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MainFeedCellXib *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier" forIndexPath:indexPath];
    
    //Core Data Setup
    
    //Note *note = [self.fetchedResultsController.fetchedObjects objectAtIndex:indexPath.row];
    self.note = [self.fetchedResultsController.fetchedObjects objectAtIndex:indexPath.row];
    cell.delegate = self;
    cell.longitudeLabel.text = [NSString stringWithFormat:@"Latitude: %@",self.note.latitude];
    cell.latitudeLabel.text = [NSString stringWithFormat:@"Longitude: %@",self.note.longitude];
    

    if (self.note.latitude != nil && self.note.longitude != nil){
        if (self.note.hasUserImage == YES){
            cell.selectedPinnedImage.image = self.note.savedImage;

        } else {
            cell.selectedPinnedImage.image = [UIImage imageNamed:@"addimage"];

        }

        
        //Cell image frame settings
        cell.selectedPinnedImage.layer.cornerRadius = cell.selectedPinnedImage.frame.size.width / 2;
        cell.selectedPinnedImage.clipsToBounds = YES;
        cell.selectedPinnedImage.layer.borderWidth = 3.0f;
        cell.selectedPinnedImage.layer.borderColor = [UIColor blackColor].CGColor;
        cell.selectedPinnedImage.layer.cornerRadius = 10.0f;
        cell.backgroundColor = [UIColor clearColor];
    } else {
        cell.selectedPinnedImage.image = nil;
    }
    
    return cell;
}

# pragma mark - Segue Cell

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"MainFeedDetailSegue" sender:self];
    UIStoryboardSegue *segue;
    if ([[segue identifier] isEqualToString:@"MainFeedDetailSegue"]){
        
    }
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"MainFeedDetailSegue"]) {
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        // Core Data
        self.note = [self.fetchedResultsController.fetchedObjects objectAtIndex:indexPath.row];
        
        NSLog(@"self.note: %@", self.note);
        
        MainFeedDetailViewController *vc = segue.destinationViewController;
        
        vc.detailNote = self.note;
    
        NSLog(@"Detail Note: %@", vc.detailNote);
        
    }
}

#pragma mark - Map Button Action

- (IBAction)mapButtonAction:(UIButton *)sender {
    NSLog(@"Going to the map!");
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

# pragma mark - Camera and Image Picker Controller

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    
    MainFeedCellXib *cell;
    self.selectedIndexPath = [self.tableView indexPathForCell:cell];
    
    //NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    self.note = [self.fetchedResultsController.fetchedObjects objectAtIndex:self.selectedIndexPath.row];
    
    // Image from the media
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    // Create a new photo object and set the image.
    self.note.savedImage = image;
    
    self.note.hasUserImage = YES;
    
    NSLog(@"Note.photo: %@", self.note.photo);
    
    [self dismissViewControllerAnimated:YES completion:nil];

    
    [delegate.managedObjectContext save:nil];

    
    [self.tableView reloadData];
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    UserPinClass *pin = [self.pins objectAtIndex:self.selectedIndexPath.row];
    [self dismissViewControllerAnimated:YES completion:nil];
    pin.pinnedImage = image;
    
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);

    [self.tableView reloadData];
}

#pragma mark - Table View Deletion

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete)
    {
        NSManagedObjectContext *context =
        [self.fetchedResultsController managedObjectContext];
        
        NSManagedObject *objectToBeDeleted =
        [self.fetchedResultsController objectAtIndexPath:indexPath];
        
        [context deleteObject:objectToBeDeleted];
        
        AppDelegate *delegate = [UIApplication sharedApplication].delegate;
        
        [delegate.managedObjectContext save:nil];
        
        NSError *error = nil;
        if (![context save:&error])
        {
            NSLog(@"Error deleting movie, %@", [error userInfo]);
        }
        
        NSLog(@"Objects in Core Data: %u", self.fetchedResultsController.fetchedObjects.count);

        [self.tableView reloadData];
    }
}


#pragma mark - NSFetchedResultsController Delegate Methods

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
    [self.tableView reloadData];
}


@end
