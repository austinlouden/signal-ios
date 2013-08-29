//
//  SGMessageViewController.m
//  Signal
//
//  Created by Austin Louden on 8/29/13.
//  Copyright (c) 2013 Signal. All rights reserved.
//

#import "SGMessageViewController.h"

@interface SGMessageViewController ()
@property (nonatomic, strong) NSDictionary *email;
@end

@implementation SGMessageViewController
@synthesize email = _email;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithEmail:(NSDictionary *)email
{
    if (self = [super init]) {
        _email = email;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.view.backgroundColor = [UIColor whiteColor];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, 40.0f)];
    headerView.backgroundColor = [UIColor colorWithWhite:0.98f alpha:0.95f];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(8.0f, 0.0f, 40.0f, 40.0f);
    backButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:15.0f];
    [backButton setTitle:@"Back" forState:UIControlStateNormal];
    [backButton setBackgroundColor:[UIColor clearColor]];
    [backButton setTitleColor:[UIColor colorWithRed:2.0f/255.0f green:173.0f/255.0f blue:234.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];

    /*
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(8.0f, 0.0f, 20.0f, 40.0f)];
    headerLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:25.0f];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.text = @"Inbox";
    headerLabel.textColor = [UIColor colorWithRed:2.0f/255.0f green:173.0f/255.0f blue:234.0f/255.0f alpha:1.0f];
    headerLabel.textAlignment = NSTextAlignmentLeft;
     */
    
    UIView *divider = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 39.0f, self.view.frame.size.width, 0.5f)];
    divider.backgroundColor = [UIColor colorWithWhite:0.5f alpha:1.0f];
    
    [headerView addSubview:backButton];
    [headerView addSubview:divider];
    [self.view addSubview:headerView];
}

- (void)backPressed
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
