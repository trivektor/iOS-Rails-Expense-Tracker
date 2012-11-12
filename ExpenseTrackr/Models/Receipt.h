//
//  Receipt.h
//  ExpenseTrackr
//
//  Created by Tri Vuong on 11/11/12.
//  Copyright (c) 2012 Crafted By Tri. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Receipt : NSObject

@property (nonatomic) NSInteger receiptId;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *description;
@property (nonatomic, retain) NSString *imageFileName;
@property (nonatomic, retain) NSString *createdAt;

@end
