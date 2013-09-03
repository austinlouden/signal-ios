//
//  SGEmail.h
//  Signal
//
//  Created by Austin Louden on 9/3/13.
//  Copyright (c) 2013 Signal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SGEmail : NSObject
@property (nonatomic, strong) NSString *body;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSString *dateString;
@property (nonatomic, strong) NSString *fromName;
@property (nonatomic, strong) NSString *fromEmail;
@property (nonatomic, strong) NSDate *modifiedDate;
@property (nonatomic, strong) NSString *subject;
- (id)initWithDictionary:(NSDictionary *)emailDictionary;
- (NSString *)stringByStrippingHTML:(NSString*)string;
@end
