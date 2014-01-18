//
//  CanadianLinenSalesforceSplashViewController.h
//  CanadianLinen Salesforce
//
//  Created by Aaron C Wright on 11/29/12.
//  Copyright (c) 2012 Aaron C Wright. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface CanadianLinenSalesforceSplashViewController : MPMoviePlayerViewController

- (void)playbackDidFinish:(NSNotification *)notification;

@end
