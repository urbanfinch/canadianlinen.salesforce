//
//  CanadianLinenSalesforceAppDelegate.m
//  CanadianLinen Salesforce
//
//  Created by Aaron C Wright on 11/25/12.
//  Copyright (c) 2012 Aaron C Wright. All rights reserved.
//

#import "CanadianLinenSalesforceAppDelegate.h"

@implementation CanadianLinenSalesforceAppDelegate

@synthesize window = _window;

# pragma mark -
# pragma mark NSApplicationDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"WebKitStoreWebDataForBackup"];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [self presentSplashScreen];
    
    NSURL *url = (NSURL *)[launchOptions valueForKey:UIApplicationLaunchOptionsURLKey];
    if (url != nil && [url isFileURL]) {
        if ([[url pathExtension] isEqualToString:@"appdz"]) {
            [[CanadianLinenSalesforcePresentationManager defaultManager] openPresentationURL:url];
        }
        if ([[url pathExtension] isEqualToString:@"pdf"]) {
            [[CanadianLinenSalesforceDocumentManager defaultManager] openDocumentURL:url];
        }
    }
    
    return YES;
}

- (void)presentSplashScreen {
    [self.window.rootViewController.view setHidden:YES];
    
    NSURL *splashURL = [[NSBundle mainBundle] URLForResource:@"Splash" withExtension:@"mp4"];
    
    CanadianLinenSalesforceSplashViewController *splashViewController = [[CanadianLinenSalesforceSplashViewController alloc] initWithContentURL:splashURL];
    splashViewController.moviePlayer.controlStyle = MPMovieControlStyleNone;
    splashViewController.moviePlayer.scalingMode = MPMovieScalingModeFill;
    [splashViewController.moviePlayer.backgroundView  addSubview:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Default-Landscape~ipad.png"]]];
    [splashViewController.moviePlayer setFullscreen:YES animated:NO];
    [splashViewController.moviePlayer prepareToPlay];
    [splashViewController.moviePlayer play];
    
    [self.window setRootViewController:splashViewController];
    [self.window makeKeyAndVisible];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    if (url != nil && [url isFileURL]) {
        if ([[url pathExtension] isEqualToString:@"appdz"]) {
            [[CanadianLinenSalesforcePresentationManager defaultManager] openPresentationURL:url];
        }
        if ([[url pathExtension] isEqualToString:@"pdf"]) {
            [[CanadianLinenSalesforceDocumentManager defaultManager] openDocumentURL:url];
        }
    }
    
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    if (url != nil && [url isFileURL]) {
        if ([[url pathExtension] isEqualToString:@"appdz"]) {
            [[CanadianLinenSalesforcePresentationManager defaultManager] openPresentationURL:url];
        }
        if ([[url pathExtension] isEqualToString:@"pdf"]) {
            [[CanadianLinenSalesforceDocumentManager defaultManager] openDocumentURL:url];
        }
    }
    
    return YES;
}

@end
