//
//  ExpensesViewController.h
//  ExpenseTrackr
//
//  Created by Tri Vuong on 10/14/12.
//  Copyright (c) 2012 Crafted By Tri. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExpensesViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    
    __weak IBOutlet UITableView *expensesTable;
}

- (void)performHouseKeepingTasks;
- (void)showNewExpenseForm;
- (void)fetchExpensesFromServer;

@end