//
//  SigninViewController.h
//  ExpenseTrackr
//
//  Created by Tri Vuong on 10/20/12.
//  Copyright (c) 2012 Crafted By Tri. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SigninViewController : UIViewController <UIWebViewDelegate>
{
    __weak IBOutlet UIWebView *webView;
}

@property (nonatomic, retain) UIView *spinnerView;

- (void)performHouseKeepingTasks;
- (void)loadSigninPage;

@end
