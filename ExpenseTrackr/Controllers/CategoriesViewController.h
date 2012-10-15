//
//  CategoriesViewController.h
//  Expense Tracking
//
//  Created by Tri Vuong on 9/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Expense.h"

@protocol CategoriesViewControllerDelegate <NSObject>
- (void) didFinishSelectingCategoryForExpense:(Expense*)expense;
@end

@interface CategoriesViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) id <CategoriesViewControllerDelegate> delegate;
@property (nonatomic, retain) Expense *expense;
@property (nonatomic, retain) NSArray *categories;
@property (nonatomic, retain) UITableView *tableView;

@end
