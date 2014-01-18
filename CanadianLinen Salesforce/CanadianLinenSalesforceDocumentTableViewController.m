//
//  CanadianLinenSalesforceDocumentTableViewController.m
//  CanadianLinen Salesforce
//
//  Created by Aaron C Wright on 2/24/13.
//  Copyright (c) 2013 Aaron C Wright. All rights reserved.
//

#import "CanadianLinenSalesforceDocumentTableViewController.h"

@implementation CanadianLinenSalesforceDocumentTableViewController

@synthesize activityIndicator = _activityIndicator;
@synthesize activityButton = _activityButton;
@synthesize refreshButton = _refreshButton;
@synthesize navigationBar = _navigationBar;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reload:)
                                                 name:CanadianLinenSalesforceDocumentsDidInitializeNotification
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
    
    [[CanadianLinenSalesforceDocumentManager defaultManager] initialize];
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
    return [[[CanadianLinenSalesforceDocumentManager defaultManager] documents] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CanadianLinenSalesforceDocument *document = [[[CanadianLinenSalesforceDocumentManager defaultManager] documents] objectAtIndex:indexPath.row];
    
    static NSString *CellIdentifier = @"Document";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    [[cell textLabel] setText:[document title]];
    
    return cell;
}

# pragma mark -
# pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[CanadianLinenSalesforceDocumentManager defaultManager] setDocument:[[[CanadianLinenSalesforceDocumentManager defaultManager] documents] objectAtIndex:indexPath.row]];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:CanadianLinenSalesforceDocumentChangedNotification object:[NSNumber numberWithInteger:indexPath.row]];
}

@end
