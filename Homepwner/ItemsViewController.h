//
//  ItemsViewController.h
//  Homepwner
//
//  Created by Jaimie Zhu on 6/19/15.
//  Copyright (c) 2015 Jaimie Zhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ItemStore;
@class ImageStore;

@interface ItemsViewController : UITableViewController

- (instancetype)initWithItemStore:(ItemStore *)store ImageStore:(ImageStore *)images;

@end
