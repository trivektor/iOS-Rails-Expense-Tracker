//
//  ReceiptCell.h
//  ExpenseTrackr
//
//  Created by Tri Vuong on 12/2/12.
//  Copyright (c) 2012 Crafted By Tri. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReceiptCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *receiptNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *receiptDateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *receiptImage;

@end
