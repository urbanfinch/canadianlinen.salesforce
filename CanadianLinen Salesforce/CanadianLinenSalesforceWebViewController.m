//
//  CanadianLinenSalesforceWebViewController.m
//  CanadianLinen Salesforce
//
//  Created by Aaron C Wright on 11/25/12.
//  Copyright (c) 2012 Aaron C Wright. All rights reserved.
//

#import "CanadianLinenSalesforceWebViewController.h"
#import "CanadianLinenSalesforceAppDelegate.h"

@implementation CanadianLinenSalesforceWebViewController

@synthesize webView = _webView;
@synthesize printWebView = _printWebView;
@synthesize listButton = _listButton;
@synthesize actionButton = _actionButton;
@synthesize editButton = _editButton;
@synthesize actionSheet = _actionSheet;
@synthesize editPopoverController = _editPopoverController;
@synthesize selectedURL = _selectedURL;
@synthesize printInteractionController = _printInteractionController;

# pragma mark -
# pragma mark init

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setEditing:NO];
        [self setDocument:NO];
        
        CanadianLinenSalesforcePrintWebView *pwv = [[CanadianLinenSalesforcePrintWebView alloc] initWithFrame:CGRectMake(0, 0, 612, 792)];
        [self setPrintWebView:pwv];
    }
    return self;
}

- (void)initButtons {
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"editMode"]) {
        if (!_editButton) {
            UIImage *editButtonImage = [UIImage imageNamed:@"Pencil"];
            _editButton = [[UIBarButtonItem alloc] initWithImage:editButtonImage style:UIBarButtonItemStylePlain target:self action:@selector(showEditPopover:)];
        }
        self.navigationItem.rightBarButtonItem = _editButton;
        if ([[self selectedURL] isEqual:[NSNull null]]) {
            [_editButton setEnabled:YES];
        } else {
            [_editButton setEnabled:NO];
        }
    } else {
        self.navigationItem.rightBarButtonItem = _actionButton;
    }
}

# pragma mark -
# pragma mark awake

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self initButtons];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(defaultsChanged:)
                                                 name:NSUserDefaultsDidChangeNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(presentationChanged:)
                                                 name:CanadianLinenSalesforcePresentationChangedNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(documentChanged:)
                                                 name:CanadianLinenSalesforceDocumentChangedNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(saveChanged:)
                                                 name:CanadianLinenSalesforceSaveChangedNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(edit:)
                                                 name:CanadianLinenSalesforceDidToggleEditNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(save:)
                                                 name:CanadianLinenSalesforceDidRequestEditSaveNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reset:)
                                                 name:CanadianLinenSalesforceDidRequestEditResetNotification
                                               object:nil];
}

# pragma mark -
# pragma mark view

- (BOOL)shouldAutorotate {
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations {
    if ([self document]) {
        return UIInterfaceOrientationMaskAll;
    }
    return UIInterfaceOrientationMaskLandscape;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    if (fromInterfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
        fromInterfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        [_listButton setEnabled:NO];
    } else {
        [_listButton setEnabled:YES];
    }
}

# pragma mark -
# pragma mark notifications

- (void)defaultsChanged:(NSNotification *)notification {
    CanadianLinenSalesforcePresentationManager *presentationManager = [CanadianLinenSalesforcePresentationManager defaultManager];
    CanadianLinenSalesforceDocumentManager *documentManager = [CanadianLinenSalesforceDocumentManager defaultManager];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"editMode"]) {
        if ([_selectedURL isEqual:[presentationManager URLForPresentation]]) {
            self.navigationItem.rightBarButtonItem = _editButton;
        }
        if ([_selectedURL isEqual:[documentManager URLForDocument]]) {
           self.navigationItem.rightBarButtonItem = nil;
        }
    } else {
        self.navigationItem.rightBarButtonItem = _actionButton;
    }
 
    if ([_editPopoverController isPopoverVisible]) {
        [_editPopoverController dismissPopoverAnimated:NO];
    }
    if (_actionSheet) {
        [_actionSheet dismissWithClickedButtonIndex:[_actionSheet cancelButtonIndex] animated:NO];
        _actionSheet = nil;
    }
    if ([_selectedURL isEqual:[presentationManager URLForPresentation]]) {
        [self loadPresentation:self];
    }
    if ([_selectedURL isEqual:[documentManager URLForDocument]]) {
        [self loadDocument:self];
    }
    
    [self initButtons];
}

- (void)presentationChanged:(NSNotification *)notification {
    [self loadPresentation:self];
}

- (void)documentChanged:(NSNotification *)notification {
    [self loadDocument:self];
}

- (void)saveChanged:(NSNotification *)notification {
    [self loadSave:self];
}

# pragma mark -
# pragma mark popover

- (void)showListPopover:(id)sender {
    if ([_listPopoverController isPopoverVisible]) {
        [_listPopoverController dismissPopoverAnimated:YES];
    } else {
        if (!_listPopoverController) {
            UIViewController *viewControllerForPopover = [self.storyboard instantiateViewControllerWithIdentifier:@"listPopover"];
            _listPopoverController = [[UIPopoverController alloc] initWithContentViewController:viewControllerForPopover];
        }
        [_listPopoverController presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
}

- (void)showEditPopover:(id)sender {
    if ([_editPopoverController isPopoverVisible]) {
        [_editPopoverController dismissPopoverAnimated:YES];
    } else {
        if (!_editPopoverController) {
            UIViewController *viewControllerForPopover = [self.storyboard instantiateViewControllerWithIdentifier:@"editPopover"];
            _editPopoverController = [[UIPopoverController alloc] initWithContentViewController:viewControllerForPopover];
        }
        [_editPopoverController presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
}

# pragma mark -
# pragma mark actions

- (void)action:(id)sender {
    if (_printInteractionController) {
        [_printInteractionController dismissAnimated:YES];
        _printInteractionController = nil;
    }
    
    if (_actionSheet) {
        [_actionSheet dismissWithClickedButtonIndex:_actionSheet.cancelButtonIndex animated:YES];
        _actionSheet = nil;
        return;
    } else {
        _actionSheet = [[UIActionSheet alloc] init];
        [_actionSheet addButtonWithTitle:@"E-Mail"];
        [_actionSheet addButtonWithTitle:@"Print"];
        [_actionSheet setDelegate:self];
        [_actionSheet showFromBarButtonItem:sender animated:YES];
    }
}

- (void)email:(id)sender {
    if ([MFMailComposeViewController canSendMail]) {
        
        CanadianLinenSalesforcePresentationManager *presentationManager = [CanadianLinenSalesforcePresentationManager defaultManager];
        CanadianLinenSalesforceDocumentManager *documentManager = [CanadianLinenSalesforceDocumentManager defaultManager];
        
        MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
        [mailViewController setMailComposeDelegate:self];
        
        if ([_selectedURL isEqual:[presentationManager URLForPresentation]]) {
            [mailViewController setSubject:[presentationManager titleForPresentation]];
            [mailViewController addAttachmentData:[_printWebView pdfData] mimeType:@"application/pdf" fileName:[[presentationManager titleForPresentation] stringByAppendingPathExtension:@"pdf"]];
        }
        if ([_selectedURL isEqual:[documentManager URLForDocument]]) {
            [mailViewController setSubject:[documentManager titleForDocument]];
            [mailViewController addAttachmentData:[NSData dataWithContentsOfFile:[[documentManager URLForDocument] path]] mimeType:@"application/pdf" fileName:[documentManager titleForDocument]];
        }
        
        [self presentViewController:mailViewController animated:YES completion:NULL];
    }
}

- (void)print:(id)sender {
    if (_printInteractionController) {
        [_printInteractionController dismissAnimated:YES];
        _printInteractionController = nil;
        return;
    } else {
        _printInteractionController = [UIPrintInteractionController sharedPrintController];
        _printInteractionController.delegate = self;
        
        CanadianLinenSalesforcePresentationManager *presentationManager = [CanadianLinenSalesforcePresentationManager defaultManager];
        CanadianLinenSalesforceDocumentManager *documentManager = [CanadianLinenSalesforceDocumentManager defaultManager];

        UIPrintInfo *printInfo = [UIPrintInfo printInfo];
        printInfo.outputType = UIPrintInfoOutputGeneral;
        printInfo.jobName = [presentationManager titleForPresentation];
        printInfo.duplex = UIPrintInfoDuplexLongEdge;
        
        _printInteractionController.showsPageRange = YES;
        _printInteractionController.printInfo = printInfo;
        
        if ([_selectedURL isEqual:[presentationManager URLForPresentation]]) {
            _printInteractionController.printingItem = [_printWebView pdfData];
        }
        if ([_selectedURL isEqual:[documentManager URLForDocument]]) {
            _printInteractionController.printingItem = [NSData dataWithContentsOfFile:[[documentManager URLForDocument] path]];
        }
        
        [_printInteractionController presentFromBarButtonItem:_actionButton animated:YES completionHandler:^(UIPrintInteractionController *printController, BOOL completed, NSError *error) {
            if (!completed && error) {
                NSLog(@"Printing could not complete because of error: %@", error);
            }
        }];
    }
}

- (void)save:(id)sender {
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Enter title:"
                                                      message:nil
                                                     delegate:self
                                            cancelButtonTitle:@"Cancel"
                                            otherButtonTitles:@"OK", nil];
    [message setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [message setTag:1];
    
    [message show];
}

- (void)edit:(id)sender {
    if ([[sender object] isOn]) {
        [self setEditing:YES];
        NSLog(@"Editing... %@", [_webView stringByEvaluatingJavaScriptFromString:@"presentation.edit('true');"]);
    } else {
        [self setEditing:NO];
        NSLog(@"Editing... %@", [_webView stringByEvaluatingJavaScriptFromString:@"presentation.edit('false');"]);
    }
}

- (void)reset:(id)sender {
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Are you sure?"
                                                      message:@"This will reset all editing for this presentation."
                                                     delegate:self
                                            cancelButtonTitle:@"Cancel"
                                            otherButtonTitles:@"OK", nil];
    [message setTag:0];
    [message show];
}

- (void)loadPresentation:(id)sender {
    CanadianLinenSalesforcePresentationManager *presentationManager = [CanadianLinenSalesforcePresentationManager defaultManager];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"editMode"]) {
        self.navigationItem.rightBarButtonItem = _editButton;
    } else {
        self.navigationItem.rightBarButtonItem = _actionButton;
    }
    
    [_printWebView setData:@""];
    [_webView setData:@""];
    
    [_printWebView loadRequest:[NSURLRequest requestWithURL:[presentationManager URLForPresentation]]];
    [_webView loadRequest:[NSURLRequest requestWithURL:[presentationManager URLForPresentation]]];
    
    [_editButton setEnabled:YES];
    
    [self setDocument:NO];
    [self setSelectedURL:[presentationManager URLForPresentation]];
}

- (void)loadDocument:(id)sender {
    CanadianLinenSalesforceDocumentManager *documentManager = [CanadianLinenSalesforceDocumentManager defaultManager];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"editMode"]) {
        self.navigationItem.rightBarButtonItem = nil;
    } else {
        self.navigationItem.rightBarButtonItem = _actionButton;
    }
    
    [_printWebView setData:@""];
    [_webView setData:@""];
    
    [_webView loadRequest:[NSURLRequest requestWithURL:[documentManager URLForDocument]]];
    
    [_editButton setEnabled:NO];
    
    [self setDocument:YES];
    [self setSelectedURL:[documentManager URLForDocument]];
}

- (void)loadSave:(id)sender {
    CanadianLinenSalesforceSaveManager *saveManager = [CanadianLinenSalesforceSaveManager defaultManager];
    CanadianLinenSalesforceSave *save = [saveManager save];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"editMode"]) {
        self.navigationItem.rightBarButtonItem = _editButton;
    } else {
        self.navigationItem.rightBarButtonItem = _actionButton;
    }
    
    [_printWebView setData:[save data]];
    [_webView setData:[save data]];
    
    [_printWebView loadRequest:[NSURLRequest requestWithURL:[save url]]];
    [_webView loadRequest:[NSURLRequest requestWithURL:[save url]]];
    
    [_editButton setEnabled:YES];
    
    [self setDocument:NO];
    [self setSelectedURL:[save url]];
}

# pragma mark -
# pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            [self email:_actionButton];
            break;
        case 1:
            [self print:_actionButton];
            break;
        default:
            break;
    }
}

# pragma mark -
# pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if ([alertView tag] == 0) {
        if (buttonIndex != 0) {
            NSLog(@"Resetting... %@", [_webView stringByEvaluatingJavaScriptFromString:@"presentation.clear();"]);
        }
    }
    if ([alertView tag] == 1) {
        if (buttonIndex != 0) {
            NSLog(@"Saving... %@", [_webView stringByEvaluatingJavaScriptFromString:@"presentation.save();"]);
            
            NSString *data = [_webView stringByEvaluatingJavaScriptFromString:@"presentation.save();"];
            NSString *title = [[alertView textFieldAtIndex:0] text];
            NSString *presentation = [[CanadianLinenSalesforcePresentationManager defaultManager] titleForPresentation];
            NSURL *url = [[CanadianLinenSalesforcePresentationManager defaultManager] URLForPresentation];
            
            NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
            
            CanadianLinenSalesforceSave *save = [[CanadianLinenSalesforceSave alloc] init];
            [save setData:data];
            [save setTitle:title];
            [save setPresentation:presentation];
            [save setUrl:url];
            [save setDate:[dateFormatter stringFromDate:[NSDate date]]];
            
            [[CanadianLinenSalesforceSaveManager defaultManager] writeSave:save];
        }
    }
}

- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView {
    if ([alertView tag] == 1) {
        NSString *inputText = [[alertView textFieldAtIndex:0] text];
        if([inputText length] > 0) {
            return YES;
        } else {
            return NO;
        }
    }
    return YES;
}

# pragma mark -
# pragma mark MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [self dismissViewControllerAnimated:NO completion:NULL];
}

@end
