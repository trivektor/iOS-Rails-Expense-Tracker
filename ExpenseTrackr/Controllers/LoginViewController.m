//
//  LoginViewController.m
//  ExpenseTrackr
//
//  Created by Tri Vuong on 10/13/12.
//  Copyright (c) 2012 Crafted By Tri. All rights reserved.
//

#import "LoginViewController.h"
#import "SignupViewController.h"
#import "SpinnerView.h"
#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"
#import "AppConfig.h"
#import "KeychainItemWrapper.h"
#import "KeychainHelper.h"
#import "ExpensesViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

@synthesize emailCell, passwordCell, spinnerView;

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
    [self setDelegates];
    [self performHouseKeepingTasks];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setDelegates
{
    [emailTextField setDelegate:self];
    [passwordTextField setDelegate:self];
}

- (void)performHouseKeepingTasks
{
    // Set navigation bar background
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"header.png"] forBarMetrics:UIBarMetricsDefault];
    
    // Set white background for login table form
    UIView *loginTableFormBackground = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    [loginTableFormBackground setBackgroundColor:[UIColor whiteColor]];
    [loginTableForm setBackgroundView:loginTableFormBackground];
    
    // The login form table doesn't need to be scrollable
    [loginTableForm setScrollEnabled:NO];
    
    // Add 'Cancel' button
    // UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonSystemItemCancel target:self action:@selector(cancelLogin)];
    // [cancelButton setTintColor:[UIColor blackColor]];
    // [self.navigationItem setLeftBarButtonItem:cancelButton];
    
    // Add 'Submit' button
    UIBarButtonItem *submitButton = [[UIBarButtonItem alloc] initWithTitle:@"Submit" style:UIBarButtonItemStylePlain target:self action:@selector(login)];
    [submitButton setTintColor:[UIColor blackColor]];
    [self.navigationItem setRightBarButtonItem:submitButton];
    
    // Show signup form when the signup label is tapped
    [signupLabel setUserInteractionEnabled:YES];
    UITapGestureRecognizer *signupLabelTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapSignupLabelWithGesture:)];
    [signupLabel addGestureRecognizer:signupLabelTap];
    
    // Set title of navigation bar
    [self.navigationItem setTitle:@"Login"];
}

- (void)cancelLogin
{
    [self.delegate cancelLoginForm];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) return emailCell;
    if (indexPath.row == 1) return passwordCell;
    return nil;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)login
{
    if (emailTextField.text.length == 0 || passwordTextField.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please enter both email and password" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alert show];
    } else {
        NSURL *signinURL = [NSURL URLWithString:[AppConfig getConfigValue:@"LoginPath"]];
        
        AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:signinURL];
        
        NSMutableDictionary *userParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                           [emailTextField text], @"email",
                                           [passwordTextField text], @"password",
                                           nil];
        
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       userParams, @"user",
                                       nil];
        
        NSMutableURLRequest *postRequest = [httpClient requestWithMethod:@"POST" path:signinURL.absoluteString parameters:params];
        
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:postRequest];
        
        [operation setCompletionBlockWithSuccess:
         ^(AFHTTPRequestOperation *operation, id responseObject) {
             NSString *response = [operation responseString];
             
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
             
             NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[response dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
             
             if ([[json valueForKey:@"success"] intValue] == 1) {
                 [alert setMessage:[json valueForKey:@"message"]];
                 
                 NSString *token = [json valueForKey:@"auth_token"];
                 NSLog(@"%@", token);
                 
                 [KeychainHelper setAuthenticationToken:token];
                 
                 [alert setTitle:@"Alert"];
                 [alert setMessage:@"You've logged in successfully"];
                 
                 ExpensesViewController *expensesController = [[ExpensesViewController alloc] init];
                 [self.navigationController pushViewController:expensesController animated:YES];
             } else {
                 [alert setTitle:@"Error"];
                 [alert setMessage:[json valueForKey:@"errors"]];
             }
             
             [alert show];
             [self.spinnerView removeFromSuperview];
         }
        failure:
         ^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"error: %@", [operation error]);
         }];
        
        self.spinnerView = [SpinnerView loadSpinnerIntoView:self.view];
        [operation start];
        
    }
}

- (void)didTapSignupLabelWithGesture:(UITapGestureRecognizer *)tapGesture
{
    SignupViewController *signupController = [[SignupViewController alloc] init];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:nil];
    [backButton setTintColor:[UIColor blackColor]];
    [self.navigationItem setBackBarButtonItem:backButton];
    [self.navigationController pushViewController:signupController animated:YES];

}

@end
