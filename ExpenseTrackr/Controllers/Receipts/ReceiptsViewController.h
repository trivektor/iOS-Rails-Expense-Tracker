//
//  ReceiptsViewController.h
//  ExpenseTrackr
//
//  Created by Tri Vuong on 11/9/12.
//  Copyright (c) 2012 Crafted By Tri. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReceiptsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    
    __weak IBOutlet UITableView *receiptsTable;
}

@property (nonatomic, strong) UIView *spinnerView;

- (void)performHouseKeepingTasks;
- (void)setDelegates;
- (void)showNewReceiptForm;
+ (UIImage *)imageWithImage:(UIImage *)sourceImage scaledToSize:(CGSize)newSize;
+ (UIImage *)imageWithImage:(UIImage *)sourceImage scaledToSizeWithSameAspectRatio:(CGSize)targetSize;
- (void)postReceiptImage:(UIImage *)image;

@end
