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
        [self.contentView addSubview:subjectLabel];
        
        
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
    senderLabel.text = [email objectForKey:@"sender"];
    subjectLabel.text = [email objectForKey:@"subject"];
    bodyLabel.text = [email objectForKey:@"body"];
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    senderLabel.frame = CGRectMake(15.0f, 6.0f, self.frame.size.width, 20.0f);
    subjectLabel.frame = CGRectMake(15.0f, 17.0f, self.frame.size.width, 30.0f);
    bodyLabel.frame = CGRectMake(15.0f, 42.0f, self.frame.size.width-10.0f, 45.0f);
    [bodyLabel sizeToFit];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    //[super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
