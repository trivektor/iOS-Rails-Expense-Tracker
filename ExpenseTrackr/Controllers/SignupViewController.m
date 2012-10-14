//
//  SignupViewController.m
//  ExpenseTrackr
//
//  Created by Tri Vuong on 10/13/12.
//  Copyright (c) 2012 Crafted By Tri. All rights reserved.
//

#import "AppConfig.h"
#import "SignupViewController.h"
#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"
#import "SpinnerView.h"

@interface SignupViewController ()

@end

@implementation SignupViewController

@synthesize spinnerView, firstNameCell, lastNameCell, emailCell, passwordCell, confirmPasswordCell;

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
    [firstNameTextField setDelegate:self];
    [lastNameTextField setDelegate:self];
    [emailTextField setDelegate:self];
    [passwordTextField setDelegate:self];
    [confirmPasswordTextField setDelegate:self];
}

- (void)performHouseKeepingTasks
{
    // Set black tint color for navigation bar
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"header.png"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationItem setTitle:@"Create Account"];

    // Set white background for signup table form
    UIView *signupTableFormBackground = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    [signupTableFormBackground setBackgroundColor:[UIColor whiteColor]];
    [signupTableForm setBackgroundView:signupTableFormBackground];
    
    // The sign up table form doesn't need to be scrollable
    [signupTableForm setScrollEnabled:NO];
    
    // Add 'Cancel' button to the left of the navigation bar
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonSystemItemCancel target:self action:@selector(cancelSignup)];
    [cancelButton setTintColor:[UIColor blackColor]];
    [self.navigationItem setLeftBarButtonItem:cancelButton];
    
    // Add 'Submit' button to the right of the navigation bar
    UIBarButtonItem *submitButton = [[UIBarButtonItem alloc] initWithTitle:@"Submit" style:UIBarButtonItemStyleDone target:self action:@selector(signup)];
    [submitButton setTintColor:[UIColor blackColor]];
    [self.navigationItem setRightBarButtonItem:submitButton];
}

- (void)signup
{

    NSURL *signupURL = [NSURL URLWithString:[AppConfig getConfigValue:@"SignupPath"]];
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:signupURL];
    
    NSMutableDictionary *userParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       firstNameTextField.text, @"first_name",
                                       lastNameTextField.text, @"last_name",
                                       emailTextField.text, @"email",
                                    passwordTextField.text, @"password",
                            confirmPasswordTextField.text, @"password_confirmation",
                                       nil];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   userParams, @"user",
                                   nil];
    
    NSMutableURLRequest *postRequest = [httpClient requestWithMethod:@"POST" path:signupURL.absoluteString parameters:params];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:postRequest];
    
    [operation setCompletionBlockWithSuccess:
     ^(AFHTTPRequestOperation *operation, id responseObject) {
         NSString *response = [operation responseString];
         
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
         
         NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[response dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
         
         if ([[json valueForKey:@"success"] intValue] == 1) {
             [alert setMessage:[json valueForKey:@"message"]];
         } else {
             [alert setMessage:[json valueForKey:@"errors"]];
         }
         
         [self.spinnerView removeFromSuperview];
         [alert show];
     }
    failure:
     ^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"error: %@", [operation error]);
         [self.spinnerView removeFromSuperview];
    }];
    
    self.spinnerView = [SpinnerView loadSpinnerIntoView:self.view];
    [operation start];
}

- (void)cancelSignup
{
    [self.delegate cancelSignupForm];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) return firstNameCell;
    if (indexPath.row == 1) return lastNameCell;
    if (indexPath.row == 2) return emailCell;
    if (indexPath.row == 3) return passwordCell;
    if (indexPath.row == 4) return confirmPasswordCell;
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

@end
