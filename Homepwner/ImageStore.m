//
//  ImageStore.m
//  Homepwner
//
//  Created by Jaimie Zhu on 6/22/15.
//  Copyright (c) 2015 Jaimie Zhu. All rights reserved.
//

#import "ImageStore.h"

@interface ImageStore ()
@property (nonatomic) NSMutableDictionary *imageDictionary;
@end

@implementation ImageStore

/* GETS PATH AND SAVES IMAGE */
- (void)setImage:(UIImage *)image forKey:(NSString *)key {
    if (image) {
        self.imageDictionary[key] = image;
        NSString *imagePath = [self imagePathForKey:key];
        NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
        [imageData writeToFile:imagePath atomically:YES];
    } else {
        [self.imageDictionary removeObjectForKey:key];
        NSString *imagePath = [self imagePathForKey:key];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager removeItemAtPath:imagePath error:nil];
    }
}

/* MADE TO READ AND LOAD AN IMAGE FROM THE FILE SYSTEM */
- (UIImage *)imageForKey:(NSString *)key {
    UIImage *image = self.imageDictionary[key];
    if (!image) { // if the image is not in the dictionary
        NSString *imagePath = [self imagePathForKey:key];
        image = [UIImage imageWithContentsOfFile:imagePath];
        if (image) {
            self.imageDictionary[key] = image;
        }
    }
    return image;
}

// MARK: Notifications
- (void)observeMemoryWarningNotification:(NSNotificationCenter *)note {
    // clear the cache
    NSLog(@"flushing %ld images from the image store", self.imageDictionary.count);
    [self.imageDictionary removeAllObjects];
}

/* IMPLEMENT INITIALIZER */
- (instancetype)init {
    self = [super init];
    if (self) {
        self.imageDictionary = [NSMutableDictionary dictionary];
        
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self
               selector:@selector(observeMemoryWarningNotification:)
                   name:UIApplicationDidReceiveMemoryWarningNotification
                 object:[UIApplication sharedApplication]];
    }
    return self;
}

/* CREATING A PATH FOR IMAGES TO BE SAVED */
- (NSString *)imagePathForKey:(NSString *)key {
    NSArray *directories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                               NSUserDomainMask,
                                                               YES);
    NSString *documentDirectory = [directories firstObject];
    NSString *imagePath = [documentDirectory stringByAppendingPathComponent:key];
    return imagePath;
}

@end
