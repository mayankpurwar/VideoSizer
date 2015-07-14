//
//  MoreViewController.h
//  VideoSizer
//
//  Created by Apple on 7/3/15.
//  Copyright (c) 2015 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"


#import <MessageUI/MFMailComposeViewController.h>
#import <StoreKit/StoreKit.h>

//#define DEVICE_WIDTH [UIScreen mainScreen].bounds.size.width
//#define DEVICE_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface MoreViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,MFMailComposeViewControllerDelegate,SKStoreProductViewControllerDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
{
    IBOutlet UITableView *table;
    NSMutableArray *moreTableDataSource;
    
    IBOutlet UIPickerView *picker;
    
    int mincount,maxcount;
}

@end
