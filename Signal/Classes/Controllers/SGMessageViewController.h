//
//  SGMessageViewController.h
//  Signal
//
//  Created by Austin Louden on 8/29/13.
//  Copyright (c) 2013 Signal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SGMessageViewController : UIViewController <UIWebViewDelegate>
- (id)initWithEmail:(NSDictionary *)email;
@end
