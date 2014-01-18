//
//  CanadianLinenSalesforcePrintWebView.h
//  CanadianLinen Salesforce
//
//  Created by Aaron Wright on 2/22/13.
//  Copyright (c) 2013 Aaron C Wright. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface CanadianLinenSalesforcePrintWebView : UIWebView <UIWebViewDelegate>

@property (nonatomic, strong) NSString *data;

- (NSData *)pdfData;
- (IBAction)loadData:(id)sender;

@end
