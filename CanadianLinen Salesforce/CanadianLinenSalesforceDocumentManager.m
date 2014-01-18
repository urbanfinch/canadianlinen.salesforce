//
//  CanadianLinenSalesforceDocumentManager.m
//  CanadianLinen Salesforce
//
//  Created by Aaron Wright on 2/15/13.
//  Copyright (c) 2013 Aaron C Wright. All rights reserved.
//

#import "CanadianLinenSalesforceDocumentManager.h"

static CanadianLinenSalesforceDocumentManager *_defaultManager = nil;

@implementation CanadianLinenSalesforceDocumentManager

@synthesize documents = _documents;
@synthesize document = _document;

# pragma mark -
# pragma mark init

+ (CanadianLinenSalesforceDocumentManager *)defaultManager {
    @synchronized(self) {
        if (_defaultManager == nil) {
            _defaultManager = [[CanadianLinenSalesforceDocumentManager alloc] init];
            [_defaultManager initialize];
        }
    }
    return _defaultManager;
}

+ (id)allocWithZone:(NSZone *)zone {
    @synchronized(self) {
        if (_defaultManager == nil) {
            return [super allocWithZone:zone];
        }
    }
    return _defaultManager;
}

+ (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (void)initialize {
    NSMutableArray *documents = [NSMutableArray array];
    
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSArray *documentsContent = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsDirectory error:NULL];
    
    for (int count = 0; count < (int)[documentsContent count]; count++)
    {
        NSString *documentPath = [documentsDirectory stringByAppendingPathComponent:[documentsContent objectAtIndex:count]];
        
        if ([[documentPath pathExtension] isEqualToString:@"pdf"]) {
            CanadianLinenSalesforceDocument *document = [[CanadianLinenSalesforceDocument alloc] init];
            [document setTitle:[documentPath lastPathComponent]];
            [document setFilename:[documentPath lastPathComponent]];
            [document setUrl:[NSURL fileURLWithPath:documentPath]];
            
            [documents addObject:document];
        }
    }
    
    if ([documents count] > 0) {
        [self setDocuments:[documents copy]];
    } else {
        [self setDocuments:[NSArray array]];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:CanadianLinenSalesforceDocumentsDidInitializeNotification object:self];
}

# pragma mark -
# pragma mark open

- (void)openDocumentURL:(NSURL *)url {
    NSURL *sourceURL = [NSURL fileURLWithPath:[url path]];
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSURL *documentURL = [[NSURL fileURLWithPath:documentsDirectory] URLByAppendingPathComponent:[sourceURL lastPathComponent]];
    NSURL *inboxURL = [NSURL fileURLWithPath:[[[NSURL fileURLWithPath:documentsDirectory] URLByAppendingPathComponent:@"Inbox"] path] isDirectory:YES];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSFileManager *fileManager = [[NSFileManager alloc] init];
        NSError *error;
        
        if (![fileManager copyItemAtURL:sourceURL toURL:documentURL error:&error]) {
            if ([fileManager removeItemAtURL:documentURL error:&error]) {
                if (![fileManager copyItemAtURL:sourceURL toURL:documentURL error:&error]) {
                    NSLog(@"Could not copy file at url: %@ to url: %@", url, documentURL);
                }
            }
        }
        
        if (![fileManager removeItemAtURL:inboxURL error:&error]) {
            NSLog(@"Could not remove inbox at url: %@ ", inboxURL);
        }
        
        [self performSelectorOnMainThread:@selector(initialize) withObject:nil waitUntilDone:NO];
    });
}

# pragma mark -
# pragma mark documents

- (NSString *)titleForDocument {
    return [_document title];
}

- (NSURL *)URLForDocument {
    return [_document url];
}

@end
