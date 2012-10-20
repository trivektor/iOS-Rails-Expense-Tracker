//
//  ExpenseDetailsViewController.m
//  ExpenseTrackr
//
//  Created by Tri Vuong on 10/20/12.
//  Copyright (c) 2012 Crafted By Tri. All rights reserved.
//

#import "ExpenseDetailsViewController.h"
#import "ExpenseDetailCell.h"

@interface ExpenseDetailsViewController ()

@end

@interface UILabel (BPExtensions)

- (void)sizeToFitFixedWith:(CGFloat)fixedWith;

@end

@implementation UILabel (BPExtensions)

- (void)sizeToFitFixedWith:(CGFloat)fixedWith
{
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, fixedWith, 0);
    self.lineBreakMode = NSLineBreakByWordWrapping;
    self.numberOfLines = 0;
    [self sizeToFit];
}

@end

@implementation ExpenseDetailsViewController

@synthesize sectionNames;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.sectionNames = [NSArray arrayWithObjects:@"Name", @"Amount", @"Tax", @"Tip", @"Category", @"Description", @"Date", nil];
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
    [self.navigationItem setTitle:self.expense.name];

    [expenseDetailsTable setDelegate:self];
    [expenseDetailsTable setDataSource:self];
    
    UINib *nib = [UINib nibWithNibName:@"ExpenseDetailCell" bundle:nil];
    [expenseDetailsTable registerNib:nib forCellReuseIdentifier:@"ExpenseDetailCell"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ExpenseDetailCell *cell = [expenseDetailsTable dequeueReusableCellWithIdentifier:@"ExpenseDetailCell"];
    
    [cell.sectionName setText:[self.sectionNames objectAtIndex:[indexPath row]]];
    [cell setSelectionStyle:UITableViewCellEditingStyleNone];
    
    int row = [indexPath row];
    
    if (row == 0) {
        //[cell.expenseDetail setNumberOfLines:0];
        [cell.sectionDetails setText:self.expense.name];
        [cell.sectionDetails sizeToFitFixedWith:193];
    } else if (row == 1) {
        [cell.sectionDetails setText:[NSString stringWithFormat:@"%.02f", self.expense.amount]];
    } else if (row == 2) {
        [cell.sectionDetails setText:[NSString stringWithFormat:@"%.02f", self.expense.tax]];
    } else if (row == 3) {
        [cell.sectionDetails setText:[NSString stringWithFormat:@"%.02f", self.expense.tip]];
    } else if (row == 4) {
        [cell.sectionDetails setText:self.expense.category];
    } else if (row == 5) {
        [cell.sectionDetails setText:self.expense.description];
        [cell.sectionDetails sizeToFitFixedWith:193];
    } else if (row == 6) {
        [cell.sectionDetails setText:self.expense.createdAt];
    }
    
    // Make the expense detail label stretched enough to fit its text without resizing
    // http://stackoverflow.com/questions/793015/how-to-fit-a-text-in-uilabel-when-the-size-is-not-proportionally
    // CGRect bounds = cell.expenseDetail.bounds;
    // bounds.size = [cell.expenseDetail.text sizeWithFont:cell.expenseDetail.font];
    // cell.expenseDetail.bounds = bounds;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = [indexPath row];
    
    if (row == 0 || row == 5) {
        // Nice solution to calculate UITableViewCell height dynamically based on the height of the label it contains
        // http://stackoverflow.com/questions/1012361/resize-uitableviewcell-to-the-labels-height-dynamically
        
        NSString *text;
        
        if (row == 0) {
            text = self.expense.name;
        } else {
            text = self.expense.description;
        }
        
        if (text.length == 0) return 49;
        
        CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:14.0] constrainedToSize:CGSizeMake(193, 999)lineBreakMode:NSLineBreakByWordWrapping];
        
        return size.height + 28;
        
    } else {
        return 49;
    }
}

@end
