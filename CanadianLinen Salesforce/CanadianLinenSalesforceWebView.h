//
//  CanadianLinenSalesforceWebView.h
//  CanadianLinen Salesforce
//
//  Created by Aaron C Wright on 11/25/12.
//  Copyright (c) 2012 Aaron C Wright. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CanadianLinenSalesforceWebView : UIWebView <UIWebViewDelegate>

@property (nonatomic, strong) NSString *data;

- (IBAction)loadDefaultRequest:(id)sender;
- (IBAction)loadData:(id)sender;

@end
