//
//  CanadianLinenSalesforceSaveTableViewController.h
//  CanadianLinen Salesforce
//
//  Created by Aaron C Wright on 7/21/13.
//  Copyright (c) 2013 Aaron C Wright. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CanadianLinenSalesforceNotifications.h"
#import "CanadianLinenSalesforceSaveManager.h"
#import "CanadianLinenSalesforceSave.h"

@interface CanadianLinenSalesforceSaveTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>

@property UIActivityIndicatorView *activityIndicator;
@property IBOutlet UIBarButtonItem *activityButton;
@property IBOutlet UIBarButtonItem *refreshButton;
@property IBOutlet UIBarButtonItem *editButton;
@property IBOutlet UINavigationBar *navigationBar;

- (IBAction)refresh:(id)sender;
- (IBAction)reload:(id)sender;
- (IBAction)edit:(id)sender;

@end
