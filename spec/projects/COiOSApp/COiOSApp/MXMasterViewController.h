//
//  MXMasterViewController.h
//  COiOSApp
//
//  Created by Jason Lee on 13-10-17.
//  Copyright (c) 2013年 taobao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MXDetailViewController;

@interface MXMasterViewController : UITableViewController

@property (strong, nonatomic) MXDetailViewController *detailViewController;

@end
