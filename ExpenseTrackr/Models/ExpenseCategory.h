//
//  ExpenseCategory.h
//  Expense Tracking
//
//  Created by Tri Vuong on 9/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ExpenseCategory : NSObject

@property (nonatomic, retain) NSString *name;
@property (nonatomic) double total;

+ (NSArray *)getAll;

@end
