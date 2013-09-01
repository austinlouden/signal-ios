//
//  SGRootEmailCell.m
//  Signal
//
//  Created by Austin Louden on 8/28/13.
//  Copyright (c) 2013 Signal. All rights reserved.
//

#import "SGRootEmailCell.h"

@interface SGRootEmailCell ()
{
    UILabel *senderLabel;
    UILabel *subjectLabel;
    UILabel *bodyLabel;
    UILabel *dateLabel;
}

@end

@implementation SGRootEmailCell
@synthesize email = _email;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        senderLabel = [[UILabel alloc] init];
        senderLabel.backgroundColor = [UIColor clearColor];
        senderLabel.textColor = [UIColor colorWithWhite:0.3f alpha:1.0f];
        senderLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:12.0f];
        [self.contentView addSubview:senderLabel];
        
        subjectLabel = [[UILabel alloc] init];
        subjectLabel.backgroundColor = [UIColor clearColor];
        subjectLabel.textColor = [UIColor colorWithWhite:0.1f alpha:1.0f];
        subjectLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0f];
        subjectLabel.numberOfLines = 2;
        [self.contentView addSubview:subjectLabel];
        
        dateLabel = [[UILabel alloc] init];
        dateLabel.backgroundColor = [UIColor clearColor];
        dateLabel.textColor = [UIColor colorWithWhite:0.5f alpha:1.0f];
        dateLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:12.0f];
        dateLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:dateLabel];
        
        bodyLabel = [[UILabel alloc] init];
        bodyLabel.backgroundColor = [UIColor clearColor];
        bodyLabel.textColor = [UIColor colorWithWhite:0.5f alpha:1.0f];
        bodyLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:12.0f];
        bodyLabel.numberOfLines = 2;
        bodyLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.contentView addSubview:bodyLabel];
    }
    return self;
}

- (void)setEmail:(NSDictionary *)email
{
    senderLabel.text = [[[email objectForKey:@"meta"] objectForKey:@"from"] objectForKey:@"name"];
    subjectLabel.text = [self stringByStrippingHTML:[email objectForKey:@"subject"]];
    bodyLabel.text = [self stringByStrippingHTML:[email objectForKey:@"body"]];

    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"EEE, MMM dd, yyyy 'at' hh:mm a"];
    NSDate *date = [dateFormat dateFromString:[[email objectForKey:@"meta"] objectForKey:@"date"]];
    float interval = (float) (([[NSDate date] timeIntervalSinceDate: date]/60.0f)/60.0f)/24.0f;
    if(interval <= 1) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"hh:mm a"];
        dateLabel.text = [formatter stringFromDate:date];
    } else {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MMM dd"];
        dateLabel.text = [formatter stringFromDate:date];
    }
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    senderLabel.frame = CGRectMake(15.0f, 6.0f, self.frame.size.width-20.0f, 20.0f);
    subjectLabel.frame = CGRectMake(15.0f, 22.0f, self.frame.size.width-30.0f, 30.0f);
    [subjectLabel sizeToFit];
    dateLabel.frame = CGRectMake(0.0f, 6.0f, self.frame.size.width-15.0f, 20.0f);
    bodyLabel.frame = CGRectMake(15.0f, subjectLabel.frame.size.height+24.0f, self.frame.size.width-24.0f, 45.0f);
    [bodyLabel sizeToFit];
    
    // if the subject label is 2 lines, reduce the height of the body
    if(subjectLabel.frame.size.height >= 22.0f) {
        bodyLabel.numberOfLines = 1;
        bodyLabel.frame = CGRectMake(15.0f, subjectLabel.frame.size.height+24.0f, self.frame.size.width-44.0f, 20.0f);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    //[super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Helpers

- (NSString *)stringByStrippingHTML:(NSString*)s
{
    NSRange r;
    while ((r = [s rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
        s = [s stringByReplacingCharactersInRange:r withString:@""];
    return s;
}

- (NSInteger)midnightsFromDate:(NSDate *)startDate toDate:(NSDate *)endDate
{
    NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
    NSInteger startDay = [calendar ordinalityOfUnit:NSDayCalendarUnit
                                             inUnit:NSEraCalendarUnit
                                            forDate:startDate];
    NSInteger endDay = [calendar ordinalityOfUnit:NSDayCalendarUnit
                                           inUnit:NSEraCalendarUnit
                                          forDate:endDate];
    return endDay - startDay;
}

@end
