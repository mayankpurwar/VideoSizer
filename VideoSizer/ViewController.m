//
//  ViewController.m
//  VideoSizer
//
//  Created by Apple on 7/3/15.
//  Copyright (c) 2015 Apple. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController






@synthesize PreviewLayer,isTorchAvailable,isTorchON,bCaptureDevice,CaptureSession,VideoInputDevice,MovieFileOutput;

-(void)showHideButtons{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    if(showhide_buttons_flag==1){
        showhide_buttons_flag=0;
        btnSwitchCamera.alpha=1;
        btnSettings.alpha=1;
        btnMoreInfo.alpha=1;
        btnTorch.alpha=1;
        btnStartStop.alpha=1;
        imgviewBottomBar.alpha=1;
        viewSettings.alpha=1;
    }else{
        showhide_buttons_flag=1;
        btnSwitchCamera.alpha=0;
        btnSettings.alpha=0;
        btnMoreInfo.alpha=0;
        btnTorch.alpha=0;
        btnStartStop.alpha=0;
        imgviewBottomBar.alpha=0;
        viewSettings.alpha=0;
    }
    [UIView commitAnimations];
}
//********** VIEW DID LOAD **********
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    deviceWidth = self.view.frame.size.width;
    deviceHeight = self.view.frame.size.height;
    
    
    [self.view layoutIfNeeded];
    
    NSLog(@"didload");
    [self StartCheckingdeviceRotation];
    
    
    self.navigationController.navigationBarHidden = YES;
    
    
    isShowingGridLines=NO;
    [btnGridLines setImage:[UIImage imageNamed:@"Gird.png"] forState:UIControlStateNormal];
    
    imgviewSetting.layer.cornerRadius = 9.0;
    
    btnSettings.enabled=YES;
    if([bCaptureDevice isTorchAvailable]){
        btnTorch.enabled=YES;
    }else{
        btnTorch.enabled=NO;
    }
    //---------------------------------
    //----- SETUP CAPTURE SESSION -----
    //---------------------------------
    [self setDeviceString];
    [self enableDeviceSupportedControls];
    showhide_buttons_flag=1;// show controls
    [self showHideButtons];
    NSLog(@"Setting up capture session");
    imgviewBlink.hidden=YES;
//    lblRecordingTime.hidden=YES;
    CaptureSession = [[AVCaptureSession alloc] init];
    isDisplayedMoreOptions=NO;
    isSettingsVisible=NO;
    
    SpacebetwwenShutters.constant = self.view.frame.size.height;

    
    //----- ADD INPUTS -----
    NSLog(@"Adding video input");
    
    //ADD VIDEO INPUT
    bCaptureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    isTorchAvailable = [bCaptureDevice hasTorch];
    [btnTorch setImage:[UIImage imageNamed:@"tarch-off.png"] forState:UIControlStateNormal];
    [btnTorch setEnabled:isTorchAvailable];
    /*if(isTorchAvailable)
     [[self torchImage ] setImage:[UIImage imageNamed:@"lightbulb.png"] forState:UIControlStateNormal];*/
    
    isTorchON = NO;
    if (bCaptureDevice){
        NSError *error;
        VideoInputDevice = [AVCaptureDeviceInput deviceInputWithDevice:bCaptureDevice error:&error];
        if (!error)
        {
            if ([CaptureSession canAddInput:VideoInputDevice])
                [CaptureSession addInput:VideoInputDevice];
            else
                NSLog(@"Couldn't add video input");
        }
        else
        {
            NSLog(@"Couldn't create video input");
        }
    }
    else
    {
        NSLog(@"Couldn't create video capture device");
    }
    
    //ADD AUDIO INPUT
    NSLog(@"Adding audio input");
    AVCaptureDevice *audioCaptureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
    NSError *error = nil;
    AVCaptureDeviceInput *audioInput = [AVCaptureDeviceInput deviceInputWithDevice:audioCaptureDevice error:&error];
    if (audioInput)
    {
        [CaptureSession addInput:audioInput];
    }
    
    //----- ADD OUTPUTS -----
    
    //ADD VIDEO PREVIEW LAYER
    NSLog(@"Adding video preview layer");
    [self setPreviewLayer:[[AVCaptureVideoPreviewLayer alloc] initWithSession:CaptureSession]];
    
//    PreviewLayer.orientation = [self getVideoOrientation];//AVCaptureVideoOrientationLandscapeRight;
    [PreviewLayer connection].videoOrientation = [self getVideoOrientation];
    
    
    //<<SET ORIENTATION.  You can deliberatly set this wrong to flip the image and may actually need to set it wrong to get the right image
    
    [[self PreviewLayer] setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    
    //ADD MOVIE FILE OUTPUT
    NSLog(@"Adding movie file output");
    MovieFileOutput = [[AVCaptureMovieFileOutput alloc] init];
    
    Float64 TotalSeconds = 3600;			//Total seconds
    int32_t preferredTimeScale = 30;	//Frames per second
    CMTime maxDuration = CMTimeMakeWithSeconds(TotalSeconds, preferredTimeScale);	//<<SET MAX DURATION
    MovieFileOutput.maxRecordedDuration = maxDuration;
    
    MovieFileOutput.minFreeDiskSpaceLimit = 1024 * 1024;						//<<SET MIN FREE SPACE IN BYTES FOR RECORDING TO CONTINUE ON A VOLUME
    
    if ([CaptureSession canAddOutput:MovieFileOutput])
        [CaptureSession addOutput:MovieFileOutput];
    
    //SET THE CONNECTION PROPERTIES (output properties)
//    [self CameraSetOutputProperties];			//(We call a method as it also has to be done after changing camera)
    
    
    //----- SET THE IMAGE QUALITY / RESOLUTION -----
    //Options:
    //	AVCaptureSessionPresetHigh - Highest recording quality (varies per device)
    //	AVCaptureSessionPresetMedium - Suitable for WiFi sharing (actual values may change)
    //	AVCaptureSessionPresetLow - Suitable for 3G sharing (actual values may change)
    //	togg - 640x480 VGA (check its supported before setting it)
    //	AVCaptureSessionPreset1280x720 - 1280x720 720p HD (check its supported before setting it)
    //	AVCaptureSessionPresetPhoto - Full photo resolution (not supported for video output)
    NSLog(@"Setting image quality");
    /*[CaptureSession setSessionPreset:AVCaptureSessionPresetMedium];
     if ([CaptureSession canSetSessionPreset:AVCaptureSessionPreset640x480])		//Check size based configs are supported before setting them
     [CaptureSession setSessionPreset:AVCaptureSessionPreset640x480];*/
//    [self setPreviewSessionPreset:AVCaptureSessionPreset640x480];
    
    //----- DISPLAY THE PREVIEW LAYER -----
    //Display it full screen under out view controller existing controls
    NSLog(@"Display the preview layer");
    CGRect layerRect = [[[self view] layer] bounds];
    [PreviewLayer setBounds:layerRect];
    [PreviewLayer setPosition:CGPointMake(CGRectGetMidX(layerRect),
                                          CGRectGetMidY(layerRect))];
    //[[[self view] layer] addSublayer:[[self CaptureManager] previewLayer]];
    //We use this instead so it goes on a layer behind our UI controls (avoids us having to manually bring each control to the front):
    
    UIView *CameraView = [[UIView alloc] init];
    [cameraViewLayer addSubview:CameraView];
    [cameraViewLayer sendSubviewToBack:CameraView];
    
    [[CameraView layer] addSublayer:PreviewLayer];
    
    UITapGestureRecognizer *singleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
//     singleTapGesture.numberOfTapsRequired = 1;
     [cameraViewLayer addGestureRecognizer:singleTapGesture];
//     singleTapGesture.enabled = true;
//     singleTapGesture.delegate = self;
    
    
    
    
  // UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
  // [cameraViewLayer addGestureRecognizer:tapGesture1];
    
    
    
    //----- START THE CAPTURE SESSION RUNNING -----
    [CaptureSession startRunning];

    
    [[NSUserDefaults standardUserDefaults] setObject:@"3" forKey:@"RES_VALUE"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self setSelectedImage];
    
    [self getListofAllPreset];

}





//********** VIEW WILL APPEAR **********
//View about to be added to the window (called each time it appears)
//Occurs after other view's viewWillDisappear
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    WeAreRecording = NO;
    NSLog(@"%@",NSStringFromCGRect(self.view.frame));
}



- (void)handleSingleTap:(UITapGestureRecognizer *)gesture
{
    UIEvent *event = [[UIEvent alloc] init];
    CGPoint location = [gesture locationInView:self.view];
    
    //check actually view you hit via hitTest
    UIView *view = [self.view hitTest:location withEvent:event];
    
    if ([view.gestureRecognizers containsObject:gesture])
    {
        NSLog(@"Mayank");
        CGPoint pt = [gesture locationInView:self.view];
        UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"focus.png"]]; //****//
        iv.center = pt;
        [self.view addSubview:iv];
        
        CABasicAnimation* blink = [CABasicAnimation animationWithKeyPath:@"opacity"];
        blink.fromValue = [NSNumber numberWithDouble:1.0];
        blink.toValue = [NSNumber numberWithDouble:0.];
        
        blink.duration = 0.5;
        blink.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        blink.autoreverses = YES;
        blink.repeatCount = UINT32_MAX;
        
        [iv.layer addAnimation:blink forKey:@"blink"];
        [self performSelector:@selector(removeCrosshair:) withObject:iv afterDelay:0.8];
        pt = CGPointMake(pt.y/self.view.frame.size.height, pt.x/self.view.frame.size.width);
        [self updateExposure:pt mode:AVCaptureExposureModeContinuousAutoExposure];
        [self updateFocus:pt mode:AVCaptureFocusModeContinuousAutoFocus];
    }
    else
    {
        NSLog(@"Purwar");
    }
}

-(void) removeCrosshair:(UIImageView*)iv
{
    [iv removeFromSuperview];
}

- (void) updateExposure:(CGPoint)pt mode:(AVCaptureExposureMode)mode
{
    NSLog(@"In Update Exposure");
    if ([bCaptureDevice isExposurePointOfInterestSupported] && [bCaptureDevice isExposureModeSupported:mode]) {
        NSLog(@"Supported Exposure");
        if ([bCaptureDevice lockForConfiguration:nil]) {
            [bCaptureDevice setExposurePointOfInterest:pt];
            [bCaptureDevice setExposureMode:mode];
            [bCaptureDevice unlockForConfiguration];
        }
    }
}

- (void) updateFocus:(CGPoint)pt mode:(AVCaptureFocusMode)mode
{
    NSLog(@"In Update Focus");
    if ([bCaptureDevice isFocusPointOfInterestSupported] && [bCaptureDevice isFocusModeSupported:mode]) {
        NSLog(@"Supported Focus");
        [bCaptureDevice lockForConfiguration:nil];
        [bCaptureDevice setFocusPointOfInterest:pt];
        [bCaptureDevice setFocusMode:mode];
        [bCaptureDevice unlockForConfiguration];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    NSLog(@"should auto1");
    return YES;
    return (interfaceOrientation == UIDeviceOrientationPortrait);
}

- (NSUInteger)supportedInterfaceOrientations {
    
    return UIInterfaceOrientationMaskPortrait;// | UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight;
}

- (void)orientationChanged:(NSNotification *)notification
{
    int x = 0;
    int y = 0;
    rotateValue = rotateValue+(-rotateValue);
    [self RotateObject:rotateValue withXpos:x withYpos:y];
    
    switch ([UIDevice currentDevice].orientation) {
        case UIDeviceOrientationPortrait:
            rotateValue += 0;
            break;
        case UIDeviceOrientationLandscapeLeft:
            rotateValue +=M_PI/2;
            NSLog(@"%@",NSStringFromCGRect(self.view.frame));
            x = deviceWidth-topView.frame.size.height;
            y = (deviceHeight-72-topView.frame.size.width)/2;
            break;
        case UIDeviceOrientationLandscapeRight:
            rotateValue +=(-M_PI/2);
            x = 0;
            y = (deviceHeight-72-topView.frame.size.width)/2;
            
            break;
        case UIDeviceOrientationPortraitUpsideDown:
            break;
        default:
            break;
    }
    
    [self RotateObject:rotateValue withXpos:x withYpos:y];
}


-(void)RotateObject:(CGFloat)rotation withXpos:(int)x withYpos:(int)y
{
    if([[UIDevice currentDevice].systemVersion floatValue]<8.0)
        [topView setTranslatesAutoresizingMaskIntoConstraints:YES];
    topView.transform = CGAffineTransformMakeRotation(rotateValue);
    topView.frame = CGRectMake(x,y, topView.frame.size.width, topView.frame.size.height);
    
    btnMoreInfo.transform = CGAffineTransformMakeRotation(rotateValue);
    btnCameraRoll.transform = CGAffineTransformMakeRotation(rotateValue);
    btnStartStop.transform = CGAffineTransformMakeRotation(rotateValue);
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

- (BOOL) shouldAutorotate
{
    return NO;
}

- (void) showSettings{
    TrailSpaceSettings.constant = 0;
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void) hideSettings{
    TrailSpaceSettings.constant = -53;
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
    }];
}

-(void)closeShutter{
    if([bCaptureDevice isTorchAvailable]){
        isTorchON=YES;
        [self Click_btnTorch:Nil];
    }
    SpacebetwwenShutters.constant = self.view.frame.size.width;
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
    }];
}

-(void)showShutter{
    SpacebetwwenShutters.constant = -40;
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
    }];
}

-(IBAction)Click_btnSettings:(id)sender{
    NSLog(@"settings clicked");
    viewSettings.alpha=1;
    if(isSettingsVisible==YES)
    {
        isSettingsVisible=NO;
        [self hideSettings];
    }
    else
    {
        isSettingsVisible=YES;
        [self showSettings];
    }
}

-(IBAction)Click_btnMore:(id)sender
{
//    [self orientationChanged:nil];
    [self StopCheckingdeviceRotation];
    
//    self.navigationController.navigationBar.hidden = NO;
    MoreViewController *more = [self.storyboard instantiateViewControllerWithIdentifier:@"MoreViewController"];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:more];
    [self presentViewController:nav animated:YES completion:nil];
}

-(IBAction)Click_btnTorch:(id)sender{
    if (isTorchON) {
        [btnTorch setImage:[UIImage imageNamed:@"tarch-off.png"] forState:UIControlStateNormal];
        [bCaptureDevice lockForConfiguration:nil];
        [bCaptureDevice setTorchMode:AVCaptureTorchModeOff];
        [bCaptureDevice unlockForConfiguration];
        isTorchON = NO;
    }
    else {
        [btnTorch setImage:[UIImage imageNamed:@"tarch-on.png"] forState:UIControlStateNormal];
        [bCaptureDevice lockForConfiguration:nil];
        [bCaptureDevice setTorchMode:AVCaptureTorchModeOn];
        [bCaptureDevice unlockForConfiguration];
        isTorchON = YES;
    }
}

-(IBAction)ValueChanged_Switch:(id)sender{
    if(isShowingGridLines==NO){
        isShowingGridLines=YES;
        imgviewGridLines.hidden=NO;
        [btnGridLines setImage:[UIImage imageNamed:@"Gird-selected.png"] forState:UIControlStateNormal];
    }else{
        isShowingGridLines=NO;
        imgviewGridLines.hidden=YES;
        [btnGridLines setImage:[UIImage imageNamed:@"Gird.png"] forState:UIControlStateNormal];
    }
}

-(void)setPreviewSessionPreset:(NSString*)AVCaptureSessionPresetType{
//    isDisplayedMoreOptions=NO;
//    viewSettings.hidden=NO;
//    NSLog(@"AVCaptureSessionPresetType:%@",AVCaptureSessionPresetType);
//    //[CaptureSession setSessionPreset:AVCaptureSessionPresetMedium];
//    if ([CaptureSession canSetSessionPreset:AVCaptureSessionPresetType])		//Check size based configs are supported before setting them
//    {
//        NSLog(@"Setting AVCaptureSessionPresetType");
//        [CaptureSession stopRunning];
//        [CaptureSession setSessionPreset:AVCaptureSessionPresetType];
//        [CaptureSession startRunning];
//    }
}



//********** CAMERA SET OUTPUT PROPERTIES **********
//- (void) CameraSetOutputProperties{

    //SET THE CONNECTION PROPERTIES (output properties)
//    AVCaptureConnection *CaptureConnection = [MovieFileOutput connectionWithMediaType:AVMediaTypeVideo];
    

//
//    //Set landscape (if required)
//    if ([CaptureConnection isVideoOrientationSupported])
//    {
//        //AVCaptureVideoOrientation orientation = AVCaptureVideoOrientationLandscapeRight;		//<<<<<SET VIDEO ORIENTATION IF LANDSCAPE
//        [CaptureConnection setVideoOrientation:[self getVideoOrientation]];
//    }
//    
//    //Set frame rate (if requried)
//    CMTimeShow(CaptureConnection.videoMinFrameDuration);
//    CMTimeShow(CaptureConnection.videoMaxFrameDuration);
//    
//    if (CaptureConnection.supportsVideoMinFrameDuration)
//        CaptureConnection.videoMinFrameDuration = CMTimeMake(1, CAPTURE_FRAMES_PER_SECOND);
//    if (CaptureConnection.supportsVideoMaxFrameDuration)
//        CaptureConnection.videoMaxFrameDuration = CMTimeMake(1, CAPTURE_FRAMES_PER_SECOND);
//    
//    CMTimeShow(CaptureConnection.videoMinFrameDuration);
//    CMTimeShow(CaptureConnection.videoMaxFrameDuration);
//}

//********** GET CAMERA IN SPECIFIED POSITION IF IT EXISTS **********
- (AVCaptureDevice *) CameraWithPosition:(AVCaptureDevicePosition) Position
{
    NSArray *Devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *Device in Devices)
    {
        if ([Device position] == Position)
        {
            return Device;
        }
    }
    return nil;
}

//********** CAMERA TOGGLE **********
- (IBAction)CameraToggleButtonPressed:(id)sender
{
    if ([[AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo] count] > 1)		//Only do if device has multiple cameras
    {
        isSettingsVisible=NO;
        [self hideSettings];
        [self showShutter];
        NSLog(@"Toggle camera");
        [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(toggleCameraSwitch) userInfo:nil repeats:NO];
    }
}

-(void)toggleCameraSwitch{
    NSError *error;
    //AVCaptureDeviceInput *videoInput = [self videoInput];
    AVCaptureDeviceInput *NewVideoInput;
    AVCaptureDevicePosition position = [[VideoInputDevice device] position];
    if (position == AVCaptureDevicePositionBack)
    {
//        [self setPreviewSessionPreset:AVCaptureSessionPreset640x480];
        btnSettings.enabled=NO;
        btnTorch.enabled=NO;
//        [btnSwitchCamera setTitle:@"Front Cam" forState:UIControlStateNormal];
        bCaptureDevice = [self CameraWithPosition:AVCaptureDevicePositionFront];
        NewVideoInput = [[AVCaptureDeviceInput alloc] initWithDevice:bCaptureDevice error:&error];
    }
    else if (position == AVCaptureDevicePositionFront)
    {
        btnSettings.enabled=YES;
        if([bCaptureDevice isTorchAvailable]){
            btnTorch.enabled=YES;
        }else{
            btnTorch.enabled=NO;
        }
      //  [btnSwitchCamera setTitle:@"Back Cam" forState:UIControlStateNormal];
        bCaptureDevice = [self CameraWithPosition:AVCaptureDevicePositionBack];
        NewVideoInput = [[AVCaptureDeviceInput alloc] initWithDevice:bCaptureDevice error:&error];
    }else{
        btnSettings.enabled=YES;
        if([bCaptureDevice isTorchAvailable]){
            btnTorch.enabled=YES;
        }else{
            btnTorch.enabled=NO;
        }
     //   [btnSwitchCamera setTitle:@"Back Cam" forState:UIControlStateNormal];
        bCaptureDevice = [self CameraWithPosition:AVCaptureDevicePositionBack];
        NewVideoInput = [[AVCaptureDeviceInput alloc] initWithDevice:bCaptureDevice error:&error];
    }
    
    if (NewVideoInput != nil)
    {
        [CaptureSession beginConfiguration];		//We can now change the inputs and output configuration.  Use commitConfiguration to end
        [CaptureSession removeInput:VideoInputDevice];
        if ([CaptureSession canAddInput:NewVideoInput])
        {
            [CaptureSession addInput:NewVideoInput];
            VideoInputDevice = NewVideoInput;
        }
        else
        {
            [self.CaptureSession addInput:self.VideoInputDevice];
        }
        
        [self getListofAllPreset];
        //Set the connection properties again
//        [self CameraSetOutputProperties];
        
        [CaptureSession commitConfiguration];
    }
    [self closeShutter];
}

-(void)pauseVideoRecording{
    
}

-(void)resumeVideoRecording{
    
}

-(void)stopVideoRecording{
    [self enableDisableControlsOnRecording:2];
    //----- STOP RECORDING -----
    NSLog(@"STOP RECORDING");
//    lblRecordingTime.hidden=YES;
    [btnStartStop setImage:[UIImage imageNamed:@"stoped_rec"] forState:UIControlStateNormal];
    [btnStartStop setTitle:@"" forState:UIControlStateNormal];
    WeAreRecording = NO;
    imgviewBlink.hidden=YES;
    [MovieFileOutput stopRecording];
}

//********** START STOP RECORDING BUTTON **********
- (IBAction)StartStopButtonPressed:(id)sender
{
    if (!WeAreRecording)
    {
        isSettingsVisible=NO;
        [self hideSettings];
//        [self CameraSetOutputProperties];
        [self checkCameraPermission];
        [self enableDisableControlsOnRecording:1];
        //----- START RECORDING -----
        //PreviewLayer.orientation = AVCaptureVideoOrientationLandscapeLeft;
        NSLog(@"START RECORDING");
//        lblRecordingTime.hidden=NO;
        [btnStartStop setImage:[UIImage imageNamed:@"started_rec"] forState:UIControlStateNormal];
        WeAreRecording = YES;
        [btnStartStop setTitle:@"" forState:UIControlStateNormal];
        time=0;
        blinkCount=0;
        imgviewBlink.hidden=NO;
        
        [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(startRecordingTimer) userInfo:nil repeats:NO];
        [NSTimer scheduledTimerWithTimeInterval:0.3f target:self selector:@selector(blinkTimer) userInfo:nil repeats:NO];
        //Create temporary URL to record to
        NSString *outputPath = [[NSString alloc] initWithFormat:@"%@%@", NSTemporaryDirectory(), @"output.mov"];
        NSURL *outputURL = [[NSURL alloc] initFileURLWithPath:outputPath];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:outputPath])
        {
            NSError *error;
            if ([fileManager removeItemAtPath:outputPath error:&error] == NO)
            {
                //Error - handle if requried
            }
        }
        //Start recording
        [MovieFileOutput startRecordingToOutputFileURL:outputURL recordingDelegate:self];
    }
    else
    {
        [self enableDisableControlsOnRecording:2];
        //----- STOP RECORDING -----
        NSLog(@"STOP RECORDING");
//        lblRecordingTime.hidden=YES;
        [btnStartStop setImage:[UIImage imageNamed:@"stoped_rec"] forState:UIControlStateNormal];
        [btnStartStop setTitle:@"" forState:UIControlStateNormal];
        WeAreRecording = NO;
        imgviewBlink.hidden=YES;
        [MovieFileOutput stopRecording];
        
        /*UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Save Video" message:@"Do you want to save video to camera roll?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
         alert.tag = 100;
         [alert show];
         [alert release];*/
    }
}

-(void)errorRecordingMessage{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Video can not be save :(" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    alert.tag = 100;
    [alert show];
}
-(void)startRecordingTimer{
    //NSLog(@"time:%d",time);
    if(WeAreRecording==YES){
        imgviewBlink.hidden=NO;
        time=time+1;
        
        int TOtMinute = time/60;
        
        int hours = TOtMinute/60;
        int minute = TOtMinute%60;
        
        
        
        lblRecordingTime.text=[NSString stringWithFormat:@"%02d:%02d:%02d",hours,minute,time%60];
        [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(startRecordingTimer) userInfo:nil repeats:NO];
    }else{
        lblRecordingTime.text=@"00:00:00";
        imgviewBlink.hidden=YES;
    }
}

-(void)blinkTimer{
    //NSLog(@"blink:%d",blinkCount);
    if(WeAreRecording==YES){
        if(blinkCount%2==0){
            imgviewBlink.hidden=YES;
        }else{
            imgviewBlink.hidden=NO;
        }
        blinkCount++;
        [NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(blinkTimer) userInfo:nil repeats:NO];
    }
}
-(void)stopRecordingTimer{
    
}

//********** DID FINISH RECORDING TO OUTPUT FILE AT URL **********
- (void)captureOutput:(AVCaptureFileOutput *)captureOutput
didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL
      fromConnections:(NSArray *)connections
                error:(NSError *)error{
    NSLog(@"didFinishRecordingToOutputFileAtURL - enter");
    BOOL RecordedSuccessfully = YES;
    if ([error code] != noErr){
        // A problem occurred: Find out if the recording was successful.
        id value = [[error userInfo] objectForKey:AVErrorRecordingSuccessfullyFinishedKey];
        if (value)
        {
            RecordedSuccessfully = [value boolValue];
        }
    }else{
        NSLog(@"Recorded success fully!");
    }
    
    if (UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation)){
        // code for Portrait orientation
        NSLog(@"Portrait");
    }else{
        NSLog(@"Landscape");
    }
    if (RecordedSuccessfully){
        //----- RECORDED SUCESSFULLY -----
        NSLog(@"didFinishRecordingToOutputFileAtURL - success");
        lblSavingText.hidden=NO;
        [self saveMovieToCameraRoll];
    }else{
        lblSavingText.hidden=YES;
        NSLog(@"Recording error");
        [self errorRecordingMessage];
    }
}

//********** VIEW DID UNLOAD **********
- (void)viewDidUnload
{
    [super viewDidUnload];
    
    CaptureSession = nil;
    MovieFileOutput = nil;
    VideoInputDevice = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setDeviceString
{
    //setting deviceString after knowing about the platform
    //setting deviceString after knowing about the platform
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    
    
    if ([platform isEqualToString:@"iPhone1,1"])
        deviceString = @"iPhone 1G";
    if ([platform isEqualToString:@"iPhone1,2"])
        deviceString = @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"])
        deviceString = @"iPhone 3GS";
    if ([platform hasPrefix:@"iPhone3"])
        deviceString = @"iPhone 4";
    if ([platform isEqualToString:@"iPod1,1"])
        deviceString = @"iPod Touch 1G";
    if ([platform isEqualToString:@"iPod2,1"])
        deviceString = @"iPod Touch 2G";
    if ([platform isEqualToString:@"iPod3,1"])
        deviceString = @"iPod Touch 3G";
    if ([platform isEqualToString:@"iPod4,1"])
        deviceString = @"iPod Touch 4G";
    if ([platform isEqualToString:@"iPod5,1"])
        deviceString = @"iPod Touch 5G";
    if ([platform hasPrefix:@"iPhone4,1"])
        deviceString = @"iPhone 4S";
    if ([platform hasPrefix:@"iPhone3,1"])
        deviceString = @"iPhone 4";
    if ([platform hasPrefix:@"iPhone5"])
        deviceString = @"iPhone 5";
    if ([platform hasPrefix:@"iPad2,5"])
        deviceString = @"iPad Mini";
    if ([platform hasPrefix:@"iPad2,6"])
        deviceString = @"iPad Mini";
    if ([platform hasPrefix:@"iPad2,7"])
        deviceString = @"iPad Mini";
    if ([platform hasPrefix:@"iPad2,1"])
        deviceString = @"iPad 2";
    if ([platform hasPrefix:@"iPad2,2"])
        deviceString = @"iPad 2";
    if ([platform hasPrefix:@"iPad2,3"])
        deviceString = @"iPad 2";
    if ([platform hasPrefix:@"iPad2,4"])
        deviceString = @"iPad 2";
    if ([platform hasPrefix:@"iPad3,1"])
        deviceString = @"iPad 3";
    if ([platform hasPrefix:@"iPad3,2"])
        deviceString = @"iPad 3";
    if ([platform hasPrefix:@"iPad3,3"])
        deviceString = @"iPad 3";
    if ([platform hasPrefix:@"iPad3,4"])
        deviceString = @"iPad 4";
    if ([platform hasPrefix:@"iPad3,5"])
        deviceString = @"iPad 4";
    if ([platform hasPrefix:@"iPad3,6"])
        deviceString = @"iPad 4";
    if ([platform hasPrefix:@"i386"])
        deviceString = @"Simulator";
    if ([platform hasPrefix:@"x86_64"])
        deviceString = @"Simulator";
    
    [[NSUserDefaults standardUserDefaults] setObject:deviceString forKey:@"deviceString"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSLog(@"device>>>>>====%@<<<<<<<<<<%@",deviceString,platform);
}

-(void)enableDeviceSupportedControls{
    NSLog(@"Connected Device:%@",deviceString);
    btnPresetQuality1.hidden=NO;
    if([deviceString isEqualToString:@"iPhone 1G"] || [deviceString isEqualToString:@"iPhone 3G"]){
        NSLog(@"Device does not support video recording :(");
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Device does not support Video Recording :(" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }else if([deviceString isEqualToString:@"iPhone 3GS"]){
        //fornt camera=> not supported.
        //rear camera and VGA resolusion supported.
        btnSwitchCamera.hidden=YES;
        btnPresetQuality1.hidden=YES;
        [self resetSettingsControls];
    }else if([deviceString isEqualToString:@"iPhone 4"]){
        //fornt camera=> VGA supported.
        //rear camera and 720p resolusion supported.
    }else if([deviceString isEqualToString:@"iPhone 4S"]){
        //fornt camera=> VGA supported.
        //rear camera and 1080p resolusion supported.
    }else if([deviceString isEqualToString:@"iPhone 5"]){
        //fornt camera=> 720 supported.
        //rear camera and 1080p resolusion supported.
    }else{
        //fornt camera=> 720 supported.
        //rear camera and 1080p resolusion supported. HD support
    }
}

-(void)setSelectedImage{
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"RES_VALUE"] isEqualToString:@"1"]){
        [btnPresetQuality1 setImage:[UIImage imageNamed:@"HD-selected.png"] forState:UIControlStateNormal];
        [btnPresetQuality2 setImage:[UIImage imageNamed:@"High.png"] forState:UIControlStateNormal];
        [btnPresetQuality3 setImage:[UIImage imageNamed:@"Medium.png"] forState:UIControlStateNormal];
        [btnPresetQuality4 setImage:[UIImage imageNamed:@"Low.png"] forState:UIControlStateNormal];
    }else if([[[NSUserDefaults standardUserDefaults] objectForKey:@"RES_VALUE"] isEqualToString:@"2"]){
        [btnPresetQuality1 setImage:[UIImage imageNamed:@"HD"] forState:UIControlStateNormal];
        [btnPresetQuality2 setImage:[UIImage imageNamed:@"High-selected.png"] forState:UIControlStateNormal];
        [btnPresetQuality3 setImage:[UIImage imageNamed:@"Medium.png"] forState:UIControlStateNormal];
        [btnPresetQuality4 setImage:[UIImage imageNamed:@"Low.png"] forState:UIControlStateNormal];
    }else if([[[NSUserDefaults standardUserDefaults] objectForKey:@"RES_VALUE"] isEqualToString:@"3"]){
        [btnPresetQuality1 setImage:[UIImage imageNamed:@"HD"] forState:UIControlStateNormal];
        [btnPresetQuality2 setImage:[UIImage imageNamed:@"High.png"] forState:UIControlStateNormal];
        [btnPresetQuality3 setImage:[UIImage imageNamed:@"Medium-selected.png"] forState:UIControlStateNormal];
        [btnPresetQuality4 setImage:[UIImage imageNamed:@"Low.png"] forState:UIControlStateNormal];
    }else if([[[NSUserDefaults standardUserDefaults] objectForKey:@"RES_VALUE"] isEqualToString:@"4"]){
        [btnPresetQuality1 setImage:[UIImage imageNamed:@"HD"] forState:UIControlStateNormal];
        [btnPresetQuality2 setImage:[UIImage imageNamed:@"High.png"] forState:UIControlStateNormal];
        [btnPresetQuality3 setImage:[UIImage imageNamed:@"Medium.png"] forState:UIControlStateNormal];
        [btnPresetQuality4 setImage:[UIImage imageNamed:@"Low-selected.png"] forState:UIControlStateNormal];
    }else{
        [btnPresetQuality1 setImage:[UIImage imageNamed:@"HD"] forState:UIControlStateNormal];
        [btnPresetQuality2 setImage:[UIImage imageNamed:@"High.png"] forState:UIControlStateNormal];
        [btnPresetQuality3 setImage:[UIImage imageNamed:@"Medium-selected.png"] forState:UIControlStateNormal];
        [btnPresetQuality4 setImage:[UIImage imageNamed:@"Low.png"] forState:UIControlStateNormal];
    }
}

-(void)enableDisableControlsOnRecording:(int)type{
    if(type==1){
        btnSwitchCamera.enabled=NO;
        btnSettings.enabled=NO;
        btnMoreInfo.enabled=NO;
    }else{
        btnSwitchCamera.enabled=YES;
        btnSettings.enabled=YES;
        btnMoreInfo.enabled=YES;
    }
}

-(void)saveMovieToCameraRoll{
    NSString *outputPath = [[NSString alloc] initWithFormat:@"%@%@", NSTemporaryDirectory(), @"output.mov"];
    NSURL *outputURL = [[NSURL alloc] initFileURLWithPath:outputPath];
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    if ([library videoAtPathIsCompatibleWithSavedPhotosAlbum:outputURL])
    {
        [library writeVideoAtPathToSavedPhotosAlbum:outputURL
                                    completionBlock:^(NSURL *assetURL, NSError *error)
         {
             if (error)
             {
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"This video can not be save. Please check photos access settings for this app." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                 alert.tag=-300;
                 [alert show];
                 lblSavingText.hidden=YES;
             }else{
                 lblSavingText.hidden=YES;
             }
         }];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(alertView.tag==100){
        if (buttonIndex == 1) { // OK Button Pressed
            lblSavingText.hidden=NO;
            [self saveMovieToCameraRoll];
        }
    }
}

-(void)checkCameraPermission{
    if(![[[NSUserDefaults standardUserDefaults]objectForKey:@"LAUNCH"] isEqualToString:@"1"]){
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"LAUNCH"];
    }else{
        __block BOOL permssionFlag=NO;
        NSLog(@"IOS Version:%f",[[ [ UIDevice currentDevice ] systemVersion ] floatValue]);
        if([ [ [ UIDevice currentDevice ] systemVersion ] floatValue ] >= 7.0){
            NSLog(@"Found IOS 7.0");
            [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL response){
                NSLog(@"Allow microphone use response: %d", response);
                permssionFlag=response;
                if(response==NO){
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Microphone Access Denied" message:@"This app requires access to your device's Microphone.\n\nPlease enable Microphone access for this app in Settings -> Privacy -> Microphone -> Video Sizer" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    alert.tag=-300;
                    [alert show];
                }
            }];
        }
        if(IOS_NEWER_OR_EQUAL_TO_6){
            ALAuthorizationStatus status = [ALAssetsLibrary authorizationStatus];
            if (status != ALAuthorizationStatusAuthorized) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Photos Access Denied" message:@"This app requires access to your device's Photos Gallery.\n\nPlease enable Photos access for this app in Settings -> Privacy -> Photos -> Video Sizer" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                alert.tag=-100;
                [alert show];
            }
        }
    }
}

-(AVCaptureVideoOrientation)getVideoOrientation{
    // set the videoOrientation based on the device orientation to
    // ensure the pic is right side up for all orientations
    AVCaptureVideoOrientation videoOrientation;
    switch ([UIDevice currentDevice].orientation) {
        case UIDeviceOrientationLandscapeLeft:
            // Not clear why but the landscape orientations are reversed
            // if I use AVCaptureVideoOrientationLandscapeLeft here the pic ends up upside down
            videoOrientation = AVCaptureVideoOrientationLandscapeRight;
            break;
        case UIDeviceOrientationLandscapeRight:
            // Not clear why but the landscape orientations are reversed
            // if I use AVCaptureVideoOrientationLandscapeRight here the pic ends up upside down
            videoOrientation = AVCaptureVideoOrientationLandscapeLeft;
            break;
        case UIDeviceOrientationPortraitUpsideDown:
            videoOrientation = AVCaptureVideoOrientationPortraitUpsideDown;
            break;
        default:
            videoOrientation = AVCaptureVideoOrientationPortrait;
            break;
    }
    
    return videoOrientation;
}

-(void)resetSettingsControls{
    imgviewSetting.frame=CGRectMake(0, 0, 53, 179);
    btnPresetQuality2.frame=CGRectMake(9, 8, 38, 38);
    btnPresetQuality3.frame=CGRectMake(9, 49, 38, 38);
    btnPresetQuality4.frame=CGRectMake(9, 90, 38, 38);
    btnGridLines.frame=CGRectMake(9, 130, 38, 38);
}

-(void)getListofAllPreset
{
    APP_DELEGATE.Presetarray = [[NSMutableArray alloc] init];
    APP_DELEGATE.PresetarrayVal = [[NSMutableArray alloc] init];

    int i = 0;
    
    for(AVCaptureDeviceFormat *vFormat in [bCaptureDevice formats] )
    {
        CMFormatDescriptionRef description= vFormat.formatDescription;
        if(CMFormatDescriptionGetMediaSubType(description)==kCVPixelFormatType_420YpCbCr8BiPlanarFullRange)
        {
            
            
            if(CMVideoFormatDescriptionGetDimensions(description).width == 640 && CMVideoFormatDescriptionGetDimensions(description).height == 480)
            {
                APP_DELEGATE.PresetValue = i;
            }
            if ( YES == [bCaptureDevice lockForConfiguration:NULL] )
            {
                bCaptureDevice.activeFormat = vFormat;
                [bCaptureDevice unlockForConfiguration];
            }
            
            AVCaptureConnection *CaptureConnection = [MovieFileOutput connectionWithMediaType:AVMediaTypeVideo];
            if(CaptureConnection.isActive)
            {
                [APP_DELEGATE.Presetarray addObject:vFormat];
                NSLog(@"Mayank");
            }
            else
            {
                NSLog(@"purwar");
            }
            
            i++;
        }
        
    }
    
    AVCaptureDeviceFormat *vFormat = [APP_DELEGATE.Presetarray objectAtIndex:APP_DELEGATE.PresetValue];
    float maxrate=((AVFrameRateRange*)[vFormat.videoSupportedFrameRateRanges objectAtIndex:0]).maxFrameRate;
    {
        if ( YES == [bCaptureDevice lockForConfiguration:NULL] )
        {
            APP_DELEGATE.frameselected = maxrate;
            bCaptureDevice.activeFormat = vFormat;
            [bCaptureDevice setActiveVideoMinFrameDuration:CMTimeMake(1,maxrate)];
            [bCaptureDevice setActiveVideoMaxFrameDuration:CMTimeMake(1,maxrate)];
            [bCaptureDevice unlockForConfiguration];
            NSLog(@"formats  %@ %@ %@",vFormat.mediaType,vFormat.formatDescription,vFormat.videoSupportedFrameRateRanges);
        }
    }
}

-(IBAction)ShowImagePicker:(id)sender
{
    UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
    imgPicker.delegate = self;
    imgPicker.allowsEditing = YES;
    imgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imgPicker animated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)SetCameraGridandPreset
{
    imgviewGridLines.hidden = !APP_DELEGATE.gridOn;
    AVCaptureDeviceFormat *vFormat = [APP_DELEGATE.Presetarray objectAtIndex:APP_DELEGATE.PresetValue];
    if ( YES == [bCaptureDevice lockForConfiguration:NULL] )
    {
        bCaptureDevice.activeFormat = vFormat;
        [bCaptureDevice setActiveVideoMinFrameDuration:CMTimeMake(1,APP_DELEGATE.frameselected)];
        [bCaptureDevice setActiveVideoMaxFrameDuration:CMTimeMake(1,APP_DELEGATE.frameselected)];
        [bCaptureDevice unlockForConfiguration];
    }
}

-(void)SettingsChanged
{
    [self StartCheckingdeviceRotation];
    [self SetCameraGridandPreset];
    [self supportedInterfaceOrientations];
//    [self orientationChanged:nil];
}

-(void)StartCheckingdeviceRotation
{
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(orientationChanged:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
}

-(void)StopCheckingdeviceRotation
{
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIDeviceOrientationDidChangeNotification
                                                  object:nil];
    
}



@end








