//
//  CanadianLinenSalesforceSaveManager.m
//  CanadianLinen Salesforce
//
//  Created by Aaron Wright on 2/15/13.
//  Copyright (c) 2013 Aaron C Wright. All rights reserved.
//

#import "CanadianLinenSalesforceSaveManager.h"

static CanadianLinenSalesforceSaveManager *_defaultManager = nil;

@implementation CanadianLinenSalesforceSaveManager

@synthesize saves = _saves;
@synthesize save = _save;

# pragma mark -
# pragma mark init

+ (CanadianLinenSalesforceSaveManager *)defaultManager {
    @synchronized(self) {
        if (_defaultManager == nil) {
            _defaultManager = [[CanadianLinenSalesforceSaveManager alloc] init];
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
    NSMutableArray *saves = [NSMutableArray array];
    [self setSaves:saves];
    
    NSArray *archivedSaves = [NSKeyedUnarchiver unarchiveObjectWithFile:[self pathForSave]];
    
    if ([archivedSaves count] > 0) {
        [self setSaves:[archivedSaves mutableCopy]];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:CanadianLinenSalesforceSavesDidInitializeNotification object:self];
}

# pragma mark -
# pragma mark write / remove

- (void)writeSave:(CanadianLinenSalesforceSave *)save {
    [_saves addObject:save];
    
    [NSKeyedArchiver archiveRootObject:_saves toFile:[self pathForSave]];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:CanadianLinenSalesforceSavesDidChangeNotification object:self];
}

- (void)removeSaveObjectAtIndex:(NSUInteger)index {
    [_saves removeObjectAtIndex:index];
    
    [NSKeyedArchiver archiveRootObject:_saves toFile:[self pathForSave]];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:CanadianLinenSalesforceSavesDidChangeNotification object:self];
}

# pragma mark -
# pragma mark saves

- (NSString *)pathForSave {
    NSString *docsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filename = [docsPath stringByAppendingPathComponent:@"Saves"];
    return filename;
}

- (NSString *)titleForSave {
    return [_save title];
}

- (NSURL *)URLForSave {
    return [_save url];
}

@end
