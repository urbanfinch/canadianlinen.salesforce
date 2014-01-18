//
//  CanadianLinenSalesforceEditTableViewController.m
//  CanadianLinen Salesforce
//
//  Created by Aaron C Wright on 2/25/13.
//  Copyright (c) 2013 Aaron C Wright. All rights reserved.
//

#import "CanadianLinenSalesforceEditTableViewController.h"

@implementation CanadianLinenSalesforceEditTableViewController

@synthesize editSwitch = _editSwitch;
@synthesize saveButton = _saveButton;
@synthesize resetButton = _resetButton;

# pragma mark -
# pragma mark awake

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(changed:)
                                                 name:CanadianLinenSalesforcePresentationChangedNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(changed:)
                                                 name:CanadianLinenSalesforceDocumentChangedNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(changed:)
                                                 name:CanadianLinenSalesforceSaveChangedNotification
                                               object:nil];
}

# pragma mark -
# pragma mark actions

- (void)toggle:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:CanadianLinenSalesforceDidToggleEditNotification object:sender];
}

- (void)save:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:CanadianLinenSalesforceDidRequestEditSaveNotification object:sender];
}

- (void)reset:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:CanadianLinenSalesforceDidRequestEditResetNotification object:sender];
}

# pragma mark -
# pragma mark notifications

- (void)changed:(NSNotification *)notification {
    [_editSwitch setOn:NO animated:NO];
}

@end
