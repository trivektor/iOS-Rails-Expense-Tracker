//
//  LoginViewController.h
//  ExpenseTrackr
//
//  Created by Tri Vuong on 10/13/12.
//  Copyright (c) 2012 Crafted By Tri. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LoginViewControllerCancelDelegate <NSObject>
- (void)cancelLoginForm;
@end

@interface LoginViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
{
    __weak IBOutlet UITableView *loginTableForm;
    __weak IBOutlet UITextField *emailTextField;
    __weak IBOutlet UITextField *passwordTextField;
}

@property (nonatomic, weak) id <LoginViewControllerCancelDelegate> delegate;
@property (nonatomic, retain) UIView *spinnerView;
@property (nonatomic, retain) IBOutlet UITableViewCell *emailCell;
@property (nonatomic, retain) IBOutlet UITableViewCell *passwordCell;

- (void)setDelegates;
- (void)performHouseKeepingTasks;
- (void)cancelLogin;
- (void)login;

@end
