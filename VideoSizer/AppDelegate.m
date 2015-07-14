//
//  AppDelegate.m
//  VideoSizer
//
//  Created by Apple on 7/3/15.
//  Copyright (c) 2015 Apple. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

@synthesize Presetarray;
@synthesize PresetarrayVal;
@synthesize PresetValue;
@synthesize frameselected;
@synthesize gridOn;
//@synthesize frame60Supported;
//@synthesize frame60Selected;
@synthesize slowMotionSupported;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
    
    [self copyImages];
    
    //Tap Joy Connect Code
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tapJoyConnectSuccess) name:TJC_CONNECT_SUCCESS object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tapJoyConnectFailed) name:TJC_CONNECT_FAILED object:nil];
//    [Tapjoy requestTapjoyConnect:TAPJOY_ID secretKey:TAPJOY_SECRET];
    
    //Flurry Analytics code
//    [Flurry startSession:FLURRY_ID];
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


-(void) tapJoyConnectFailed
{
    NSLog(@"Tapjoy connection failed.");
}

-(void) tapJoyConnectSuccess
{
    NSLog(@"Tapjoy connection successful.");
}


-(void)copyImages
{
    NSArray *arr = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"zApps" ofType:@"plist"]];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
//    NSString *imgFolder = [documentsDirectory stringByAppendingPathComponent:@"zAppsImages"];
    
//    if(![[NSFileManager defaultManager] fileExistsAtPath:imgFolder])
//    {
//        [[NSFileManager defaultManager] createDirectoryAtPath:imgFolder withIntermediateDirectories:NO attributes:nil error:nil];
//    }
    
    
    for(int i = 0; i<arr.count; i++)
    {
        NSString *imgPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@@2x.png",[[arr objectAtIndex:i] objectForKey:@"appleid"]]];
        if(![[NSFileManager defaultManager] fileExistsAtPath:imgPath])
        {
            NSString *localPath = [[NSBundle mainBundle] pathForResource:[[arr objectAtIndex:i] objectForKey:@"appleid"] ofType:@"png"];
            [[NSFileManager defaultManager] copyItemAtPath:localPath toPath: imgPath error:nil];;
        }
    }
    
    
    
//    NSError *error;
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    NSString *path1 = [documentsDirectory stringByAppendingPathComponent:@"517625765@2x.png"];
//    NSString *path2 = [documentsDirectory stringByAppendingPathComponent:@"517626632@2x.png"];
//    NSString *path3 = [documentsDirectory stringByAppendingPathComponent:@"503847396@2x.png"];
//    NSString *path4 = [documentsDirectory stringByAppendingPathComponent:@"516218270@2x.png"];
//    NSString *path5 = [documentsDirectory stringByAppendingPathComponent:@"505400486@2x.png"];
//    NSString *path6 = [documentsDirectory stringByAppendingPathComponent:@"519638355@2x.png"];
//    NSString *path7 = [documentsDirectory stringByAppendingPathComponent:@"528186167@2x.png"];
//    NSString *path8 = [documentsDirectory stringByAppendingPathComponent:@"528186709@2x.png"];
//    NSString *path9 = [documentsDirectory stringByAppendingPathComponent:@"528187020@2x.png"];
//    
//    
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    
//    if (![fileManager fileExistsAtPath: path1])
//    {
//        NSString *bundle = [[NSBundle mainBundle] pathForResource:@"517625765" ofType:@"png"];
//        [fileManager copyItemAtPath:bundle toPath: path1 error:&error];
//        
//        NSString *bundle2 = [[NSBundle mainBundle] pathForResource:@"517626632" ofType:@"png"];
//        [fileManager copyItemAtPath:bundle2 toPath: path2 error:&error];
//        
//        NSString *bundle3 = [[NSBundle mainBundle] pathForResource:@"503847396" ofType:@"png"];
//        [fileManager copyItemAtPath:bundle3 toPath: path3 error:&error];
//        
//        NSString *bundle4 = [[NSBundle mainBundle] pathForResource:@"516218270" ofType:@"png"];
//        [fileManager copyItemAtPath:bundle4 toPath: path4 error:&error];
//        
//        NSString *bundle5 = [[NSBundle mainBundle] pathForResource:@"505400486" ofType:@"png"];
//        [fileManager copyItemAtPath:bundle5 toPath: path5 error:&error];
//        
//        NSString *bundle6 = [[NSBundle mainBundle] pathForResource:@"519638355" ofType:@"png"];
//        [fileManager copyItemAtPath:bundle6 toPath: path6 error:&error];
//        
//        NSString *bundle7 = [[NSBundle mainBundle] pathForResource:@"528186167" ofType:@"png"];
//        [fileManager copyItemAtPath:bundle7 toPath: path7 error:&error];
//        
//        NSString *bundle8 = [[NSBundle mainBundle] pathForResource:@"528186709" ofType:@"png"];
//        [fileManager copyItemAtPath:bundle8 toPath: path8 error:&error];
//        
//        NSString *bundle9 = [[NSBundle mainBundle] pathForResource:@"528187020" ofType:@"png"];
//        [fileManager copyItemAtPath:bundle9 toPath: path9 error:&error];
//    }
}


- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window{
    NSUInteger orientations = UIInterfaceOrientationMaskAllButUpsideDown;
    
//    if(self.window.rootViewController){
//        UIViewController *presentedViewController = [[(UINavigationController *)self.window.rootViewController viewControllers] lastObject];
//        orientations = [presentedViewController supportedInterfaceOrientations];
//    }
    
    return orientations;
}

@end
