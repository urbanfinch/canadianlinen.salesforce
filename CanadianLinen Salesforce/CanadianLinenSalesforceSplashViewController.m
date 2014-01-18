//
//  CanadianLinenSalesforceSplashViewController.m
//  CanadianLinen Salesforce
//
//  Created by Aaron C Wright on 11/29/12.
//  Copyright (c) 2012 Aaron C Wright. All rights reserved.
//

#import "CanadianLinenSalesforceSplashViewController.h"

@implementation CanadianLinenSalesforceSplashViewController

# pragma mark -
# pragma mark init

- (id)initWithContentURL:(NSURL *)contentURL {
    self = [super initWithContentURL:contentURL];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(playbackDidFinish:)
                                                     name:MPMoviePlayerPlaybackDidFinishNotification
                                                   object:[self moviePlayer]];
    }
    return self;
}

# pragma mark -
# pragma mark view

- (BOOL)shouldAutorotate {
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
}

# pragma mark -
# pragma mark notifications

- (void)playbackDidFinish:(NSNotification *)notification {
    UIStoryboard *authStoryboard = [UIStoryboard storyboardWithName:@"CanadianLinenSalesforceStoryboard" bundle:nil];
    UINavigationController *navigationController = [authStoryboard instantiateInitialViewController];
    
    [[[self view] window] setRootViewController:navigationController];
    [[[self view] window] makeKeyAndVisible];
}
@end
