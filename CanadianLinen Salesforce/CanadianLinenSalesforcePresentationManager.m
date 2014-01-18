//
//  CanadianLinenSalesforcePresentationManager.m
//  CanadianLinen Salesforce
//
//  Created by Aaron C Wright on 11/26/12.
//  Copyright (c) 2012 Aaron C Wright. All rights reserved.
//

#import "CanadianLinenSalesforcePresentationManager.h"

static CanadianLinenSalesforcePresentationManager *_defaultManager = nil;

@implementation CanadianLinenSalesforcePresentationManager

@synthesize presentations = _presentations;
@synthesize presentation = _presentation;

# pragma mark -
# pragma mark init

+ (CanadianLinenSalesforcePresentationManager *)defaultManager {
    @synchronized(self) {
        if (_defaultManager == nil) {
            _defaultManager = [[CanadianLinenSalesforcePresentationManager alloc] init];
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
    NSMutableArray *presentations = [NSMutableArray array];
    
    NSString *cachesDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];

    NSArray *cachesContent = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:cachesDirectory error:NULL];
    
    for (int count = 0; count < (int)[cachesContent count]; count++)
    {
        NSString *packagePath = [cachesDirectory stringByAppendingPathComponent:[cachesContent objectAtIndex:count]];
        NSString *packagePlistPath = [packagePath stringByAppendingPathComponent:@"/package.plist"];
        NSDictionary *packageDict = [[NSDictionary alloc] initWithContentsOfFile:packagePlistPath];
        NSArray *packagePresentations = [packageDict valueForKey:@"presentations"];
        
        for (NSDictionary *packagePresentationDict in packagePresentations) {
            CanadianLinenSalesforcePresentation *presentation = [[CanadianLinenSalesforcePresentation alloc] init];
            [presentation setTitle:[packagePresentationDict valueForKey:@"title"]];
            [presentation setFilename:[packagePresentationDict valueForKey:@"filename"]];
            
            NSURL *baseURL = [NSURL URLWithString:[packagePath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            NSURL *URL = [[baseURL URLByAppendingPathComponent:[presentation filename]] URLByAppendingPathExtension:@"html"];

            [presentation setUrl:URL];
            
            [presentations addObject:presentation];
        }
    }
    
    if ([presentations count] > 0) {
        [self setPresentations:[presentations copy]];
    } else {
        [self setPresentations:[NSArray array]];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:CanadianLinenSalesforcePresentationsDidInitializeNotification object:self];
}

# pragma mark -
# pragma mark open

- (void)openPresentationURL:(NSURL *)url {
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
        
        [self performSelectorOnMainThread:@selector(rebuildPresentationCache) withObject:nil waitUntilDone:NO];
    });
}

# pragma mark -
# pragma mark rebuild

- (void)rebuildPresentationCache {
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *cachesDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSFileManager *fileManager = [[NSFileManager alloc] init];
        NSError *error;
        
        NSArray *cachesContent = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:cachesDirectory error:NULL];
        for (int count = 0; count < (int)[cachesContent count]; count++)
        {
            NSURL *contentURL = [NSURL fileURLWithPath:[cachesDirectory stringByAppendingPathComponent:[cachesContent objectAtIndex:count]]];
            if (![fileManager removeItemAtURL:contentURL error:&error]) {
                NSLog(@"Could not remove file at path: %@", contentURL);
            }
        }
        
        ZipArchive *za = [[ZipArchive alloc] init];
        
        NSArray *documentsContent = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsDirectory error:NULL];
        for (int count = 0; count < (int)[documentsContent count]; count++)
        {
            if ([[[documentsContent objectAtIndex:count] pathExtension] isEqualToString:@"appdz"]) {
                NSString *documentPath = [documentsDirectory stringByAppendingPathComponent:[documentsContent objectAtIndex:count]];
                if ([za UnzipOpenFile:documentPath]) {
                    [za UnzipFileTo:cachesDirectory overWrite:YES];
                    [za UnzipCloseFile];
                }
            }
        }
        
        [self performSelectorOnMainThread:@selector(initialize) withObject:nil waitUntilDone:NO];
    });
}

# pragma mark -
# pragma mark presentations

- (NSString *)titleForPresentation {
    return [_presentation title];
}

- (NSURL *)URLForPresentation {
    return [_presentation url];
}

@end