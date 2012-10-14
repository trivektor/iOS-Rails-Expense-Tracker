//
//  HomeViewController.h
//  ExpenseTrackr
//
//  Created by Tri Vuong on 10/12/12.
//  Copyright (c) 2012 Crafted By Tri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SignupViewController.h"

@interface HomeViewController : UIViewController <SignupViewControllerCancelDelegate>

- (IBAction)showSignupForm:(id)sender;
- (IBAction)showLoginForm:(id)sender;

- (void)cancelSignupForm;

@end
