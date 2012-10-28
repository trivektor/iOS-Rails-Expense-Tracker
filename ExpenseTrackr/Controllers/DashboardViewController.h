//
//  DashboardViewController.h
//  ExpenseTrackr
//
//  Created by Tri Vuong on 10/20/12.
//  Copyright (c) 2012 Crafted By Tri. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DashboardViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    __weak IBOutlet UITableView *optionsTable;
}

@property (nonatomic, retain) NSMutableArray *options;

- (void)performHouseKeepingTasks;

@end
