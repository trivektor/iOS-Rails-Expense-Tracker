//
//  HomeViewController.m
//  ExpenseTrackr
//
//  Created by Tri Vuong on 10/12/12.
//  Copyright (c) 2012 Crafted By Tri. All rights reserved.
//

#import "HomeViewController.h"
#import "SignupViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

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
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showSignupForm:(id)sender
{
    SignupViewController *s = [[SignupViewController alloc] init];
        
    UINavigationController *signupController = [[UINavigationController alloc] initWithRootViewController:s];
    [self presentViewController:signupController animated:YES completion:nil];
}

- (void)showLoginForm:(id)sender
{
    
}

@end
