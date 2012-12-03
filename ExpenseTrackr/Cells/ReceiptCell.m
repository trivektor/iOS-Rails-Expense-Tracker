//
//  ReceiptCell.m
//  ExpenseTrackr
//
//  Created by Tri Vuong on 12/2/12.
//  Copyright (c) 2012 Crafted By Tri. All rights reserved.
//

#import "ReceiptCell.h"

@implementation ReceiptCell

@synthesize receiptNameLabel, receiptDateLabel, receiptImage;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)awakeFromNib
{
    receiptImage.layer.shadowColor = [[UIColor blackColor] CGColor];
    receiptImage.layer.shadowOffset = CGSizeMake(2.0, 2.0);
    receiptImage.layer.shadowOpacity = 1.0;
    receiptImage.layer.shadowRadius = 5.0;
    receiptImage.clipsToBounds = NO;
    receiptImage.layer.masksToBounds = NO;
}

@end
