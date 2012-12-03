//
//  ExpensesViewController.h
//  ExpenseTrackr
//
//  Created by Tri Vuong on 10/14/12.
//  Copyright (c) 2012 Crafted By Tri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface ExpensesViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    __weak IBOutlet UITableView *expensesTable;
}

@property (nonatomic, retain) UIView *spinnerView;
@property (nonatomic, retain) NSMutableArray *expenses;

- (void)performHouseKeepingTasks;
- (void)setupPullToRefresh;
- (void)showNewExpenseForm;
- (void)showDashboard;
- (void)fetchExpensesFromServer;

@end