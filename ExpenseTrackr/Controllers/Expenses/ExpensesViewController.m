//
//  ExpensesViewController.m
//  ExpenseTrackr
//
//  Created by Tri Vuong on 10/14/12.
//  Copyright (c) 2012 Crafted By Tri. All rights reserved.
//

#import "ExpensesViewController.h"
#import "NewExpenseViewController.h"

@interface ExpensesViewController ()

@end

@implementation ExpensesViewController

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
    // Set title for navigation bar
    [self.navigationItem setTitle:@"All Expenses"];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"header.png"] forBarMetrics:UIBarMetricsDefault];
    
    // Add 'New Expense' button
    UIBarButtonItem *newExpenseButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(showNewExpenseForm)];
    [newExpenseButton setImage:[UIImage imageNamed:@"white_plus_sign.png"]];
    [newExpenseButton setTintColor:[UIColor blackColor]];
    [self.navigationItem setRightBarButtonItem:newExpenseButton];
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
    
}

@end
