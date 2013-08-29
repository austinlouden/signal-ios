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
    self.title = @"Inbox";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithWhite:0.7f alpha:1.0f];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize
                                                                                          target:self
                                                                                          action:@selector(slidePressed)];
    
    // data source
    NSString *path = [[NSBundle mainBundle] pathForResource:@"SampleMail" ofType:@"plist"];
    emails = [[NSArray alloc] initWithContentsOfFile:path];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
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
