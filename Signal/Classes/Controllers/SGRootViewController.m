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

#import "IIViewDeckController.h"
#import <QuartzCore/QuartzCore.h>
#import <Firebase/Firebase.h>

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
    _tableView.contentInset = UIEdgeInsetsMake(40,0,0,0);
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
    aiView.frame = CGRectMake(120.0f, 200.0f, 0.0f, 0.0f);
    aiView.hidesWhenStopped = YES;
    [self.view addSubview:aiView];
    [aiView startAnimating];
    
    NSString *authToken = @"eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJkIjp7ImVtYWlsX2hhc2giOiJmZGI4NzQ4ODA0MWUwNWYzMmQ2MzE0MGJhOTliY2Y5ZiIsImRvbWFpbiI6ImdtYWlsLmNvbSIsImV4cCI6MTM5MzcwNTYyNywidGltZV9oYXNoIjoiMC4xOTQ4NDcwMCAxMzc4MTUzNjI3IiwiYWRtaW4iOmZhbHNlfSwidiI6MCwiaWF0IjoxMzc4MTUzNjI3fQ.TLlR0lMdUpcd43y_DkevxOcS2A2ZYaJBFxcuCEoS9jw";
    
    // get the email JSON
    [[SGAPIClient sharedClient] getPath:@"users/fdb87488041e05f32d63140ba99bcf9f.json" parameters:@{@"auth": authToken} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        for(int i=0; i<[[responseObject objectForKey:@"emails"] allKeys].count; i++) {
            [emails addObject:[[responseObject objectForKey:@"emails"] objectForKey:[[[responseObject objectForKey:@"emails"] allKeys] objectAtIndex:i]]];
        }
        
        // sort the email array by date (most recent first)
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"EEE, MMM dd, yyyy 'at' hh:mm a"];
        [emails sortUsingComparator:^NSComparisonResult(NSDictionary *obj1, NSDictionary *obj2) {
            NSDate *first = [dateFormat dateFromString:[[obj1 objectForKey:@"meta"] objectForKey:@"date"]];
            NSDate *second = [dateFormat dateFromString:[[obj2 objectForKey:@"meta"] objectForKey:@"date"]];
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
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, 40.0f)];
    headerView.backgroundColor = [UIColor colorWithWhite:(248.0f/255.0f) alpha:0.95f];
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, 40.0f)];
    headerLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:15.0f];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.text = @"Inbox";
    headerLabel.textColor = [UIColor colorWithWhite:0.1f alpha:1.0f];
    headerLabel.textAlignment = NSTextAlignmentCenter;
    
    UIView *divider = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 39.0f, self.view.frame.size.width, 0.5f)];
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
