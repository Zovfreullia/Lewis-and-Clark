#if !defined(__has_feature) || !__has_feature(objc_arc)
#error "This file requires ARC support."
#endif

@import GoogleMaps;

#import "MapViewController.h"

@interface MapViewController () <GMSPanoramaViewDelegate, CLLocationManagerDelegate, GMSMapViewDelegate>

// Locations
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet GMSMapView *googleMapView;
@property (nonatomic) double lat;
@property (nonatomic) double lng;

// UI
@property (weak, nonatomic) IBOutlet UIView *sideBarUIView;

// Core Data
@property (nonatomic) Note *note;
@property (nonatomic) NSFetchedResultsController *fetchedResultsController;


@end

@implementation MapViewController {
    BOOL configured_;
}

- (void)viewWillAppear:(BOOL)animated {
    NSLog(@"Objects in Core Data: %lu", self.fetchedResultsController.fetchedObjects.count);
}

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
    
    NSManagedObjectContext *context =
    [self.fetchedResultsController managedObjectContext];
    
    NSError *error;
    
    NSArray *coreDataObjects = [context executeFetchRequest:fetchRequest error:&error];

    for (int i = 0; i < coreDataObjects.count; i++){
        Note *note = [coreDataObjects objectAtIndex:i];
        
        if (note.latitude == nil && note.longitude == nil){
            NSManagedObject *objectToBeDeleted = [self.fetchedResultsController.fetchedObjects objectAtIndex:i];
            [context deleteObject:objectToBeDeleted];
            
            [delegate.managedObjectContext save:nil];
        }
    }
    
}

#pragma mark - Drop Shadow
- (void)dropShadowSideBar {
    self.sideBarUIView.layer.masksToBounds = NO;
    self.sideBarUIView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.sideBarUIView.layer.shadowOffset = CGSizeMake(-4.0f, 1.0f);
    self.sideBarUIView.layer.shadowOpacity = 1.0f;
}

#pragma mark - Retrieves and displays all the user pins
- (void)pullOutThePins {
//    NSMutableArray *storePins = [NoteSingleton sharedManager].pinsArray;
//    NSLog(@"The singleton array pins: %@", storePins);
    
    NSLog(@"\nTesting core data: %@  \nNumber: %lu", self.fetchedResultsController.fetchedObjects, (unsigned long)self.fetchedResultsController.fetchedObjects.count);
    
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    
    NSError *error;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Note"];

    NSArray *coreDataPins = [context executeFetchRequest:fetchRequest error:&error];
    
    NSLog(@"Core Data Pins: %@", coreDataPins);
    
    for (Note *note in coreDataPins){
        double latitude = [note.latitude doubleValue];
        double longitude = [note.longitude doubleValue];
        CLLocationCoordinate2D pos = CLLocationCoordinate2DMake(latitude,longitude);
        NSLog(@"Pins -- Lat: %f Lng: %f", latitude, longitude);
        GMSMarker *marker = [GMSMarker markerWithPosition:pos];
        marker.snippet = [NSString stringWithFormat:@"Longitude: %f  Latitude: %f", longitude, latitude];
        marker.map = self.googleMapView;
        
        NSLog(@"Notes: %@", note);
    }
    

    
    /*
    for(UserPinClass *pin in storePins){
        double latitude = [pin.latitude doubleValue];
        double longitude = [pin.longitude doubleValue];
        CLLocationCoordinate2D pos = CLLocationCoordinate2DMake(latitude,longitude);
        GMSMarker *marker = [GMSMarker markerWithPosition:pos];
        marker.snippet = [NSString stringWithFormat:@"Longitude: %f  Latitude: %f", longitude, latitude];
        marker.map = self.googleMapView;
    }
     */
}

#pragma mark - Location Manager Setup
- (void)locationManagerSetup {
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager startUpdatingLocation];
    NSLog(@"ViewDidLoad -- Lat: %f   Lng: %f", self.lat, self.lng);
}

#pragma mark - ViewDidLoad Setup
- (void)viewDidLoad {
    [super viewDidLoad];
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    [self coreDataSetup];
    [self locationManagerSetup];
    [self pullOutThePins];
    [self dropShadowSideBar];
    NSLog(@"Objects in Core Data: %lu", self.fetchedResultsController.fetchedObjects.count);

}

#pragma mark - Google Map Setup
- (void)loadGoogleMap {
    // camera for the Google Map
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:self.lat
                                                            longitude:self.lng
                                                                 zoom:15];
    
    // animate to the location of the longitude and latitude
    [self.googleMapView animateToCameraPosition:camera];
    
    /*  Add the self.googleMapView to the main view
        This overrides the map that is already on the view
        [self.view addSubview:self.googleMapView];
    */
}

#pragma mark - Google Map Load

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    CLLocation *location = locations.lastObject;
    self.lng = location.coordinate.longitude;
    self.lat = location.coordinate.latitude;
    NSLog(@"Lat: %f   Lng: %f", self.lat, self.lng);
    
    if (self.lng != 0 && self.lat != 0){
        NSLog(@"run");
        [self loadGoogleMap];
    }
    
    [self.locationManager stopUpdatingLocation];

}

#pragma mark - Drop Pin

- (IBAction)dropPinButton:(UIButton *)sender {

    /*
    UserPinClass *object = [[UserPinClass alloc]init];
    object.latitude = [NSString stringWithFormat:@"%f", self.lat];
    object.longitude = [NSString stringWithFormat:@"%f", self.lng];
    NSMutableArray *pins = [NoteSingleton sharedManager].pinsArray;
    [pins addObject:object];
     */


//    NotePinClass *parseObject = [[NotePinClass alloc]init];
//    parseObject.latitude = object.latitude;
//    parseObject.longitude = object.longitude;

//    NSLog(@"pins %@", pins);
    
//    [parseObject saveInBackground];
    
 
    
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    
    self.note = [NSEntityDescription insertNewObjectForEntityForName:@"Note" inManagedObjectContext:delegate.managedObjectContext];
    
    self.note.latitude = [NSString stringWithFormat:@"%f", self.lat];
    self.note.longitude = [NSString stringWithFormat:@"%f", self.lng];
    self.note.createdAt = [NSDate date];
    
    [delegate.managedObjectContext save:nil];

    
    NSLog(@"Adding a new pin!");
    
    CLLocationCoordinate2D position = CLLocationCoordinate2DMake(self.lat, self.lng);
    GMSMarker *marker = [GMSMarker markerWithPosition:position];
    marker.snippet = [NSString stringWithFormat:@"Longitude: %f  Latitude: %f", self.lng, self.lat];
    marker.map = self.googleMapView;
    marker.appearAnimation = kGMSMarkerAnimationPop;
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - Close Button
- (IBAction)cancelButton:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}


@end
