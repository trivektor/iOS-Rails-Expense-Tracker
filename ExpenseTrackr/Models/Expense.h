//
//  Expense.h
//  ExpenseTrackr
//
//  Created by Tri Vuong on 10/14/12.
//  Copyright (c) 2012 Crafted By Tri. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Expense : NSObject

@property (nonatomic) int expenseId;
@property (nonatomic, retain) NSString *name;
@property (nonatomic) double amount;
@property (nonatomic) double tax;
@property (nonatomic) double tip;
@property (nonatomic, retain) NSString *category;
@property (nonatomic, retain) NSString *description;
@property (nonatomic, retain) NSString *createdAt;

@end
