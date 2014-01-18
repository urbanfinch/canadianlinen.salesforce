//
//  CanadianLinenSalesforceWebView.m
//  CanadianLinen Salesforce
//
//  Created by Aaron C Wright on 11/25/12.
//  Copyright (c) 2012 Aaron C Wright. All rights reserved.
//

#import "CanadianLinenSalesforceWebView.h"

@implementation CanadianLinenSalesforceWebView

@synthesize data = _data;

# pragma mark -
# pragma mark init

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        //[self setBackgroundColor:[UIColor underPageBackgroundColor]];
        [self loadDefaultRequest:self];
        [self setDelegate:self];
    }
    return self;
}

# pragma mark -
# pragma mark actions

- (void)loadDefaultRequest:(id)sender {
    NSString *defaultPath = [[NSBundle mainBundle] pathForResource:@"default" ofType:@"html"];
    NSURL *defaultURL = [NSURL fileURLWithPath:defaultPath];
    [self loadRequest:[NSURLRequest requestWithURL:defaultURL]];
}

- (void)loadData:(id)sender {
    [self stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"presentation.load('%@');", [self data]]];
}

# pragma mark -
# pragma mark UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self performSelector:@selector(loadData:) withObject:webView afterDelay:0.5];
}

@end
