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
#import "KeychainItemWrapper.h"
#import "KeychainHelper.h"

@interface SigninViewController ()

@end

@implementation SigninViewController

@synthesize spinnerView, cookieDomain;

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
    [self setCookieDomain:[url host]];
    
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    self.spinnerView = [SpinnerView loadSpinnerIntoView:self.view];
    [webView loadRequest:requestObj];
}

- (void)webViewDidFinishLoad:(UIWebView *)_webView
{
    [self.spinnerView removeFromSuperview];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *requestURL = request.URL.absoluteString;
    NSRange dashboardPathRange = [requestURL rangeOfString:@"dashboard"];
    NSRange signInPathRange = [requestURL rangeOfString:@"/users/sign_in"];

    if (dashboardPathRange.length > 0)
    {
        NSString *token = [self getTokenFromCookie];
        
        NSLog(@"token from cookie is %@", token);
        
        [KeychainHelper setAuthenticationToken:token];
        
        ExpensesViewController *expensesController = [[ExpensesViewController alloc] init];
        [self.navigationController pushViewController:expensesController animated:YES];
        return TRUE;
    }
    else if (signInPathRange.length > 0)
    {
        
    }
    return TRUE;
}

- (NSString *)getTokenFromCookie
{
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    
    for (cookie in [cookieJar cookies]) {
        if ([[cookie domain] isEqualToString:self.cookieDomain]) {
            if ([[cookie name] isEqualToString:@"auth_token"]) {
                return [cookie value];
            }
        }
    }
    
    return nil;
}

@end
