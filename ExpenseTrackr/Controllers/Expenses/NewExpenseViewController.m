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

@interface NewExpenseViewController ()

@end

@implementation NewExpenseViewController

@synthesize nameCell, amountCell, taxCell, tipCell, categoryCell, descriptionCell, submitButtonCell;

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
    
    [scrollView setContentSize:CGSizeMake(320, 44*5 + 158)];
    [expenseTableForm setScrollEnabled:NO];
    [expenseTableForm setAutoresizingMask:~UIViewAutoresizingFlexibleBottomMargin];
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

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
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

- (void)saveExpense
{
    
}

@end
