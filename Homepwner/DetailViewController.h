//
//  DetailViewController.h
//  Homepwner
//
//  Created by Jaimie Zhu on 6/22/15.
//  Copyright (c) 2015 Jaimie Zhu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Item;
@class ItemStore;
@class ImageStore;

@interface DetailViewController : UIViewController
    <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate>

@property (nonatomic, copy) void(^cancelBlock)(void);
@property (nonatomic, copy) void(^saveBlock)(Item *);

- (instancetype)initWithItem:(Item *)item imageStore:(ImageStore *)images;

@end
