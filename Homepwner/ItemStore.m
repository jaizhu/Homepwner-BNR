//
//  ItemStore.m
//  Homepwner
//
//  Created by Jaimie Zhu on 6/21/15.
//  Copyright © 2015 Jaimie Zhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemStore.h"
#import "Item.h"

@interface ItemStore ()
@property (nonatomic) NSMutableArray *items;
@end

@implementation ItemStore

- (void)insertItem:(Item *)item {
    [self.items addObject:item];
}

- (NSArray *)allItems {
    return [_items copy];
}

- (Item *)createItem {
    Item *newItem = [Item new];
    [self.items addObject:newItem];
    return newItem;
}

// MARK: Notifications
- (void)observeAppEnteredBackgroundNotification:(NSNotification *)note {
    BOOL success = [self saveChanges];
    if (success) {
        NSLog(@"Saved all of the items");
    } else {
        NSLog(@"Couldn't save all of the items");
    }
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.items = [NSMutableArray array];
        
        // keeping track of archived things
        NSString *archivePath = [self itemArchivePath];
        // making them into an array
        NSArray *archivedItems =
        [NSKeyedUnarchiver unarchiveObjectWithFile:archivePath];
        
        // adding them to the itemStore
        [self.items addObjectsFromArray:archivedItems];
        
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self
               selector:@selector(observeAppEnteredBackgroundNotification:)
                   name:UIApplicationDidEnterBackgroundNotification
                 object:[UIApplication sharedApplication]];
    }
    return self;
}

- (void)removeItem:(Item *)item {
    [self.items removeObjectIdenticalTo:item];
}

- (void)moveItemAtIndex:(NSInteger)source
                toIndex:(NSInteger)destination {
    if (source == destination) {
        return;
    }
    
    // get a pointer to the object being removed so you can re-insert it
    id movedItem = self.items[source];
    
    // remove the item from the array
    [self.items removeObjectIdenticalTo:movedItem];
    
    // insert the item at its new location
    [self.items insertObject:movedItem
                     atIndex:destination];
}

/* CONSTRUCTING PATH TO A FILE IN THE DOCUMENTS DIRECTORY */
- (NSString *)itemArchivePath {
    NSArray *documentsDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [documentsDirectories firstObject];
    NSString *documentPath = [documentDirectory stringByAppendingPathComponent:@"items.archive"];
    return documentPath;
}

/* KICKS OFF THE SAVING OPERATION */
- (BOOL)saveChanges {
    NSLog(@"Saving items to %@", [self itemArchivePath]);
    BOOL success = [NSKeyedArchiver archiveRootObject:self.items toFile:[self itemArchivePath]];
    return success;
}

@end
