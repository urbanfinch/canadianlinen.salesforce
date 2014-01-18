//
//  CanadianLinenSalesforceSaveTableViewController.m
//  CanadianLinen Salesforce
//
//  Created by Aaron C Wright on 7/21/13.
//  Copyright (c) 2013 Aaron C Wright. All rights reserved.
//

#import "CanadianLinenSalesforceSaveTableViewController.h"

@implementation CanadianLinenSalesforceSaveTableViewController

@synthesize activityIndicator = _activityIndicator;
@synthesize activityButton = _activityButton;
@synthesize refreshButton = _refreshButton;
@synthesize editButton = _editButton;
@synthesize navigationBar = _navigationBar;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reload:)
                                                 name:CanadianLinenSalesforceSavesDidInitializeNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reload:)
                                                 name:CanadianLinenSalesforceSavesDidChangeNotification
                                               object:nil];
    
    self.clearsSelectionOnViewWillAppear = NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return (toInterfaceOrientation == (UIInterfaceOrientationLandscapeLeft | UIInterfaceOrientationLandscapeRight));
}

# pragma mark -
# pragma mark actions

- (void)refresh:(id)sender {
    if (_activityButton == nil)
    {
        _activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20,20)];
        _activityButton = [[UIBarButtonItem alloc]initWithCustomView:_activityIndicator];
    }
    
    self.navigationBar.topItem.rightBarButtonItem = _activityButton;
    [_activityIndicator startAnimating];
    
    [[CanadianLinenSalesforceSaveManager defaultManager] initialize];
}

- (void)reload:(id)sender {
    if ([[[CanadianLinenSalesforceSaveManager defaultManager] saves] count] > 0) {
        [[self editButton] setEnabled:YES];
        [[self editButton] setTitle:@"Edit"];
        [[self editButton] setStyle:UIBarButtonItemStylePlain];
    }
    
    [self.tableView reloadData];
    
    [_activityIndicator stopAnimating];
    self.navigationBar.topItem.rightBarButtonItem = _refreshButton;
}

- (void)edit:(id)sender {
    if ([self.tableView isEditing]) {
        [self.tableView setEditing:NO animated:YES];
        [[self editButton] setTitle:@"Edit"];
        [[self editButton] setStyle:UIBarButtonItemStylePlain];
    } else {
        [[self editButton] setTitle:@"Done"];
        [[self editButton] setStyle:UIBarButtonItemStyleDone];
        [self.tableView setEditing:YES animated:YES];
    }
}

# pragma mark -
# pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[CanadianLinenSalesforceSaveManager defaultManager] saves] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CanadianLinenSalesforceSave *save = [[[CanadianLinenSalesforceSaveManager defaultManager] saves] objectAtIndex:indexPath.row];
    
    static NSString *CellIdentifier = @"Save";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    [[cell textLabel] setText:[save title]];
    [[cell detailTextLabel] setText:[NSString stringWithFormat:@"%@ - %@", [save presentation], [save date]]];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [[CanadianLinenSalesforceSaveManager defaultManager] removeSaveObjectAtIndex:indexPath.row];
        
        if ([[[CanadianLinenSalesforceSaveManager defaultManager] saves] count] == 0) {
            [[self editButton] setEnabled:NO];
            [[self editButton] setTitle:@"Edit"];
            [[self editButton] setStyle:UIBarButtonItemStylePlain];
        }
    }
}

# pragma mark -
# pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[CanadianLinenSalesforceSaveManager defaultManager] setSave:[[[CanadianLinenSalesforceSaveManager defaultManager] saves] objectAtIndex:indexPath.row]];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:CanadianLinenSalesforceSaveChangedNotification object:[NSNumber numberWithInteger:indexPath.row]];
}

@end
