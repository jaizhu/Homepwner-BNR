//
//  ImageStore.h
//  Homepwner
//
//  Created by Jaimie Zhu on 6/22/15.
//  Copyright (c) 2015 Jaimie Zhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageStore : NSObject

- (void)setImage:(UIImage *)image forKey:(NSString *)key;
- (UIImage *)imageForKey:(NSString *)key;

@end
