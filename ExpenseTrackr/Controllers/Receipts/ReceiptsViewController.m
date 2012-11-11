//
//  ReceiptsViewController.m
//  ExpenseTrackr
//
//  Created by Tri Vuong on 11/9/12.
//  Copyright (c) 2012 Crafted By Tri. All rights reserved.
//

#import "ReceiptsViewController.h"

@interface ReceiptsViewController ()

@end

@implementation ReceiptsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationItem setTitle:@"Receipts"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
