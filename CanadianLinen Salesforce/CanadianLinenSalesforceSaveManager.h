//
//  CanadianLinenSalesforceSaveManager.h
//  CanadianLinen Salesforce
//
//  Created by Aaron Wright on 2/15/13.
//  Copyright (c) 2013 Aaron C Wright. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CanadianLinenSalesforceNotifications.h"
#import "CanadianLinenSalesforceSave.h"

@interface CanadianLinenSalesforceSaveManager : NSObject

@property (nonatomic, strong) NSMutableArray *saves;
@property (nonatomic, strong) CanadianLinenSalesforceSave *save;

+ (CanadianLinenSalesforceSaveManager *)defaultManager;

- (void)initialize;
- (void)writeSave:(CanadianLinenSalesforceSave *)save;
- (void)removeSaveObjectAtIndex:(NSUInteger)index;
- (NSString *)pathForSave;
- (NSString *)titleForSave;
- (NSURL *)URLForSave;

@end
