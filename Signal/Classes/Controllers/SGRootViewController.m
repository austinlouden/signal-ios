//
//  SGRootViewController.m
//  Signal
//
//  Created by Austin Louden on 8/28/13.
//  Copyright (c) 2013 Signal. All rights reserved.
//

#import "SGRootViewController.h"

#import "SGRootEmailCell.h"

#import "IIViewDeckController.h"
#import <QuartzCore/QuartzCore.h>

@interface SGRootViewController ()
{
    NSArray *emails;
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
    
    // data source
    NSString *path = [[NSBundle mainBundle] pathForResource:@"SampleMail" ofType:@"plist"];
    emails = [[NSArray alloc] initWithContentsOfFile:path];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.contentInset = UIEdgeInsetsMake(40,0,0,0);
    [self.view addSubview:_tableView];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, 40.0f)];
    headerView.backgroundColor = [UIColor whiteColor];
    headerView.alpha = 0.95f;
    
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
    NSLog(@"%d", emails.count);
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
