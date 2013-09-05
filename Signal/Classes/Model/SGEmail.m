//
//  SGEmail.m
//  Signal
//
//  Created by Austin Louden on 9/3/13.
//  Copyright (c) 2013 Signal. All rights reserved.
//

#import "SGEmail.h"

@implementation SGEmail
@synthesize body = _body, date = _date, dateString = _dateString, fromName = _fromName, fromEmail = _fromEmail, modifiedDate = _modifiedDate, subject = _subject, emailID = _emailID;

- (id)initWithDictionary:(NSDictionary *)emailDictionary
{
    if (self = [super init]) {
        // set properties
        _body = [emailDictionary objectForKey:@"body"];
        _fromName = [[[emailDictionary objectForKey:@"meta"] objectForKey:@"from"] objectForKey:@"name"];
        _fromEmail = [[[emailDictionary objectForKey:@"meta"] objectForKey:@"from"] objectForKey:@"email"];
        _dateString = [[emailDictionary objectForKey:@"meta"] objectForKey:@"date"];
        _subject = [emailDictionary objectForKey:@"subject"];
        
        // dates
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"EEE, MMM dd, yyyy 'at' hh:mm a"];
        _date = [dateFormat dateFromString:[[emailDictionary objectForKey:@"meta"] objectForKey:@"date"]];
        _modifiedDate = [NSDate dateWithTimeIntervalSince1970:[[emailDictionary objectForKey:@"modified"] doubleValue]];

    }
    
    return self;
}

- (NSString *)stringByStrippingHTML:(NSString*)string
{
    NSRange r;
    while ((r = [string rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
        string = [string stringByReplacingCharactersInRange:r withString:@""];
    return string;
}



@end
