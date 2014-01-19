//
//  CanadianLinenSalesforcePresentationManager.h
//  CanadianLinen Salesforce
//
//  Created by Aaron C Wright on 11/26/12.
//  Copyright (c) 2012 Aaron C Wright. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking/AFNetworking.h"
#import "CanadianLinenSalesforceNotifications.h"
#import "CanadianLinenSalesforcePresentation.h"
#import "ZipArchive.h"

@interface CanadianLinenSalesforcePresentationManager : NSObject

@property (nonatomic, strong) NSArray *presentations;
@property (nonatomic, strong) CanadianLinenSalesforcePresentation *presentation;

+ (CanadianLinenSalesforcePresentationManager *)defaultManager;

- (void)initialize;
- (void)downloadPresentation;
- (void)openPresentationURL:(NSURL *)url;
- (void)rebuildPresentationCache;
- (NSString *)titleForPresentation;
- (NSURL *)URLForPresentation;

@end
