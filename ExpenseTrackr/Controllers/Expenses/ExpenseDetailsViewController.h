//
//  ExpenseDetailsViewController.h
//  ExpenseTrackr
//
//  Created by Tri Vuong on 10/20/12.
//  Copyright (c) 2012 Crafted By Tri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Expense.h"

@interface ExpenseDetailsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    __weak IBOutlet UITableView *expenseDetailsTable;
}

@property (nonatomic, retain) Expense *expense;
@property (nonatomic, retain) NSArray *sectionNames;

- (void)performHouseKeepingTasks;

@end
