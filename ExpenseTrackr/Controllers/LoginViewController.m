//
//  LoginViewController.m
//  ExpenseTrackr
//
//  Created by Tri Vuong on 10/13/12.
//  Copyright (c) 2012 Crafted By Tri. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)performHouseKeepingTasks
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"header.png"] forBarMetrics:UIBarMetricsDefault];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonSystemItemCancel target:self action:@selector(cancelLogin)];
    [cancelButton setTintColor:[UIColor blackColor]];
    
    [self.navigationItem setLeftBarButtonItem:cancelButton];

    [self.navigationItem setTitle:@"Login"];
}

- (void)cancelLogin
{
    [self.delegate cancelLoginForm];
}

@end
