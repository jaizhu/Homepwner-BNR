//
//  ItemStore.h
//  Homepwner
//
//  Created by Jaimie Zhu on 6/21/15.
//  Copyright © 2015 Jaimie Zhu. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Item;

@interface ItemStore : NSObject

- (NSArray *)allItems;
- (Item *)createItem;
- (void)removeItem:(Item *)item;
- (void)moveItemAtIndex:(NSInteger)source
                toIndex:(NSInteger)destination;

@end
