//
//  CanadianLinenSalesforceAppDelegate.h
//  CanadianLinen Salesforce
//
//  Created by Aaron C Wright on 11/25/12.
//  Copyright (c) 2012 Aaron C Wright. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CanadianLinenSalesforcePresentationManager.h"
#import "CanadianLinenSalesforceDocumentManager.h"
#import "CanadianLinenSalesforceSaveManager.h"
#import "CanadianLinenSalesforceSplashViewController.h"
#import "CanadianLinenSalesforceWebViewController.h"

@interface CanadianLinenSalesforceAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

- (void)presentSplashScreen;

@end
