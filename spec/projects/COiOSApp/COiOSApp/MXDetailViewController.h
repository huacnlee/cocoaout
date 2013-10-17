//
//  MXDetailViewController.h
//  COiOSApp
//
//  Created by Jason Lee on 13-10-17.
//  Copyright (c) 2013年 taobao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MXDetailViewController : UIViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
