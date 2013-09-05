//
//  SGRootViewController.m
//  Signal
//
//  Created by Austin Louden on 8/28/13.
//  Copyright (c) 2013 Signal. All rights reserved.
//

#import "SGRootViewController.h"

#import "SGMessageViewController.h"
#import "SGRootEmailCell.h"
#import "SGAPIClient.h"
#import "SGEmail.h"

#import "IIViewDeckController.h"
#import <QuartzCore/QuartzCore.h>
#import <Firebase/Firebase.h>

#define HEADER_HEIGHT 50.0f

@interface SGRootViewController ()
{
    NSMutableArray *emails;
}
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation SGRootViewController
@synthesize tableView = _tableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBarHidden = YES;
    
    // create the table view
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.contentInset = UIEdgeInsetsMake(HEADER_HEIGHT-20.0f,0,0,0);
    _tableView.hidden = YES;
    [self.view addSubview:_tableView];
    
    emails = [NSMutableArray array];
    [self getEmails];
    [self setupUI];
}

#pragma mark - Setup

- (void)getEmails
{
    UIActivityIndicatorView *aiView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    aiView.center = self.view.center;
    aiView.hidesWhenStopped = YES;
    [self.view addSubview:aiView];
    [aiView startAnimating];
    
    NSString *authToken = @"eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjEzODA4NjM0MTIsImQiOnsiZW1haWxfaGFzaCI6ImZkYjg3NDg4MDQxZTA1ZjMyZDYzMTQwYmE5OWJjZjlmIiwiZG9tYWluIjoiZ21haWwuY29tIiwidGltZV9oYXNoIjoiMC4yNDY0NTAwMCAxMzc4MjcxNDEyIiwiYWRtaW4iOmZhbHNlfSwidiI6MCwiaWF0IjoxMzc4MjcxNDEyfQ.Zl2wB0Yf-D2m3d2yfkVqq7QmYhtvJBqpGnWX2AG4fd0";
    
    // get the email JSON
    [[SGAPIClient sharedClient] getPath:@"users/fdb87488041e05f32d63140ba99bcf9f.json" parameters:@{@"auth": authToken} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        for(int i=0; i<[[responseObject objectForKey:@"emails"] allKeys].count; i++) {
            SGEmail *email = [[SGEmail alloc] initWithDictionary:[[responseObject objectForKey:@"emails"] objectForKey:[[[responseObject objectForKey:@"emails"] allKeys] objectAtIndex:i]]];
            [emails addObject:email];
        }
        
        // sort the email array by date (most recent first)
        [emails sortUsingComparator:^NSComparisonResult(SGEmail *email1, SGEmail *email2) {
            NSDate *first = email1.date;
            NSDate *second = email2.date;
            return [second compare:first];
        }];
        
        [_tableView reloadData];
        [aiView stopAnimating];
        _tableView.hidden = NO;
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
    }];
    
}

- (void)setupUI
{
    // create the header
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, HEADER_HEIGHT)];
    headerView.backgroundColor = [UIColor colorWithWhite:(248.0f/255.0f) alpha:1.0f];
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 6.0f, self.view.frame.size.width, HEADER_HEIGHT)];
    headerLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:15.0f];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.text = @"Inbox";
    headerLabel.textColor = [UIColor colorWithWhite:0.1f alpha:1.0f];
    headerLabel.textAlignment = NSTextAlignmentCenter;
    
    UIView *divider = [[UIView alloc] initWithFrame:CGRectMake(0.0f, HEADER_HEIGHT-0.5f, self.view.frame.size.width, 0.5f)];
    divider.backgroundColor = [UIColor colorWithWhite:0.5f alpha:1.0f];
    
    [headerView addSubview:headerLabel];
    [headerView addSubview:divider];
    [self.view addSubview:headerView];
}

#pragma mark - Actions

- (void)slidePressed
{
    [self.viewDeckController toggleLeftViewAnimated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return emails ? emails.count : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SGRootEmailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell Identifier"];
    if (!cell) {
        cell = [[SGRootEmailCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell Identifier"];
    }
    
    cell.email = [emails objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 87.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SGMessageViewController *messageViewController = [[SGMessageViewController alloc] initWithEmail:[emails objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:messageViewController animated:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
