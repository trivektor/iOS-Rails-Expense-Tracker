//
//  ReceiptViewController.m
//  ExpenseTrackr
//
//  Created by Tri Vuong on 11/22/12.
//  Copyright (c) 2012 Crafted By Tri. All rights reserved.
//

#import "ReceiptViewController.h"

@interface ReceiptViewController ()

@end

@implementation ReceiptViewController

@synthesize receipt;

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
    
    [self.navigationItem setTitle:self.receipt.name];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"header.png"] forBarMetrics:UIBarMetricsDefault];
    
    UIBarButtonItem *exitButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(exit)];
    
    [exitButton setTintColor:[UIColor blackColor]];
    
    [self.navigationItem setRightBarButtonItem:exitButton];
    
    NSString *mediumImageURL = [self.receipt.mediumImageURL stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:mediumImageURL]];
    
    [receiptImage setImage:[UIImage imageWithData:imageData]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)exit
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end
