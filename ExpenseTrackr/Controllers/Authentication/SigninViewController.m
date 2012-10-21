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
}

- (void)loadSigninPage
{
    NSString *urlAddress = [AppConfig getConfigValue:@"LoginPath"];
    urlAddress = @"http://192.168.0.11:3000/users/sign_in";
    
    NSURL *url = [NSURL URLWithString:urlAddress];
    
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [webView loadRequest:requestObj];
    //self.spinnerView = [SpinnerView loadSpinnerIntoView:self.view];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    //[self.spinnerView removeFromSuperview];
}

@end
