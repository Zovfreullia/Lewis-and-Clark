//
//  MainFeedDetailViewController.h
//  googleApp
//
//  Created by Fatima Zenine Villanueva on 10/10/15.
//  Copyright © 2015 apps. All rights reserved.
//

// Frameworks
#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import <Parse/Parse.h>
#import "AppDelegate.h"

// Classes
#import "UserPinClass.h"

// Core Data
#import "Note.h"


@interface MainFeedDetailViewController : UIViewController <AVAudioRecorderDelegate, AVAudioPlayerDelegate, UITextFieldDelegate, NSFetchedResultsControllerDelegate, UITextViewDelegate>

// Core Data
@property (nonatomic)Note *detailNote;
@property (nonatomic) NSFetchedResultsController *fetchedResultsController;

// Storage
@property (nonatomic)UserPinClass *detailPin;
@property (nonatomic) NSURL *audioURLtemp;

// UI
@property (weak, nonatomic) IBOutlet UIView *sideBarUIView;
@property (weak, nonatomic) IBOutlet UITextField *logTitleTextField;
@property (weak, nonatomic) IBOutlet UITextView *summaryTextView;

// Audio Buttons
@property (weak, nonatomic) IBOutlet UIButton *stopRecordingButton;
@property (weak, nonatomic) IBOutlet UIButton *startRecordingButton;
@property (weak, nonatomic) IBOutlet UIButton *startPlayingButton;
@property (weak, nonatomic) IBOutlet UIButton *stopPlayingButton;

// Audio Button Actions
- (IBAction)stopRecording:(id)sender;
- (IBAction)startRecording:(id)sender;
- (IBAction)startPlaying:(id)sender;
- (IBAction)stopPlaying:(id)sender;

// Audio Recorder Variables
@property(nonatomic,strong) AVAudioRecorder *recorder;
@property(nonatomic,strong) NSMutableDictionary *recorderSettings;
@property(nonatomic,strong) NSString *recorderFilePath;
@property(nonatomic,strong) AVAudioPlayer *audioPlayer;
@property(nonatomic,strong) NSString *audioFileName;


@end

