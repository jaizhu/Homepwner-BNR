//
//  Item.h
//  RandomItems
//
//  Created by Jaimie Zhu on 6/18/15.
//  Copyright (c) 2015 Jaimie Zhu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Item : NSObject <NSCoding>

///////////////////// INSTANCE VARIABLES /////////////////////
@property (nonatomic, strong) Item *containedItems;
@property (nonatomic, weak) Item *container;

@property (nonatomic, copy) NSString *name, *serialNumber;
@property (nonatomic) int valueInDollars;
@property (nonatomic, readonly, strong) NSDate *dateCreated;

@property (nonatomic, copy) NSString *itemKey;

//////////////////////// CLASS METHOD ////////////////////////
+ (instancetype)randomItem;

//////////////////////// INITIALIZERS ////////////////////////
- (instancetype)initWithName:(NSString *)name
              valueInDollars:(int)value
                serialNumber:(NSString *)sNumber NS_DESIGNATED_INITIALIZER;

- (instancetype)initWithName:(NSString *)name;

@end
