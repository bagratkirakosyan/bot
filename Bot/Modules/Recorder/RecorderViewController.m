//
//  RecorderViewController.m
//  Bot
//
//  Created by Bagrat Kirakosian on 10/28/16.
//  Copyright © 2016 PicsArt. All rights reserved.
//

#import "RecorderViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "Networking.h"
#import "EZRecorder.h"
#import "EZMicrophone.h"
#import <CoreAudio/CoreAudioTypes.h>

@interface RecorderViewController () <EZMicrophoneDelegate, EZRecorderDelegate>

@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIButton *stopButton;
@property (weak, nonatomic) IBOutlet UIButton *recordButton;


@property (nonatomic) EZMicrophone *microphone;
@property (nonatomic) EZRecorder *recorder;

@end

@implementation RecorderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    // Disable Stop/Play button when application launches
//    [self.stopButton setEnabled:NO];
//    [self.playButton setEnabled:NO];
//    
//    // Set the audio file
//    NSArray *pathComponents = [NSArray arrayWithObjects:
//                               [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],
//                               @"bot",
//                               nil];
//    NSURL *outputFileURL = [NSURL fileURLWithPathComponents:pathComponents];
//
//    // Setup audio session
//    AVAudioSession *session = [AVAudioSession sharedInstance];
//    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
//    
//    // Define the recorder setting
//    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
//    
//    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
//    [recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
//    [recordSetting setValue:[NSNumber numberWithInt: 2] forKey:AVNumberOfChannelsKey];
//    
//    // Initiate and prepare the recorder
//    recorder = [[AVAudioRecorder alloc] initWithURL:outputFileURL settings:recordSetting error:NULL];
//    recorder.delegate = self;
//    recorder.meteringEnabled = YES;
//    [recorder prepareToRecord];
    
    
//    AudioFileCreateWithURL (
//                            outputFileURL,
//                            kAudioFileWAVEType,
//                            &audioFormat,
//                            kAudioFileFlags_EraseFile,
//                            &audioFileID
//                            );
    
//    
//    self.recorder = [EZRecorder recorderWithURL:outputFileURL
//                                   clientFormat:mSampleRate
//                                       fileType:EZRecorderFileTypeWAV];

    
    
    
    
    
    
    
    
//    self.microphone = [EZMicrophone microphoneWithDelegate:self];
//    
//    self.recorder = [EZRecorder recorderWithURL:outputFileURL
//                                   clientFormat:[self.microphone audioStreamBasicDescription]
//                                       fileType:EZRecorderFileTypeWAV
//                                       delegate:self];
//    
//    [self.microphone startFetchingAudio];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)recordPauseTapped:(id)sender {
    
    
    [self.recorder closeAudioFile];
    
//    // Stop the audio player before recording
//    if (player.playing) {
//        [player stop];
//    }
//    
//    if (!recorder.recording) {
//        AVAudioSession *session = [AVAudioSession sharedInstance];
//        [session setActive:YES error:nil];
//        
//        // Start recording
//        [recorder record];
//        [self.recordButton setTitle:@"Pause" forState:UIControlStateNormal];
//        
//    } else {
//        
//        // Pause recording
//        [recorder pause];
//        [self.recordButton setTitle:@"Record" forState:UIControlStateNormal];
//    }
//    
//    [self.stopButton setEnabled:YES];
//    [self.playButton setEnabled:NO];
}





//
//- (IBAction)stopTapped:(id)sender {
//    [recorder stop];
//
//    
////    NSString *str=[[NSBundle mainBundle] pathForResource:@"bot" ofType:@"m4a"];
////    NSData *fileData = [NSData dataWithContentsOfFile:str];
////    
////    [[Networking sharedInstance] auth:nil withCompletion:^(BOOL success, NSString *result) {
////        [[Networking sharedInstance] analyzeAudio:fileData withCompletion:^(BOOL success, NSDictionary *result) {
////            
////        }];
////    }];
//    
//    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
//    [audioSession setActive:NO error:nil];
//}
//
//- (IBAction)playTapped:(id)sender {
//    if (!recorder.recording){
//        player = [[AVAudioPlayer alloc] initWithContentsOfURL:recorder.url error:nil];
//        [player setDelegate:self];
//        [player play];
//    }
//}
//
//
//
//- (void) audioRecorderDidFinishRecording:(AVAudioRecorder *)avrecorder successfully:(BOOL)flag{
//    [self.recordButton setTitle:@"Record" forState:UIControlStateNormal];
//    
//    [self.stopButton setEnabled:NO];
//    [self.playButton setEnabled:YES];
//}
//
//
//
//- (void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Done"
//                                                    message: @"Finish playing the recording!"
//                                                   delegate: nil
//                                          cancelButtonTitle:@"OK"
//                                          otherButtonTitles:nil];
//    [alert show];
//}

@end
