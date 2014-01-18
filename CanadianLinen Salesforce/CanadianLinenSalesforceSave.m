//
//  CanadianLinenSalesforceSave.m
//  CanadianLinen Salesforce
//
//  Created by Aaron C Wright on 7/21/13.
//  Copyright (c) 2013 Aaron C Wright. All rights reserved.
//

#import "CanadianLinenSalesforceSave.h"

@implementation CanadianLinenSalesforceSave

@synthesize title = _title;
@synthesize presentation = _presentation;
@synthesize date = _date;
@synthesize data = _data;
@synthesize url = _url;

# pragma mark -
# pragma mark init

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        [self setTitle:[aDecoder decodeObjectForKey:@"title"]];
        [self setPresentation:[aDecoder decodeObjectForKey:@"presentation"]];
        [self setDate:[aDecoder decodeObjectForKey:@"date"]];
        [self setData:[aDecoder decodeObjectForKey:@"data"]];
        [self setUrl:[NSURL URLWithString:[aDecoder decodeObjectForKey:@"url"]]];
    }
    return self;
}

# pragma mark -
# pragma mark serialization

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_title forKey:@"title"];
    [aCoder encodeObject:_presentation forKey:@"presentation"];
    [aCoder encodeObject:_date forKey:@"date"];
    [aCoder encodeObject:_data forKey:@"data"];
    [aCoder encodeObject:[_url absoluteString] forKey:@"url"];
}

@end
