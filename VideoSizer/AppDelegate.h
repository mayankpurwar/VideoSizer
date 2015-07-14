//
//  AppDelegate.h
//  VideoSizer
//
//  Created by Apple on 7/3/15.
//  Copyright (c) 2015 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
//#import <Tapjoy/Tapjoy.h>
//#import "Flurry.h"


#define IOS_NEWER_OR_EQUAL_TO_6 ( [ [ [ UIDevice currentDevice ] systemVersion ] floatValue ] >= 6.0 )


#define APP_DELEGATE ((AppDelegate *)[UIApplication sharedApplication].delegate)


#define TXT_TOP_HEADER              @"Video Sizer"
#define TXT_APPLICATION_VERSION     @"Version 1.0"
#define TXT_SECTION_HEADER_3		@"Other Interesting Apps"
#define TXT_SECTION_HEADER_2		@"Send Feedback"
#define TXT_SECTION_HEADER_1		@"Settings"
#define COPY_RIGHT                  @"Copyright © aisoftware.mobi"
#define COPY_RIGHT_TEXT             @"http://www.aisoftware.mobi/"

#define URL_RATE_REVIEW              @"https://itunes.apple.com/us/app/video-sizer/id799261396?ls=1&mt=8"
#define USER_DEFAULTS				[NSUserDefaults standardUserDefaults]
#define TXT_FEEDBACK				@"Send us Feedback"
#define TXT_RATE					@"Rate This App"
#define ICON_FEEDBACK				@"EmailComments.png"
#define ICON_RATE					@"Review.png"
#define TXT_EMAIL_SUBJECT			@"App Comments"
#define EMAIL_FEEDBACK				@"support@aisoftware.mobi"




#define presetArr @[ @"AVCaptureSessionPresetHigh", @"AVCaptureSessionPresetMedium",@"AVCaptureSessionPresetLow", @"AVCaptureSessionPreset352x288", @"AVCaptureSessionPreset640x480", @"AVCaptureSessionPreset1280x720", @"AVCaptureSessionPreset1920x1080"]

#define presetArrValue @[ @"High", @"Medium",@"Low", @"352x288", @"640x480", @"1280x720", @"1920x1080"]



@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    
}

@property(nonatomic,strong) NSMutableArray *Presetarray;
@property(nonatomic,strong) NSMutableArray *PresetarrayVal;
@property(nonatomic) NSInteger PresetValue;
@property(nonatomic) int frameselected;
@property(nonatomic) BOOL gridOn;
//@property(nonatomic) BOOL frame60Supported;
//@property(nonatomic) BOOL frame60Selected;
@property(nonatomic) BOOL slowMotionSupported;

@property (strong, nonatomic) UIWindow *window;


@end

