//
//  SGMessageViewController.m
//  Signal
//
//  Created by Austin Louden on 8/29/13.
//  Copyright (c) 2013 Signal. All rights reserved.
//

#import "SGMessageViewController.h"
#import "SGEmail.h"
#import <Firebase/Firebase.h>

#define HEADER_HEIGHT 50.0f

@interface SGMessageViewController ()
{
    Firebase *firebase;
}
@property (nonatomic, strong) SGEmail *email;
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

- (id)initWithEmail:(SGEmail *)email
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
    
    // Create a reference to a Firebase location
    firebase = [[Firebase alloc] initWithUrl:@"https://signal.firebaseio.com/users/fdb87488041e05f32d63140ba99bcf9f"];
    [firebase authWithCredential:@"eyJhbGciOiAiSFMyNTYiLCAidHlwIjogIkpXVCJ9.eyJhZG1pbiI6IHRydWUsICJpYXQiOiAxMzc4NDAxNTUxLCAiZXhwaXJlcyI6IDEzNzU4MDk1NTEsICJkIjogeyJlbWFpbF9oYXNoIjogIjg2Mjg4NjM1ZTU4NTk3NWNlY2UyMjRhZmM4M2VhOGU1IiwgImRvbWFpbiI6ICJnbWFpbC5jb21kIiwgImV4cGlyZXMiOiAxMzc1ODA5NTUxfSwgInYiOiAwfQ.O2yd-GcFILep7bHj8_7E6XC7Z-gIPgAKQKNZAzfq-Gg" withCompletionBlock:^(NSError *error, id data) {
        ;
    } withCancelBlock:^(NSError *error) {
        ;
    }];
    
    /* Read data and react to changes
    [firebase observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        //NSLog(@"%@ -> %@", snapshot.name, snapshot.value);
    }];
     */
    
    // header
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, HEADER_HEIGHT)];
    headerView.backgroundColor = [UIColor colorWithWhite:0.98f alpha:0.95f];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0.0f, 11.0f, 80.0f, 40.0f);
    backButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:15.0f];
    [backButton setTitle:@"   Inbox" forState:UIControlStateNormal];
    [backButton setBackgroundColor:[UIColor clearColor]];
    [backButton setTitleColor:[UIColor colorWithRed:(0.0f/255.0f) green:(102.0f/255.0f) blue:(255.0f/255.0f) alpha:1.0f] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *backArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"backButton.png"]];
    backArrow.frame = CGRectMake(4.0f, 18.0f, 20.5f, 26.0f);
    [headerView addSubview:backArrow];
    
    UIImageView *archiveButton = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"archiveButton.png"]];
    archiveButton.frame = CGRectMake(288.0f, 22.0f, 28.0f, 20.5f);
    [headerView addSubview:archiveButton];
    
    UIImageView *replyButton = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"replyButton.png"]];
    replyButton.frame = CGRectMake(250.0f, 22.0f, 33.0f, 20.5f);
    [headerView addSubview:replyButton];
    
    UIView *divider = [[UIView alloc] initWithFrame:CGRectMake(0.0f, HEADER_HEIGHT-0.5f, self.view.frame.size.width, 0.5f)];
    divider.backgroundColor = [UIColor colorWithWhite:(178.0f/255.0f) alpha:1.0f];
    
    [headerView addSubview:backButton];
    [headerView addSubview:divider];
    [self.view addSubview:headerView];

    // web view
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0.0f, HEADER_HEIGHT, self.view.frame.size.width, self.view.frame.size.height - 40.0f)];
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
    
    NSString *testBody = _email.body;
    NSString *wrappedBody = [NSString stringWithFormat:@"<html style=\"font-family:Helvetica;\"><meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\"><meta name=\"viewport\" id=\"iphone-viewport\" content=\"width=device-width, initial-scale=1.0\"><div id='signal_body'>%@</div><script>document.getElementById('signal_body').setAttribute('contentEditable','true')</script>",testBody];
    [webView loadHTMLString:wrappedBody baseURL:nil];
    webView.keyboardDisplayRequiresUserAction = NO;
    
    // labels inside the web view's scroll view
    UITextView *subjectField = [[UITextView alloc] initWithFrame:CGRectMake(10.0f, 0.0f, self.view.frame.size.width, 100.0f)];
    subjectField.text = [_email stringByStrippingHTML:_email.subject];
    subjectField.tag = 12;
    subjectField.delegate = self;
    subjectField.backgroundColor = [UIColor clearColor];
    subjectField.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:15.0f];
    [subjectField sizeToFit];
    subjectField.frame = CGRectMake(10.0f, -subjectField.frame.size.height+2, self.view.frame.size.width, subjectField.frame.size.height-5);
    [webView.scrollView addSubview:subjectField];
    
    UILabel *senderLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, 30.0f)];
    senderLabel.text = _email.fromName;
    senderLabel.textColor = [UIColor colorWithRed:0.0f green:122.0f/255.0f blue:1.0f alpha:1.0f];
    senderLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:12.0f];
    senderLabel.backgroundColor = [UIColor clearColor];
    [senderLabel sizeToFit];
    senderLabel.frame = CGRectMake(18.0f, -senderLabel.frame.size.height-subjectField.frame.size.height+5.0f, senderLabel.frame.size.width, senderLabel.frame.size.height);
    [webView.scrollView addSubview:senderLabel];
    
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, 30.0f)];
    dateLabel.text = _email.dateString;
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
    
    CGFloat width = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollWidth;"] floatValue];
    CGFloat height = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight;"] floatValue];

    float zoom = self.view.frame.size.width/width;
    webView.scrollView.zoomScale = zoom;
    webView.scrollView.contentSize = CGSizeMake(width, height);
     
    
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView
{
    [[[[firebase childByAppendingPath:@"emails"] childByAppendingPath:_email.emailID] childByAppendingPath:@"subject"] setValue:textView.text];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
