//
//  ReceiptsViewController.h
//  ExpenseTrackr
//
//  Created by Tri Vuong on 11/9/12.
//  Copyright (c) 2012 Crafted By Tri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AQGridView.h"

@interface ReceiptsViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, AQGridViewDataSource, AQGridViewDelegate>

@property (nonatomic, retain) UIView *spinnerView;
@property (nonatomic, retain) NSMutableArray *receipts;
@property (nonatomic, retain) IBOutlet AQGridView *receiptsGridView;

- (void)performHouseKeepingTasks;
- (void)setDelegates;
- (void)fetchReceiptsFromServer;
- (void)showNewReceiptForm;
+ (UIImage *)imageWithImage:(UIImage *)sourceImage scaledToSize:(CGSize)newSize;
+ (UIImage *)imageWithImage:(UIImage *)sourceImage scaledToSizeWithSameAspectRatio:(CGSize)targetSize;
- (void)postReceiptImage:(UIImage *)image;
- (void)setupPullToRefresh;

@end
