//
//  SGRootEmailCell.m
//  Signal
//
//  Created by Austin Louden on 8/28/13.
//  Copyright (c) 2013 Signal. All rights reserved.
//

#import "SGRootEmailCell.h"
#import "SGEmail.h"

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

- (void)setEmail:(SGEmail *)email
{
    senderLabel.text = email.fromName;
    subjectLabel.text = [email stringByStrippingHTML:email.subject];
    bodyLabel.text = [email stringByStrippingHTML:email.body];

    float interval = (float) (([[NSDate date] timeIntervalSinceDate: email.date]/60.0f)/60.0f)/24.0f;
    if(interval <= 1) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"hh:mm a"];
        dateLabel.text = [formatter stringFromDate:email.date];
    } else {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MMM dd"];
        dateLabel.text = [formatter stringFromDate:email.date];
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
    [super setSelected:selected animated:animated];
}

@end
