//
//  ExpenseCategory.m
//  Expense Tracking
//
//  Created by Tri Vuong on 9/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ExpenseCategory.h"

@implementation ExpenseCategory

@synthesize name, total;

+ (NSArray *)getAll
{
    NSArray *allCategories = [NSArray arrayWithObjects:
                              @"Food",
                              @"Drinks",
                              @"Groceries",
                              @"Clothing",
                              @"Education",
                              @"Entertainment",
                              @"Movies",
                              @"Sports",
                              @"Family",
                              @"Gifts",
                              @"Automobile",
                              @"Household",
                              @"Health",
                              @"Life",
                              @"Insurance",
                              @"Mortgage Payment",
                              @"Medical Dental",
                              @"Phone",
                              @"Personal Care",
                              @"Rent",
                              @"Travel",
                              @"Taxes",
                              @"Cable",
                              @"Gas",
                              @"Internet Access",
                              @"Water",
                              nil];
    return allCategories;
}

@end
