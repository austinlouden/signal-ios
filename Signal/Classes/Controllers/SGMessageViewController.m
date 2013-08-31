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
    
    // header
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, 40.0f)];
    headerView.backgroundColor = [UIColor colorWithWhite:0.98f alpha:0.95f];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(8.0f, 0.0f, 40.0f, 40.0f);
    backButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:15.0f];
    [backButton setTitle:@"<" forState:UIControlStateNormal];
    [backButton setBackgroundColor:[UIColor clearColor]];
    [backButton setTitleColor:[UIColor colorWithWhite:0.1f alpha:1.0f] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *divider = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 39.5f, self.view.frame.size.width, 0.5f)];
    divider.backgroundColor = [UIColor colorWithWhite:0.5f alpha:1.0f];
    
    [headerView addSubview:backButton];
    [headerView addSubview:divider];
    [self.view addSubview:headerView];

    // web view
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0.0f, 40.0f, self.view.frame.size.width, self.view.frame.size.height - 40.0f)];
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
    
    NSString *testBody = @"<div id=\":dj\" style=\"overflow: hidden;\"><div dir=\"ltr\"><div class=\"gmail_default\" style=\"font-family:arial,helvetica,sans-serif\">This is a test. Don't worry about it</div><div class=\"gmail_default\" style=\"font-family:arial,helvetica,sans-serif;display:inline\">\n\n</div><div class=\"gmail_quote\"><div dir=\"ltr\">Hey HACKcelerator teams,<div><br></div><div>We will be getting all of you business cards for Global Demo Day, but in order to do so, we need some information from you.&nbsp;</div>\n\n<div><br></div><div>I have already compiled most of your team information for the Global Demo Day Brochure and business cards and Kam should already have your logos, however, we need <b>a single contact email address</b>&nbsp;that you would like put on the card to represent your whole team. This email can be an info@ email address, or of one of your team members.&nbsp;</div>\n\n\n<div><br></div><div>Please also check and feel free to edit your names, blurbs, and any of the other content to ensure that it is correct.&nbsp;</div><div><br></div><div><b>We are ordering the cards on Monday, 8/19. Any changes or additions to the information after this date will not be included on the business cards, </b>so it is crucial that you get these in ASAP.&nbsp;</div>\n\n\n<div><br></div><div><a href=\"https://docs.google.com/spreadsheet/ccc?key=0ArYxVqcJJKeVdDFVYzdlYXI5ZUsyT2JDVlNvU0Zudmc&amp;usp=sharing\" target=\"_blank\">HERE is the document to put your information in.</a>&nbsp;<b>Go to the Brochure Content tab on the bottom.</b></div>\n\n\n<div><br></div><div>Also, attached is an example business card, so you can get an idea of what the cards will look like.&nbsp;</div><div><br></div><div>Please let me know if you have any questions or concerns!</div><div><br></div>\n\n\n<div>Thanks!</div><div class=\"yj6qo ajU\"><div id=\":db\" class=\"ajR\" role=\"button\" tabindex=\"0\" data-tooltip=\"Show trimmed content\" aria-label=\"Show trimmed content\"><img class=\"ajT\" src=\"images/cleardot.gif\"></div></div><span class=\"HOEnZb adL\"><font color=\"#888888\"><span><font color=\"#888888\"><div><br clear=\"all\"><div><br></div>-- <br><div dir=\"ltr\"><div>Robin Oyung</div><div>HACKcelerator Social Media, Operations, and PR</div><a href=\"mailto:robin@angelhack.com\" target=\"_blank\">robin@angelhack.com</a></div>\n\n\n\n</div></font></span></font></span></div><div class=\"adL\">\n</div></div><div class=\"adL\"><br></div></div><div class=\"adL\">\n</div></div>";
    
    NSString *wrappedBody = [NSString stringWithFormat:@"<div id='signal_body'>%@</div><script>document.getElementById('signal_body').setAttribute('contentEditable','true')</script>",testBody];
    [webView loadHTMLString:wrappedBody baseURL:nil];
    webView.keyboardDisplayRequiresUserAction = NO;
    
    
    UITextView *subjectField = [[UITextView alloc] initWithFrame:CGRectMake(10.0f, 0.0f, self.view.frame.size.width, 100.0f)];
    subjectField.text = [_email objectForKey:@"subject"];
    subjectField.backgroundColor = [UIColor clearColor];
    subjectField.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:15.0f];
    [subjectField sizeToFit];
    subjectField.frame = CGRectMake(10.0f, -subjectField.frame.size.height+2, self.view.frame.size.width, subjectField.frame.size.height-5);
    [webView.scrollView addSubview:subjectField];
    
    UILabel *senderLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, 30.0f)];
    senderLabel.text = [_email objectForKey:@"sender"];
    senderLabel.textColor = [UIColor colorWithWhite:0.1f alpha:1.0f];
    senderLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:12.0f];
    senderLabel.backgroundColor = [UIColor clearColor];
    [senderLabel sizeToFit];
    senderLabel.frame = CGRectMake(18.0f, -senderLabel.frame.size.height-subjectField.frame.size.height+5.0f, self.view.frame.size.width-20.0f, senderLabel.frame.size.height);
    [webView.scrollView addSubview:senderLabel];
    
    UIView *subjectDivider = [[UIView alloc] initWithFrame:CGRectMake(15.0f, -2.0f, self.view.frame.size.width-15.0f, 0.3f)];
    subjectDivider.backgroundColor = [UIColor colorWithWhite:0.7f alpha:1.0f];
    [webView.scrollView addSubview:subjectDivider];


    
    webView.scrollView.contentInset = UIEdgeInsetsMake(subjectField.frame.size.height+senderLabel.frame.size.height, 0.0f, 0.0f, 0.0f);
    
    [self.view addSubview:webView];
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
