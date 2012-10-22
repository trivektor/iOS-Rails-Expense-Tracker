//
//  SigninViewController.m
//  ExpenseTrackr
//
//  Created by Tri Vuong on 10/20/12.
//  Copyright (c) 2012 Crafted By Tri. All rights reserved.
//

#import "SigninViewController.h"
#import "AppConfig.h"
#import "SpinnerView.h"
#import "ExpensesViewController.h"

@interface SigninViewController ()

@end

@implementation SigninViewController

@synthesize spinnerView;

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
    // Do any additional setup after loading the view from its nib.
    [self performHouseKeepingTasks];
    [self loadSigninPage];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)performHouseKeepingTasks
{
    [self.navigationItem setTitle:@"Sign In"];
    
    [webView setDelegate:self];
}

- (void)loadSigninPage
{
    NSString *urlAddress = [AppConfig getConfigValue:@"LoginPath"];
    
    NSURL *url = [NSURL URLWithString:urlAddress];
    
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    self.spinnerView = [SpinnerView loadSpinnerIntoView:self.view];
    [webView loadRequest:requestObj];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.spinnerView removeFromSuperview];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *requestURL = request.URL.absoluteString;
    NSRange pathRange = [requestURL rangeOfString:@"dashboard"];

    if (pathRange.length > 0)
    {
        ExpensesViewController *expensesController = [[ExpensesViewController alloc] init];
        [self.navigationController pushViewController:expensesController animated:YES];
        return TRUE;
    }
    return TRUE;
}

@end
