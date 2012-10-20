//
//  NewExpenseViewController.m
//  ExpenseTrackr
//
//  Created by Tri Vuong on 10/14/12.
//  Copyright (c) 2012 Crafted By Tri. All rights reserved.
//

#import "NewExpenseViewController.h"
#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"
#import "CategoriesViewController.h"
#import "AppConfig.h"
#import "SpinnerView.h"
#import "KeychainItemWrapper.h"

@interface NewExpenseViewController ()

@end

@implementation NewExpenseViewController

@synthesize nameCell, amountCell, taxCell, tipCell, categoryCell, descriptionCell, submitButtonCell, spinnerView;

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
    [nameTextField setDelegate:self];
    [amountTextField setDelegate:self];
    [taxTextField setDelegate:self];
    [tipTextField setDelegate:self];
    [descriptionTextField setDelegate:self];
}

- (void)performHouseKeepingTasks
{
    [self.navigationItem setTitle:@"Add Expense"];
    
    // Remove the padding of 'Description' field
    [descriptionTextField setContentInset:UIEdgeInsetsMake(-11, -8, 0, 0)];
    
    // Add 'Reset' button
    UIBarButtonItem *resetButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:self action:@selector(resetForm)];
    [resetButton setTintColor:[UIColor blackColor]];
    [resetButton setImage:[UIImage imageNamed:@"trash_icon.png"]];
    [self.navigationItem setRightBarButtonItem:resetButton];
    
    //[scrollView setContentSize:CGSizeMake(320, 480)];
    [expenseTableForm setScrollEnabled:NO];
    [expenseTableForm setAutoresizingMask:~UIViewAutoresizingFlexibleBottomMargin];
    
    UITapGestureRecognizer *outsideTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboardForDescription)];
    
    [outsideTap setCancelsTouchesInView:NO];
    [self.view addGestureRecognizer:outsideTap];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 5) {
        return 158;
    } else if (indexPath.row == 6) {
        return 53;
    } else {
        return 44;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) return nameCell;
    if (indexPath.row == 1) return amountCell;
    if (indexPath.row == 2) return taxCell;
    if (indexPath.row == 3) return tipCell;
    if (indexPath.row == 4) return categoryCell;
    if (indexPath.row == 5) return descriptionCell;
    if (indexPath.row == 6) return submitButtonCell;
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

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    [scrollView setContentOffset:CGPointMake(0, 210) animated:YES];
    [textView setText:@""];
    return YES;
}

- (void)resetForm
{
    [nameTextField setText:@""];
    [amountTextField setText:@""];
    [taxTextField setText:@""];
    [tipTextField setText:@""];
    [descriptionTextField setText:@""];
}

- (IBAction)saveExpense:(id)sender
{
    KeychainItemWrapper *keychain = [[KeychainItemWrapper alloc] initWithIdentifier:@"ExpenseTrackingKeychain" accessGroup:nil];
    
    NSString *authToken = [keychain objectForKey:(__bridge id)kSecAttrAccount];

    NSURL *createExpenseURL = [NSURL URLWithString:[AppConfig getConfigValue:@"CreateExpensePath"]];
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:createExpenseURL];
    
    NSMutableDictionary *expenseParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                           nameTextField.text, @"name",
                                           amountTextField.text, @"amount",
                                           taxTextField.text, @"tax",
                                           tipTextField.text, @"tip",
                                           descriptionTextField.text, @"description",
                                           nil];
                                          
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    expenseParams, @"expense",
                                    authToken, @"token",
                                    nil];
                                   
    NSMutableURLRequest *postRequest = [httpClient requestWithMethod:@"POST" path:createExpenseURL.absoluteString parameters:params];

    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:postRequest];
                                        
    [operation setCompletionBlockWithSuccess:
        ^(AFHTTPRequestOperation *operation, id responseObject){
            NSString *response = [operation responseString];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[response dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
            
            if ([[json valueForKey:@"success"] intValue] == 1) {
                [alert setMessage:[json valueForKey:@"message"]];
            } else {
                [alert setMessage:[json valueForKey:@"errors"]];
            }
            
            [alert show];
            [self.spinnerView removeFromSuperview];
        }
        failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self.spinnerView removeFromSuperview];
        }
    ];
    
    self.spinnerView = [SpinnerView loadSpinnerIntoView:self.view];
    [operation start];
}

- (void)dismissKeyboardForDescription
{
    if ([descriptionTextField isFirstResponder]) {
        [descriptionTextField resignFirstResponder];
        [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        if (descriptionTextField.text.length == 0) {
            [descriptionTextField setText:@"Description"];
        }
    }
}

- (void)categoryButtonTapped:(id)sender
{
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:nil];
    [backButton setTintColor:[UIColor blackColor]];
    [self.navigationItem setBackBarButtonItem:backButton];

    CategoriesViewController *categoriesController = [[CategoriesViewController alloc] init];
    [self.navigationController pushViewController:categoriesController animated:YES];
}

@end
