//
//  SignupViewController.h
//  ExpenseTrackr
//
//  Created by Tri Vuong on 10/13/12.
//  Copyright (c) 2012 Crafted By Tri. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SignupViewControllerCancelDelegate <NSObject>
- (void)cancelSignupForm;
@end

@interface SignupViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
{
    __weak IBOutlet UITableView *signupTableForm;
    __weak IBOutlet UITextField *firstNameTextField;
    __weak IBOutlet UITextField *lastNameTextField;
    __weak IBOutlet UITextField *emailTextField;
    __weak IBOutlet UITextField *passwordTextField;
    __weak IBOutlet UITextField *confirmPasswordTextField;
}

@property (nonatomic, retain) UIView *spinnerView;
@property (nonatomic, weak) id <SignupViewControllerCancelDelegate> delegate;
@property (nonatomic, retain) IBOutlet UITableViewCell *firstNameCell;
@property (nonatomic, retain) IBOutlet UITableViewCell *lastNameCell;
@property (nonatomic, retain) IBOutlet UITableViewCell *emailCell;
@property (nonatomic, retain) IBOutlet UITableViewCell *passwordCell;
@property (nonatomic, retain) IBOutlet UITableViewCell *confirmPasswordCell;

- (void)setDelegates;
- (void)performHouseKeepingTasks;
- (void)signup;
- (void)cancelSignup;

@end
