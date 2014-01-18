//
//  CanadianLinenSalesforceDocumentManager.h
//  CanadianLinen Salesforce
//
//  Created by Aaron Wright on 2/15/13.
//  Copyright (c) 2013 Aaron C Wright. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CanadianLinenSalesforceNotifications.h"
#import "CanadianLinenSalesforceDocument.h"

@interface CanadianLinenSalesforceDocumentManager : NSObject

@property (nonatomic, strong) NSArray *documents;
@property (nonatomic, strong) CanadianLinenSalesforceDocument *document;

+ (CanadianLinenSalesforceDocumentManager *)defaultManager;

- (void)initialize;
- (void)openDocumentURL:(NSURL *)url;
- (NSString *)titleForDocument;
- (NSURL *)URLForDocument;

@end
