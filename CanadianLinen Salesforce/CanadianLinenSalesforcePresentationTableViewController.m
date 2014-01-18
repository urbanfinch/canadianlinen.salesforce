//
//  CanadianLinenSalesforcePresentationTableViewController.m
//  CanadianLinen Salesforce
//
//  Created by Aaron C Wright on 12/7/12.
//  Copyright (c) 2012 Aaron C Wright. All rights reserved.
//

#import "CanadianLinenSalesforcePresentationTableViewController.h"

@implementation CanadianLinenSalesforcePresentationTableViewController

@synthesize activityIndicator = _activityIndicator;
@synthesize activityButton = _activityButton;
@synthesize refreshButton = _refreshButton;
@synthesize navigationBar = _navigationBar;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reload:)
                                                 name:CanadianLinenSalesforcePresentationsDidInitializeNotification
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
    
    [[CanadianLinenSalesforcePresentationManager defaultManager] rebuildPresentationCache];
}

- (void)reload:(id)sender {
    [self.tableView reloadData];
    
    [_activityIndicator stopAnimating];
    self.navigationBar.topItem.rightBarButtonItem = _refreshButton;
}

# pragma mark - 
# pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[CanadianLinenSalesforcePresentationManager defaultManager] presentations] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CanadianLinenSalesforcePresentation *presentation = [[[CanadianLinenSalesforcePresentationManager defaultManager] presentations] objectAtIndex:indexPath.row];
                              
    static NSString *CellIdentifier = @"Presentation";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    [[cell textLabel] setText:[presentation title]];
    
    return cell;
}

# pragma mark -
# pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[CanadianLinenSalesforcePresentationManager defaultManager] setPresentation:[[[CanadianLinenSalesforcePresentationManager defaultManager] presentations] objectAtIndex:indexPath.row]];

    [[NSNotificationCenter defaultCenter] postNotificationName:CanadianLinenSalesforcePresentationChangedNotification object:[NSNumber numberWithInteger:indexPath.row]];
}

@end
