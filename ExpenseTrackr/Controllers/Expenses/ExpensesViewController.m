//
//  ExpensesViewController.m
//  ExpenseTrackr
//
//  Created by Tri Vuong on 10/14/12.
//  Copyright (c) 2012 Crafted By Tri. All rights reserved.
//

#import "ExpensesViewController.h"
#import "NewExpenseViewController.h"
#import "KeychainItemWrapper.h"
#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"
#import "AppConfig.h"
#import "SpinnerView.h"
#import "Expense.h"
#import "ExpenseCell.h"

@interface ExpensesViewController ()

@end

@implementation ExpensesViewController

@synthesize expenses, spinnerView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.expenses = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [expensesTable setDelegate:self];
    [expensesTable setDataSource:self];
    [self performHouseKeepingTasks];
    [self fetchExpensesFromServer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)performHouseKeepingTasks
{
    // Set title for navigation bar
    [self.navigationItem setTitle:@"All Expenses"];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"header.png"] forBarMetrics:UIBarMetricsDefault];
    
    // Add 'New Expense' button
    UIBarButtonItem *newExpenseButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(showNewExpenseForm)];
    [newExpenseButton setImage:[UIImage imageNamed:@"white_plus_sign.png"]];
    [newExpenseButton setTintColor:[UIColor blackColor]];
    [self.navigationItem setRightBarButtonItem:newExpenseButton];
    
    UINib *nib = [UINib nibWithNibName:@"ExpenseCell" bundle:nil];
    
    [expensesTable registerNib:nib forCellReuseIdentifier:@"ExpenseCell"];
}

- (void)showNewExpenseForm
{
    // Add 'Back' button
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:nil];
    [backButton setTintColor:[UIColor blackColor]];
    [self.navigationItem setBackBarButtonItem:backButton];
    
    NewExpenseViewController *newExpenseController = [[NewExpenseViewController alloc] init];
    [self.navigationController pushViewController:newExpenseController animated:YES];
}

- (void)fetchExpensesFromServer
{
    KeychainItemWrapper *keychain = [[KeychainItemWrapper alloc] initWithIdentifier:@"ExpenseTrackingKeychain" accessGroup:nil];
    
    NSString *authToken = [keychain objectForKey:(__bridge id)kSecAttrAccount];
    
    NSURL *expensesIndexURL = [NSURL URLWithString:[AppConfig getConfigValue:@"ExpensesIndexPath"]];
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:expensesIndexURL];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   authToken, @"token",
                                   nil];
        
    NSMutableURLRequest *getRequest = [httpClient requestWithMethod:@"GET" path:expensesIndexURL.absoluteString parameters:params];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:getRequest];
    
    [operation setCompletionBlockWithSuccess:
        ^(AFHTTPRequestOperation *operation, id responseObject){
            
            NSString *response = [operation responseString];
            
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[response dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
            
            NSArray *expensesJSON = [json valueForKey:@"expenses"];
            
            Expense *e;
            
            for (NSDictionary *expense in expensesJSON) {
                e = [[Expense alloc] init];
                e.expenseId = [[expense valueForKey:@"id"] intValue];
                e.name = [expense valueForKey:@"name"];
                e.amount = [[expense valueForKey:@"amount"] doubleValue];
                e.description = [expense valueForKey:@"description"];
                e.createdAt = [expense valueForKey:@"created_at"];
                [self.expenses addObject:e];
                [expensesTable reloadData];
            }
            
            [self.spinnerView removeFromSuperview];
        }
        failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self.spinnerView removeFromSuperview];
        }
     ];
    
    self.spinnerView = [SpinnerView loadSpinnerIntoView:self.view];
    [operation start];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.expenses.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ExpenseCell *cell = [expensesTable dequeueReusableCellWithIdentifier:@"ExpenseCell"];
    
    Expense *e = [self.expenses objectAtIndex:[indexPath row]];
    
    if (e.name.length >= 18) {
        NSString *truncatedExpenseName = [e.name substringToIndex:MIN(18, e.name.length)];
        cell.nameLabel.text = [truncatedExpenseName stringByAppendingString:@"..."];
    } else {
        cell.nameLabel.text = e.name;
    }
    
    cell.amountLabel.text = [NSString stringWithFormat:@"$%.02f", e.amount];
    cell.createdAtLabel.text = e.createdAt;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 61;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Expense *e = [self.expenses objectAtIndex:indexPath.row];
}

@end
