//
//  ReceiptImageCell.m
//  ExpenseTrackr
//
//  Created by Tri Vuong on 11/17/12.
//  Copyright (c) 2012 Crafted By Tri. All rights reserved.
//

#import "ReceiptImageCell.h"

@implementation ReceiptImageCell

@synthesize receiptThumb;

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)aReuseIdentifier
{
    self = [super initWithFrame: frame reuseIdentifier: aReuseIdentifier];
    if ( self)
    {
        UIView* mainView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 110, 85)];
        [mainView setBackgroundColor:[UIColor clearColor]];
        UIImageView *frameImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 110, 85)];
        //[frameImageView setImage:[UIImage imageNamed:@"tab-mask.png"]];
        self.receiptThumb = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 100, 75)];
        //self.captionLabel = [[UILabel alloc] initWithFrame:CGRectMake(13, 92, 127, 21)];
        //[captionLabel setFont:[UIFont systemFontOfSize:14]];
        [mainView addSubview:self.receiptThumb];
        [mainView addSubview:frameImageView];
        //[mainView addSubview:captionLabel];
        [self.contentView addSubview:mainView];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
