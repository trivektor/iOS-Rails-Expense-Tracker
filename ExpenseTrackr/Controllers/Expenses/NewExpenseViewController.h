//
//  NewExpenseViewController.h
//  ExpenseTrackr
//
//  Created by Tri Vuong on 10/14/12.
//  Copyright (c) 2012 Crafted By Tri. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewExpenseViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UITextViewDelegate>
{
    
    __weak IBOutlet UITableView *expenseTableForm;
    __weak IBOutlet UITextField *nameTextField;
    __weak IBOutlet UITextField *amountTextField;
    __weak IBOutlet UITextField *taxTextField;
    __weak IBOutlet UITextField *tipTextField;
    __weak IBOutlet UIButton *categoryButton;
    __weak IBOutlet UITextView *descriptionTextField;
}

@property (nonatomic, retain) IBOutlet UITableViewCell *nameCell;
@property (nonatomic, retain) IBOutlet UITableViewCell *amountCell;
@property (nonatomic, retain) IBOutlet UITableViewCell *taxCell;
@property (nonatomic, retain) IBOutlet UITableViewCell *tipCell;
@property (nonatomic, retain) IBOutlet UITableViewCell *categoryCell;
@property (nonatomic, retain) IBOutlet UITableViewCell *descriptionCell;

- (void)setDelegates;
- (void)performHouseKeepingTasks;

@end
