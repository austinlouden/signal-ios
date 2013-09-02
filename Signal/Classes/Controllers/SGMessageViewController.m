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
        NSLog(@"%@", _email);
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.view.backgroundColor = [UIColor whiteColor];
    
    // header
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, 40.0f)];
    headerView.backgroundColor = [UIColor colorWithWhite:0.98f alpha:0.95f];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(24.0f, 2.0f, 40.0f, 40.0f);
    backButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:15.0f];
    [backButton setTitle:@"Inbox" forState:UIControlStateNormal];
    [backButton setBackgroundColor:[UIColor clearColor]];
    [backButton setTitleColor:[UIColor colorWithRed:(0.0f/255.0f) green:(102.0f/255.0f) blue:(255.0f/255.0f) alpha:1.0f] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *backArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"backButton.png"]];
    backArrow.frame = CGRectMake(4.0f, 8.0f, 20.5f, 26.0f);
    [headerView addSubview:backArrow];
    
    UIView *divider = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 39.5f, self.view.frame.size.width, 0.5f)];
    divider.backgroundColor = [UIColor colorWithWhite:(178.0f/255.0f) alpha:1.0f];
    
    [headerView addSubview:backButton];
    [headerView addSubview:divider];
    [self.view addSubview:headerView];

    // web view
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0.0f, 40.0f, self.view.frame.size.width, self.view.frame.size.height - 40.0f)];
    webView.delegate = self;
    webView.scrollView.backgroundColor = [UIColor whiteColor];
    webView.backgroundColor = [UIColor whiteColor];
    for (UIView* subView in [webView subviews])
    {
        if ([subView isKindOfClass:[UIScrollView class]]) {
            for (UIView* shadowView in [subView subviews])
            {
                if ([shadowView isKindOfClass:[UIImageView class]]) {
                    [shadowView setHidden:YES];
                }
            }
        }
    }
    
    NSString *testBody = [_email objectForKey:@"body"];
    
    NSString *wrappedBody = [NSString stringWithFormat:@"<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\"><meta name=\"viewport\" id=\"iphone-viewport\" content=\"width=device-width, initial-scale=1.0\"><div id='signal_body'>%@</div><script>document.getElementById('signal_body').setAttribute('contentEditable','true')</script>",testBody];
    [webView loadHTMLString:wrappedBody baseURL:nil];
    webView.keyboardDisplayRequiresUserAction = NO;
    
    // labels inside the web view's scroll view
    UITextView *subjectField = [[UITextView alloc] initWithFrame:CGRectMake(10.0f, 0.0f, self.view.frame.size.width, 100.0f)];
    subjectField.text = [_email objectForKey:@"subject"];
    subjectField.backgroundColor = [UIColor clearColor];
    subjectField.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:15.0f];
    [subjectField sizeToFit];
    subjectField.frame = CGRectMake(10.0f, -subjectField.frame.size.height+2, self.view.frame.size.width, subjectField.frame.size.height-5);
    [webView.scrollView addSubview:subjectField];
    
    UILabel *senderLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, 30.0f)];
    senderLabel.text = [[[_email objectForKey:@"meta"] objectForKey:@"from"] objectForKey:@"name"];
    senderLabel.textColor = [UIColor colorWithRed:0.0f green:122.0f/255.0f blue:1.0f alpha:1.0f];
    senderLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:12.0f];
    senderLabel.backgroundColor = [UIColor clearColor];
    [senderLabel sizeToFit];
    senderLabel.frame = CGRectMake(18.0f, -senderLabel.frame.size.height-subjectField.frame.size.height+5.0f, senderLabel.frame.size.width, senderLabel.frame.size.height);
    [webView.scrollView addSubview:senderLabel];
    
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, 30.0f)];
    dateLabel.text = [[_email objectForKey:@"meta"] objectForKey:@"date"];
    dateLabel.textColor = [UIColor colorWithWhite:0.1f alpha:1.0f];
    dateLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:12.0f];
    dateLabel.backgroundColor = [UIColor clearColor];
    [dateLabel sizeToFit];
    dateLabel.frame = CGRectMake(senderLabel.frame.size.width+senderLabel.frame.origin.x+5.0f, -senderLabel.frame.size.height-subjectField.frame.size.height+5.0f, self.view.frame.size.width - senderLabel.frame.size.width, senderLabel.frame.size.height);
    [webView.scrollView addSubview:dateLabel];
    
    UIView *subjectDivider = [[UIView alloc] initWithFrame:CGRectMake(15.0f, -2.0f, self.view.frame.size.width-15.0f, 0.3f)];
    subjectDivider.backgroundColor = [UIColor colorWithWhite:0.7f alpha:1.0f];
    [webView.scrollView addSubview:subjectDivider];

    webView.scrollView.contentInset = UIEdgeInsetsMake(subjectField.frame.size.height+senderLabel.frame.size.height, 0.0f, 0.0f, 0.0f);
    webView.scalesPageToFit = YES;
    
    [self.view addSubview:webView];
}

#pragma mark - Actions

- (void)backPressed
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    CGSize contentSize = webView.scrollView.contentSize;
    CGSize viewSize = self.view.bounds.size;
    
    float rw = viewSize.width / contentSize.width;
    
    webView.scrollView.minimumZoomScale = rw;
    webView.scrollView.maximumZoomScale = rw;
    webView.scrollView.zoomScale = rw;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
