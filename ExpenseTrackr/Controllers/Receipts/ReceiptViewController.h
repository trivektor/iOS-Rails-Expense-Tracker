//
//  ReceiptViewController.h
//  ExpenseTrackr
//
//  Created by Tri Vuong on 11/22/12.
//  Copyright (c) 2012 Crafted By Tri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Receipt.h"

@interface ReceiptViewController : UIViewController
{
    
    __weak IBOutlet UIImageView *receiptImage;
}

@property (nonatomic, retain) Receipt *receipt;

- (void)exit;

@end
