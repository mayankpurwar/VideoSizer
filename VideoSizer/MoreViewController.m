//
//  MoreViewController.m
//  VideoSizer
//
//  Created by Apple on 7/3/15.
//  Copyright (c) 2015 Apple. All rights reserved.
//

#import "MoreViewController.h"

@interface MoreViewController ()

@end

@implementation MoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    moreTableDataSource = [[NSMutableArray alloc] init];
//    [moreTableDataSource addObject:[zApps getApps]];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(backButtonClicked)];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark -
#pragma mark UINavigationBarDelegate

-(void)backButtonClicked
{
//    self.presentedViewController.navigationController.navigationBar.hidden = YES;
    [self dismissViewControllerAnimated:YES completion:nil];
    
    ViewController *view = (ViewController *)self.presentingViewController;
    [view SettingsChanged];
//    [view supportedInterfaceOrientations];
//    [view orientationChanged:nil];
}

#pragma mark -
#pragma mark UITableView DataSource

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section==0){
        return 40.0;
    }else if(section == 3){
        return 40.0;
    }else{
        return 20.0;
    }
}

//customize number of height of rows in sections
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0;
}
// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    int DEVICE_WIDTH = self.view.frame.size.width;
    float X_POSITION_FOR_MORE_SCREEN=10.0;
    if(DEVICE_WIDTH == 768.0){
        X_POSITION_FOR_MORE_SCREEN=45.0;
    }else{
        X_POSITION_FOR_MORE_SCREEN=10.0;
    }
    if(section == 0){
        UIView *containerView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 40)];
        UILabel *headerLabel =[[UILabel alloc]initWithFrame:CGRectMake(0, 10, DEVICE_WIDTH, 20)];
        UILabel *headerVersion =[[UILabel alloc]initWithFrame:CGRectMake(0, 27, DEVICE_WIDTH, 20)];
        headerLabel.textColor = [UIColor blackColor];
        headerLabel.shadowOffset = CGSizeMake(0, 1);
        headerVersion.textColor = [UIColor blackColor];
        headerVersion.shadowOffset = CGSizeMake(0, 1);
        if(IOS_NEWER_OR_EQUAL_TO_6){
            headerLabel.font = [UIFont fontWithName:@"Avenir-Black" size:17.0f];
            headerVersion.font = [UIFont fontWithName:@"Avenir-Black" size:12.0f];
        }
        else{
            headerLabel.font = [UIFont boldSystemFontOfSize:17];
            headerVersion.font = [UIFont boldSystemFontOfSize:12];
        }
        headerLabel.backgroundColor = [UIColor clearColor];
        [headerLabel setTextAlignment:NSTextAlignmentCenter];
        //[headerLabel setTextAlignment:UITextAlignmentCenter];
        [containerView addSubview:headerLabel];
        headerLabel.text=TXT_TOP_HEADER;
        headerVersion.backgroundColor = [UIColor clearColor];
        [headerVersion setTextAlignment:NSTextAlignmentCenter];
        [containerView addSubview:headerVersion];
        headerVersion.text=TXT_APPLICATION_VERSION;
        return containerView;
    }else  if(section == 1){
        UIView *containerView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 40)];
        UILabel *headerLabel =[[UILabel alloc]initWithFrame:CGRectMake(X_POSITION_FOR_MORE_SCREEN, 0, DEVICE_WIDTH, 20)];
        headerLabel.textColor = [UIColor blackColor];
        headerLabel.shadowOffset = CGSizeMake(0, 1);
        if(IOS_NEWER_OR_EQUAL_TO_6){
            headerLabel.font = [UIFont fontWithName:@"Avenir-Black" size:15.0f];
        }
        else{
            headerLabel.font = [UIFont boldSystemFontOfSize:15];
        }
        headerLabel.backgroundColor = [UIColor clearColor];
        [headerLabel setTextAlignment:NSTextAlignmentLeft];
        [containerView addSubview:headerLabel];
        headerLabel.text=@"Send Feedback";
        return containerView;
    }else  if(section == 2){
        UIView *containerView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 40)];
        UILabel *headerLabel =[[UILabel alloc]initWithFrame:CGRectMake(X_POSITION_FOR_MORE_SCREEN, 0, DEVICE_WIDTH, 20)];
        headerLabel.textColor = [UIColor blackColor];
        headerLabel.shadowOffset = CGSizeMake(0, 1);
        if(IOS_NEWER_OR_EQUAL_TO_6){
            headerLabel.font = [UIFont fontWithName:@"Avenir-Black" size:15.0f];
        }
        else{
            headerLabel.font = [UIFont boldSystemFontOfSize:15];
        }
        headerLabel.backgroundColor = [UIColor clearColor];
        [headerLabel setTextAlignment:NSTextAlignmentLeft];
        [containerView addSubview:headerLabel];
        //            headerLabel.text=@"Other Interesting Apps";
        headerLabel.text=@"Camera settings";
        return containerView;
    }else  if(section == 3){
        UIView *containerView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 40)];
        UILabel *headerLabel =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 20)];
        headerLabel.textColor = [UIColor blackColor];
        headerLabel.shadowOffset = CGSizeMake(0, 1);
        
        UILabel *header2 =[[UILabel alloc]initWithFrame:CGRectMake(0, 20, DEVICE_WIDTH, 20)];
        header2.textColor = [UIColor blackColor];
        header2.shadowOffset = CGSizeMake(0, 1);
        
        if(IOS_NEWER_OR_EQUAL_TO_6){
            headerLabel.font = [UIFont fontWithName:@"Avenir-Black" size:12.0f];
            header2.font = [UIFont fontWithName:@"Avenir-Black" size:12.0f];
        }
        else{
            headerLabel.font = [UIFont boldSystemFontOfSize:12];
            header2.font = [UIFont boldSystemFontOfSize:12];
        }
        headerLabel.backgroundColor = [UIColor clearColor];
        [headerLabel setTextAlignment:NSTextAlignmentCenter];
        [containerView addSubview:headerLabel];
        headerLabel.text=COPY_RIGHT;
        header2.backgroundColor = [UIColor clearColor];
        [header2 setTextAlignment:NSTextAlignmentCenter];
        [containerView addSubview:header2];
        header2.text=COPY_RIGHT_TEXT;
        return containerView;
    }
    else
    {
        return NULL;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0)
    {
        return 0;
    }
    else if(section == 1)
    {
        return 2;
    }
    else if(section == 2)
    {
        int count = (int)APP_DELEGATE.Presetarray.count+2;
        
        return count;
        //return [[moreTableDataSource objectAtIndex:0] count];
    }
    else
    {
        return 0;
    }
}

#pragma mark -
#pragma mark UITableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.section == 2)
    {
        
        if(indexPath.row < APP_DELEGATE.Presetarray.count)
        {
            APP_DELEGATE.PresetValue = indexPath.row;
            
            AVCaptureDeviceFormat *vFormat  = (AVCaptureDeviceFormat *)[APP_DELEGATE.Presetarray objectAtIndex:indexPath.row];
            float maxrate=((AVFrameRateRange*)[vFormat.videoSupportedFrameRateRanges objectAtIndex:0]).maxFrameRate;
            APP_DELEGATE.frameselected = maxrate;
        }
        else if(indexPath.row == APP_DELEGATE.Presetarray.count)
        {
            APP_DELEGATE.gridOn = !APP_DELEGATE.gridOn;
        }
        else if(indexPath.row == APP_DELEGATE.Presetarray.count+1)
        {
            //            APP_DELEGATE.frame60Selected = !APP_DELEGATE.frame60Selected;
            
            AVCaptureDeviceFormat *vFormat  = (AVCaptureDeviceFormat *)[APP_DELEGATE.Presetarray objectAtIndex:APP_DELEGATE.PresetValue];
            mincount=((AVFrameRateRange*)[vFormat.videoSupportedFrameRateRanges objectAtIndex:0]).minFrameRate;
            maxcount=((AVFrameRateRange*)[vFormat.videoSupportedFrameRateRanges objectAtIndex:0]).maxFrameRate;
            picker.hidden = NO;
            [picker reloadAllComponents];
            
            [picker selectRow:maxcount-mincount+1 inComponent:0 animated:NO];
        }
        
        [tableView reloadData];
        
        
        
        
        
        //        [[NSUserDefaults standardUserDefaults] setObject:[[[moreTableDataSource objectAtIndex:0] objectAtIndex:indexPath.row] objectForKey:@"appid"] forKey:@"TappedAppId"];
        //        [[NSUserDefaults standardUserDefaults] synchronize];
        //        [ztracker Track:@"zapp_ituneslink"];
        //        if(IOS_NEWER_OR_EQUAL_TO_6){
        //            // Initialize Product View Controller
        //            /*SKStoreProductViewController *storeProductViewController = [[SKStoreProductViewController alloc] init];
        //             // Configure View Controller
        //             [storeProductViewController setDelegate:self];
        //             [storeProductViewController loadProductWithParameters:@{SKStoreProductParameterITunesItemIdentifier : [[[moreTableDataSource objectAtIndex:0] objectAtIndex:indexPath.row] objectForKey:@"appleid"]} completionBlock:^(BOOL result, NSError *error) {
        //             if (error) {
        //             NSLog(@"Error %@ with User Info %@.", error, [error userInfo]);
        //
        //             } else {
        //             // Present Store Product View Controller
        //             [self presentViewController:storeProductViewController animated:NO completion:nil];
        //             }
        //             }];*/
        //            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[zApps getAppURL:[[[moreTableDataSource objectAtIndex:0] objectAtIndex:indexPath.row] objectForKey:@"appleid"]]]];
        //        }else{
        //            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[zApps getAppURL:[[[moreTableDataSource objectAtIndex:0] objectAtIndex:indexPath.row] objectForKey:@"appleid"]]]];
        //        }
    }
    else if(indexPath.section == 1)
    {
        if(indexPath.row==0)
        {
            Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
            if (mailClass != nil)
            {
                if ([mailClass canSendMail])
                {
                    [self displayComposerSheet];
                }
                else
                {
                    [self launchMailAppOnDevice];
                }
            }
            else
            {
                [self launchMailAppOnDevice];
            }
        }
        else if(indexPath.row==1) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:URL_RATE_REVIEW]];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark Store Product View Controller Delegate Methods

- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *arr[2][2] = {{TXT_FEEDBACK, ICON_FEEDBACK},{TXT_RATE, ICON_RATE}};
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellIdentifier"];
    cell = nil;
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellIdentifier"];
    }
    if(indexPath.section == 2)
    {
        //        NSString *appleID = [[[moreTableDataSource objectAtIndex:0] objectAtIndex:indexPath.row] objectForKey:@"appleid"];
        //        UIImage *orig_image = [zApps getAppIcon:appleID];
        //        //cell.imageView.image = orig_image;
        //
        //        UIImageView *imgview = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 40, 40)]; //create ImageView
        //        imgview.image = orig_image;
        //        [cell.contentView addSubview:imgview];
        //
        //        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(50,5,240,40)];
        //        [lbl setBackgroundColor:[UIColor clearColor]];
        //        [lbl setText:[[[moreTableDataSource objectAtIndex:0] objectAtIndex:indexPath.row] objectForKey:@"appname"]];
        //        [lbl setTextAlignment:NSTextAlignmentLeft];
        //        lbl.textColor=[UIColor blackColor];
        //        [cell.contentView addSubview:lbl];
        //
        //        {
        //            lbl.font =  [UIFont boldSystemFontOfSize:12];
        //        }
        
        
        
        if(indexPath.row<APP_DELEGATE.Presetarray.count)
        {
            AVCaptureDeviceFormat *vFormat  = (AVCaptureDeviceFormat *)[APP_DELEGATE.Presetarray objectAtIndex:indexPath.row];
            CMFormatDescriptionRef description= vFormat.formatDescription;
            
            cell.textLabel.text = [NSString stringWithFormat:@"%d x %d",CMVideoFormatDescriptionGetDimensions(description).width,CMVideoFormatDescriptionGetDimensions(description).height];
            
            if(indexPath.row == APP_DELEGATE.PresetValue)
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else if(indexPath.row == APP_DELEGATE.Presetarray.count)
        {
            cell.textLabel.text = @"Grid On";
            if(APP_DELEGATE.gridOn)
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else if(indexPath.row == APP_DELEGATE.Presetarray.count+1)
        {
            cell.textLabel.text = [NSString stringWithFormat:@"fps - %d",APP_DELEGATE.frameselected];
        }
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
    }
    else if(indexPath.section == 1)
    {
        UIImageView *imgview = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 40, 40)]; //create ImageView
        imgview.image = [UIImage imageNamed:arr[indexPath.row][1]];
        [cell.contentView addSubview:imgview];
        
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(50,5,240,40)];
        [lbl setBackgroundColor:[UIColor clearColor]];
        [lbl setText:arr[indexPath.row][0]];
        [lbl setTextAlignment:NSTextAlignmentLeft];
        lbl.textColor=[UIColor blackColor];
        [cell.contentView addSubview:lbl];
        lbl.font =  [UIFont boldSystemFontOfSize:12];
        [cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
    }
    return cell;
}

-(void)launchMailAppOnDevice
{
    NSString *recipients = [NSString stringWithFormat:@"mailto:%@?subject=%@",EMAIL_FEEDBACK,TXT_EMAIL_SUBJECT];
    NSString *email = [NSString stringWithFormat:@"%@", recipients];
    email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    // Notifies users about errors associated with the interface
    switch (result)
    {
        case MFMailComposeResultCancelled:
            //  message.text = @"Result: canceled";
            break;
        case MFMailComposeResultSaved:
            //  message.text = @"Result: saved";
            break;
        case MFMailComposeResultSent:
            //  message.text = @"Result: sent";
            break;
        case MFMailComposeResultFailed:
            //  message.text = @"Result: failed";
            break;
        default:
            //  message.text = @"Result: not sent";
            break;
    }
    [controller dismissViewControllerAnimated:YES completion:nil];
}

-(void)displayComposerSheet
{
    MFMailComposeViewController *MailController = [[MFMailComposeViewController alloc] init];
    MailController.mailComposeDelegate = self;
    [MailController setSubject:TXT_EMAIL_SUBJECT];
    [MailController setToRecipients:[NSArray arrayWithObjects:EMAIL_FEEDBACK,nil]];
    [self presentViewController:MailController animated:YES completion:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    NSLog(@"should auto1");
    return (interfaceOrientation == !UIDeviceOrientationPortraitUpsideDown);
}

- (NSUInteger)supportedInterfaceOrientations
{
    [table reloadData];
    return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight;
}

- (BOOL) shouldAutorotate {
    return YES;
}



-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return maxcount-mincount+1;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *str = [NSString stringWithFormat:@"%d",mincount+(int)row];
    
    
    return str;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    picker.hidden = YES;
    APP_DELEGATE.frameselected = mincount+(int)row;
    [table reloadData];
}

@end

