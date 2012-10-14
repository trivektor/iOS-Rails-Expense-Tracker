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

@interface LoginViewController : UIViewController

@property (nonatomic, weak) id <LoginViewControllerCancelDelegate> delegate;

- (void)performHouseKeepingTasks;
- (void)cancelLogin;

@end
