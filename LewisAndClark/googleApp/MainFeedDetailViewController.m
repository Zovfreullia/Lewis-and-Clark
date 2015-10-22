//
//  MainFeedDetailViewController.m
//  googleApp
//
//  Created by Fatima Zenine Villanueva on 10/10/15.
//  Copyright © 2015 apps. All rights reserved.
//

#import "MainFeedDetailViewController.h"

// Audio File Path
#define DOCUMENTS_FOLDER [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]

/*
    Optional way to generate the file path
    NSString * GenerateAudioPath(NSString *filename) {
        return [NSString stringWithFormat:@"%@/%@.caf", DOCUMENTS_FOLDER, filename];
    }
*/


@implementation MainFeedDetailViewController

// Synthesize audio recorder variables
@synthesize recorder,recorderSettings,recorderFilePath;
@synthesize audioPlayer,audioFileName;


#pragma mark - Core Data Setup
- (void)coreDataSetup {
    
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    
    
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


#pragma mark - Drop shadow under side bar
- (void) dropShadowSideBar {
    self.sideBarUIView.layer.masksToBounds = NO;
    self.sideBarUIView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.sideBarUIView.layer.shadowOffset = CGSizeMake(-4.0f, 0.0f);
    self.sideBarUIView.layer.shadowOpacity = 1.0f;
}

#pragma mark - Exit or Cancel Button
- (IBAction)exitMainFeedDetailButton:(UIButton *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - Text Field actions
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;

    audioFileName = textField.text;
    self.detailNote.title = textField.text;
    
    [self.delegate nameOfSpecies:textField.text];
    
    [delegate.managedObjectContext save:nil];

    [self.view endEditing:YES];
    return YES;
}

- (void)viewDidLoadSetup {
    self.logTitleTextField.delegate = self;
    self.summaryTextView.delegate = self;
    
    self.logTitleTextField.text = self.detailNote.title;
    self.summaryTextView.text = self.detailNote.summary;
    
    NSLog(@"Pin is working: %@", self.detailNote);
    
    self.stopPlayingButton.hidden = YES;
    self.stopRecordingButton.hidden = YES;
}

#pragma mark - View Controller Life cycle methods
- (void)viewDidLoad
{
    [[self navigationController] setNavigationBarHidden:YES animated:YES];

    [self dropShadowSideBar];
    
    [self viewDidLoadSetup];
    
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    self.detailNote.summary = textView.text;

    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}


#pragma mark - Start recording audio
- (IBAction)startRecording:(id)sender
{
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    NSError *err = nil;
    [audioSession setCategory :AVAudioSessionCategoryPlayAndRecord error:&err];
    if(err)
    {
        NSLog(@"audioSession: %@ %ld %@", [err domain], (long)[err code], [[err userInfo] description]);
        return;
    }
    [audioSession setActive:YES error:&err];
    err = nil;
    if(err)
    {
        NSLog(@"audioSession: %@ %ld %@", [err domain], (long)[err code], [[err userInfo] description]);
        return;
    }
    
    recorderSettings = [[NSMutableDictionary alloc] init];
    [recorderSettings setValue :[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];
    [recorderSettings setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
    [recorderSettings setValue:[NSNumber numberWithInt: 2] forKey:AVNumberOfChannelsKey];
    [recorderSettings setValue :[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
    [recorderSettings setValue :[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsBigEndianKey];
    [recorderSettings setValue :[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsFloatKey];
    
    // Create a new audio file
    //audioFileName = @"recordingTestFile";
    
    NSString *saveName = [NSString stringWithFormat:@"Documents/%@.caf", audioFileName];
    NSString *savePath = [NSHomeDirectory() stringByAppendingPathComponent:saveName];

    //recorderFilePath = [NSString stringWithFormat:@"%@/%@.caf", DOCUMENTS_FOLDER, audioFileName];
    
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    
    self.audioURLtemp = [NSURL fileURLWithPath:savePath];
    
    NSLog(@"audio url: %@", self.audioURLtemp);
    
    self.detailNote.audioData = [self.audioURLtemp absoluteString];
    
    

    
    
    [delegate.managedObjectContext save:nil];


    err = nil;
    recorder = [[ AVAudioRecorder alloc] initWithURL:self.audioURLtemp settings:recorderSettings error:&err];
    if(!recorder){
        NSLog(@"recorder: %@ %ld %@", [err domain], (long)[err code], [[err userInfo] description]);
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle: @"Warning" message: [err localizedDescription] delegate: nil
                         cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    //prepare to record
    [recorder setDelegate:self];
    [recorder prepareToRecord];
    recorder.meteringEnabled = YES;
    
    BOOL audioHWAvailable = audioSession.inputAvailable;
    if (! audioHWAvailable) {
        UIAlertView *cantRecordAlert =
        [[UIAlertView alloc] initWithTitle: @"Warning"message: @"Audio input hardware not available"
                                  delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [cantRecordAlert show];
        return;
    }
    
    // start recording
    [recorder recordForDuration:(NSTimeInterval) 60];//Maximum recording time : 60 seconds default
    NSLog(@"Recroding Started");
    
    [self buttonActivationHide:self.startRecordingButton secondButtonShow:self.stopRecordingButton];
}


#pragma mark - Stop recording audio
- (IBAction)stopRecording:(id)sender
{
    [recorder stop];
    NSLog(@"Recording Stopped");
    
    [self buttonActivationHide:self.stopRecordingButton secondButtonShow:self.startRecordingButton];
}

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *) aRecorder successfully:(BOOL)flag
{
    NSLog (@"audioRecorderDidFinishRecording:successfully:");
}


#pragma mark - Start playing audio
- (IBAction)startPlaying:(id)sender
{
    
    NSLog(@"playRecording");
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    NSLog(@"audio data: %@", self.detailNote.audioData);

    NSURL *url = [[NSURL alloc] initWithString: self.detailNote.audioData];
    
//    NSURL *url = self.audioURLtemp;
    NSError *error;
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    audioPlayer.numberOfLoops = 0;
    [audioPlayer play];
    NSLog(@"This is playing: %@", url);
    NSLog(@"playing");
    
    [self buttonActivationHide:self.startPlayingButton secondButtonShow:self.stopPlayingButton];
}

#pragma mark - Stop playing audio
- (IBAction)stopPlaying:(id)sender
{
    [audioPlayer stop];
    NSLog(@"stopped");
    [self buttonActivationHide:self.stopPlayingButton secondButtonShow:self.startPlayingButton];
}

#pragma mark - Show and Hide Recording Buttons
- (void)buttonActivationHide: (UIButton *)hideButton secondButtonShow:(UIButton *)showButton {
    hideButton.hidden = YES;
    showButton.hidden = NO;
}


@end






