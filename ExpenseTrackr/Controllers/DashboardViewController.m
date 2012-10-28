//
//  DashboardViewController.m
//  ExpenseTrackr
//
//  Created by Tri Vuong on 10/20/12.
//  Copyright (c) 2012 Crafted By Tri. All rights reserved.
//

#import "DashboardViewController.h"
#import "SigninViewController.h"
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
    
    [cell.textLabel setText:[self.options objectAtIndex:indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        NSURL *logoutURL = [NSURL URLWithString:[AppConfig getConfigValue:@"LogoutPath"]];
        
        AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:logoutURL];
        
        NSString *authToken = [KeychainHelper getAuthenticationToken];
        
        NSMutableURLRequest *getRequest = [httpClient requestWithMethod:@"DELETE" path:[logoutURL.absoluteString stringByAppendingString:authToken] parameters:nil];
        
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:getRequest];
        
        [operation setCompletionBlockWithSuccess:
         ^(AFHTTPRequestOperation *operation, id responseObject){

//             NSHTTPCookieStorage * sharedCookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
//             NSArray * cookies = [sharedCookieStorage cookies];
//             for (NSHTTPCookie * cookie in cookies){
//                 if ([cookie.domain isEqualToString:logoutURL.host] && [cookie.name isEqualToString:@"auth_token"]){
//                     NSLog(@"deleting");
//                     [sharedCookieStorage deleteCookie:cookie];
//                 }
//             }
             
             [KeychainHelper reset];
             SigninViewController *signinController = [[SigninViewController alloc] init];
             signinController.modalPresentationStyle = UIModalTransitionStyleCoverVertical;
             
             UINavigationController *newNavController = [[UINavigationController alloc] initWithRootViewController:signinController];
             
             [self presentViewController:newNavController animated:TRUE completion:nil];
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             //NSString *response = [operation responseString];
         }];
        
        [operation start];
    }
}

@end
