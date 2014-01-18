//
//  CanadianLinenSalesforceNavigationController.m
//  CanadianLinen Salesforce
//
//  Created by Aaron C Wright on 7/20/13.
//  Copyright (c) 2013 Aaron C Wright. All rights reserved.
//

#import "CanadianLinenSalesforceNavigationController.h"

@implementation CanadianLinenSalesforceNavigationController

# pragma mark -
# pragma mark view

-(BOOL)shouldAutorotate
{
    return [[self.viewControllers lastObject] shouldAutorotate];
}

-(NSUInteger)supportedInterfaceOrientations
{
    return [[self.viewControllers lastObject] supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return [[self.viewControllers lastObject] preferredInterfaceOrientationForPresentation];
}

@end
