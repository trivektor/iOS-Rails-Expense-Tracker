//
//  CustomTableCellViewController.h
//  ExpenseTrackr
//
//  Created by Tri Vuong on 10/12/12.
//  Copyright (c) 2012 Crafted By Tri. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTableCellViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) IBOutlet UITableViewCell *cellOne;
@property (nonatomic, strong) IBOutlet UITableViewCell *cellTwo;

@end
