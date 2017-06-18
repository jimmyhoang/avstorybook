//
//  StoryPartViewController.m
//  AVStoryBook
//
//  Created by Jimmy Hoang on 2017-06-16.
//  Copyright © 2017 Jimmy Hoang. All rights reserved.
//

#import "StoryPartViewController.h"
#import "StoryBook.h"
@import AVFoundation;

@interface StoryPartViewController () <AVAudioRecorderDelegate, AVAudioPlayerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) AVAudioPlayer* audioPlayer;
@property (nonatomic, strong) AVAudioRecorder* audioRecorder;
@property (nonatomic, strong) StoryBook* storyBook;

@end

@implementation StoryPartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Setup audio session
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    
    // Define the recorder setting
    NSMutableDictionary *recordSettings = [[NSMutableDictionary alloc] init];
    
    [self.audioRecorder  setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    [self.audioRecorder  setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
    [self.audioRecorder  setValue:[NSNumber numberWithInt: 2] forKey:AVNumberOfChannelsKey];
    
    // Initiate and prepare the recorder
    self.audioRecorder = [[AVAudioRecorder alloc] initWithURL:self.storyBook.recordingURL settings:recordSettings error:NULL];
    self.audioRecorder .delegate = self;
    self.audioRecorder .meteringEnabled = YES;
    [self.audioRecorder  prepareToRecord];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (IBAction)cameraButton:(id)sender {
}
- (IBAction)recordButton:(id)sender {
}
- (IBAction)imageTapped:(UITapGestureRecognizer*)sender {
}

@end

