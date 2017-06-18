//
//  StoryPartViewController.m
//  AVStoryBook
//
//  Created by Jimmy Hoang on 2017-06-16.
//  Copyright © 2017 Jimmy Hoang. All rights reserved.
//

#import "StoryPartViewController.h"
@import AVFoundation;

@interface StoryPartViewController () <AVAudioRecorderDelegate, AVAudioPlayerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) AVAudioPlayer* audioPlayer;
@property (nonatomic, strong) AVAudioRecorder* audioRecorder;
@property (nonatomic, strong) UIImagePickerController* imagePicker;
@property (weak, nonatomic) IBOutlet UIButton *recordButton;

@end

@implementation StoryPartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Allocating storybook
    self.storyPage = [[StoryBook alloc] init];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self setupAudioRecorder];
    [self setupImagePicker];
    self.imageView.image = self.storyPage.image;
    NSLog(@"im page #%d",self.pageNumber);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Helpers
-(void)setupImagePicker {
    self.imagePicker = [[UIImagePickerController alloc] init];
    self.imagePicker.delegate = self;
}

-(void)setupAudioRecorder {
    NSError* error = nil;
    NSString* filePath = @"recording.caf";
    self.storyPage.recordingURL = [NSURL fileURLWithPath:filePath];
    
    // Setup audio session
    AVAudioSession* session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    
    // Define the recorder setting
    NSMutableDictionary* recordSettings = [[NSMutableDictionary alloc] init];
    
    [self.audioRecorder setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    [self.audioRecorder setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
    [self.audioRecorder setValue:[NSNumber numberWithInt: 2] forKey:AVNumberOfChannelsKey];
    
    // Initiate and prepare the recorder
    self.audioRecorder = [[AVAudioRecorder alloc] initWithURL:self.storyPage.recordingURL settings:recordSettings error:&error];
    
    if (error) {
        NSLog(@"recorder error: %@",error.localizedDescription);
    }
    self.audioRecorder.delegate = self;
    self.audioRecorder.meteringEnabled = YES;
    [self.audioRecorder prepareToRecord];
}

-(void)setupAudioPlayer {
    NSError* error = nil;
    
    // Setup audio player
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:self.audioRecorder.url error:&error];
    
    if (error) {
        NSLog(@"player error: %@",error.localizedDescription);
    }
    self.audioPlayer.delegate = self;
}

#pragma mark - Button Actions
- (IBAction)cameraButton:(id)sender {
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:self.imagePicker animated:YES completion:nil];
}

- (IBAction)libraryButton:(id)sender {
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:self.imagePicker animated:YES completion:nil];
}

- (IBAction)recordButton:(id)sender {
    // If audio is playing, stop it before recording
    if (self.audioPlayer.playing) {
       NSLog(@"audio player is playing");
        [self.audioPlayer stop];
    }
    
    if (!self.audioRecorder.recording) {
        // Start the recording
        NSLog(@"started recording");
        AVAudioSession* session = [AVAudioSession sharedInstance];
        [session setActive:YES error:nil];
        [self.audioRecorder record];
        self.recordButton.titleLabel.text = @"Stop";
        [self setupAudioPlayer];
    
    } else {
        NSLog(@"stopped recording");
        AVAudioSession* session = [AVAudioSession sharedInstance];
        [session setActive:NO error:nil];
        [self.audioRecorder stop];
        self.recordButton.titleLabel.text = @"Record";
    }
}
- (IBAction)imageTapped:(UITapGestureRecognizer*)sender {
    [self.audioPlayer prepareToPlay];
    NSLog(@"playing audio");
    AVAudioSession* session = [AVAudioSession sharedInstance];
    [session setActive:YES error:nil];
    [self.audioPlayer play];
}

#pragma mark - Image Picker Delegates
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage* selectedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    self.storyPage.image = selectedImage;
    self.imageView.image = selectedImage;
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end

