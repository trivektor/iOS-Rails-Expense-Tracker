//
//  DashboardViewController.m
//  ExpenseTrackr
//
//  Created by Tri Vuong on 10/20/12.
//  Copyright (c) 2012 Crafted By Tri. All rights reserved.
//

#import "DashboardViewController.h"
#import "LoginViewController.h"
#import "IIViewDeckController.h"
#import "ExpensesViewController.h"
#import "ReceiptsViewController.h"
#import "FeedbackViewController.h"
#import "KeychainHelper.h"
#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"
#import "AppConfig.h"

@interface DashboardViewController ()

@end

@implementation DashboardViewController

@synthesize options;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.options = [[NSMutableArray alloc] initWithCapacity:0];
        [self.options addObject:@"Expenses"];
        [self.options addObject:@"Receipts"];
        [self.options addObject:@"Invite"];
        [self.options addObject:@"Feedback"];
        [self.options addObject:@"Sign out"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self performHouseKeepingTasks];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)performHouseKeepingTasks
{
    [self.navigationItem setTitle:@"More Options"];
    [optionsTable setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"magma.png"]]];
    [optionsTable setSeparatorColor:[UIColor clearColor]];
    [optionsTable setScrollEnabled:NO];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.options.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    NSString *icon = [[self.options objectAtIndex:indexPath.row] lowercaseString];
    
    [cell.imageView setImage:[UIImage imageNamed:[icon stringByAppendingString:@"_icon.png"]]];
    [cell.textLabel setTextColor:[UIColor whiteColor]];
    [cell.textLabel setText:[self.options objectAtIndex:indexPath.row]];
    [cell setSelectionStyle:UITableViewCellEditingStyleNone];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"magma_border.png"]]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.options.count - 1) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Sign out" otherButtonTitles:nil];
        actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
        [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
        return;
    } else {
        UINavigationController *newController;
        
        if (indexPath.row == 0) {
            ExpensesViewController *expensesController = [[ExpensesViewController alloc] init];
            newController = [[UINavigationController alloc] initWithRootViewController:expensesController];
        } else if (indexPath.row == 1) {
            ReceiptsViewController *receiptsController = [[ReceiptsViewController alloc] init];
            newController = [[UINavigationController alloc] initWithRootViewController:receiptsController];
        } else if (indexPath.row == 2) {
            FeedbackViewController *feedbackController = [[FeedbackViewController alloc] init];
            newController = [[UINavigationController alloc] initWithRootViewController:feedbackController];
        }
        
        [newController.navigationBar setBackgroundImage:[UIImage imageNamed:@"header.png"] forBarMetrics:UIBarMetricsDefault];
        
        [self.viewDeckController closeLeftViewAnimated:YES completion:^(IIViewDeckController *controller) {
            controller.centerController = newController;
        }];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        NSURL *logoutURL = [NSURL URLWithString:[AppConfig getConfigValue:@"LogoutPath"]];

        AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:logoutURL];

        NSString *authToken = [KeychainHelper getAuthenticationToken];

        NSMutableURLRequest *getRequest = [httpClient requestWithMethod:@"DELETE" path:[logoutURL.absoluteString stringByAppendingString:authToken] parameters:nil];

        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:getRequest];

        [operation setCompletionBlockWithSuccess:
         ^(AFHTTPRequestOperation *operation, id responseObject){

             [KeychainHelper reset];
             LoginViewController *loginController = [[LoginViewController alloc] init];
             UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:loginController];
             [self.view.window setRootViewController:navController];
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             //NSString *response = [operation responseString];
         }];
        
        [operation start];
    }
}

@end
