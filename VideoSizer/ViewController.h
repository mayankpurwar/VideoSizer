//
//  ViewController.h
//  VideoSizer
//
//  Created by Apple on 7/3/15.
//  Copyright (c) 2015 Apple. All rights reserved.
//

#import "AppDelegate.h"
#import <UIKit/UIKit.h>
#import <CoreMedia/CoreMedia.h>
#import <AVFoundation/AVFoundation.h>
#import "MoreViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>


#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>

#define CAPTURE_FRAMES_PER_SECOND		20

#import <MediaPlayer/MediaPlayer.h>

//@class RBVolumeButtons;











@interface ViewController : UIViewController<AVCaptureFileOutputRecordingDelegate,UIGestureRecognizerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>{
    BOOL WeAreRecording;
    
    IBOutlet UIImageView *imgviewBlink, *imgviewBottomBar,*imgviewGridLines, *imgviewSetting,*imgviewshutterLeft,*imgviewshutterRight;
    IBOutlet UIView *viewSettings;
    IBOutlet UILabel *lblSavingText, *lblRecordingTime;
    IBOutlet UIButton *btnSwitchCamera, *btnStartStop, *btnMoreInfo,*btnSettings,*btnTorch;
    IBOutlet UIButton *btnPresetQuality1,*btnPresetQuality2,*btnPresetQuality3,*btnPresetQuality4,*btnGridLines;
    bool isDisplayedMoreOptions,isSettingsVisible;
    
    int time, blinkCount;
    
    UIDeviceOrientation orientationDevice;
    NSString *deviceString;
    
    BOOL isShowingGridLines;
   	
    
    BOOL isTorchAvailable;
    BOOL isTorchON;
    int showhide_buttons_flag;
    int formatType;
    
//    NSArray *presetArr;
    
    IBOutlet UIView *cameraViewLayer;
    
    IBOutlet NSLayoutConstraint *SpacebetwwenShutters;
    IBOutlet NSLayoutConstraint *TrailSpaceSettings;
    
    CGFloat rotateValue;
    
    
    
    IBOutlet UIView *topView;
    
    IBOutlet UIButton *btnCameraRoll;
    
    
    int deviceWidth,deviceHeight;
}



@property (retain)AVCaptureMovieFileOutput *MovieFileOutput;
@property (retain)AVCaptureDeviceInput *VideoInputDevice;
@property (retain)AVCaptureSession *CaptureSession;
@property (retain) AVCaptureVideoPreviewLayer *PreviewLayer;
@property (nonatomic) BOOL isTorchON;
@property (nonatomic) BOOL isTorchAvailable;
@property (nonatomic, retain) AVCaptureDevice *bCaptureDevice;
// Custom functions
//- (void) CameraSetOutputProperties;
- (AVCaptureDevice *) CameraWithPosition:(AVCaptureDevicePosition) Position;
- (IBAction)StartStopButtonPressed:(id)sender;
- (IBAction)CameraToggleButtonPressed:(id)sender;
//-(IBAction)Click_btnPresetQuality1:(id)sender;
//-(IBAction)Click_btnPresetQuality2:(id)sender;
//-(IBAction)Click_btnPresetQuality3:(id)sender;
//-(IBAction)Click_btnPresetQuality4:(id)sender;
//-(IBAction)Click_btnSettings:(id)sender;
-(IBAction)Click_btnTorch:(id)sender;
-(IBAction)ValueChanged_Switch:(id)sender;
-(void)setPreviewSessionPreset:(NSString*) AVCaptureSessionPresetType;

//- (void)handleDoubleTap:(UITapGestureRecognizer *)gesture;

-(void)startRecordingTimer;
-(void)stopRecordingTimer;

- (void) setDeviceString;

- (void) showSettings;
- (void) hideSettings;

-(void)closeShutter;
-(void)showShutter;
-(void)setSelectedImage;
-(void)showHideButtons;
//-(void)setPresetInTimer;
-(void)enableDisableControlsOnRecording:(int)type;
-(void)saveMovieToCameraRoll;
-(void)errorRecordingMessage;
-(void)checkCameraPermission;
-(AVCaptureVideoOrientation)getVideoOrientation;
-(void)toggleCameraSwitch;
-(void)resetSettingsControls;
-(void)pauseVideoRecording;
-(void)resumeVideoRecording;
-(void)stopVideoRecording;


-(void)SetCameraGridandPreset;
- (void)orientationChanged:(NSNotification *)notification;


-(void)SettingsChanged;

@end

