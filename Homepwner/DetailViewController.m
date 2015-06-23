//
//  DetailViewController.m
//  Homepwner
//
//  Created by Jaimie Zhu on 6/22/15.
//  Copyright (c) 2015 Jaimie Zhu. All rights reserved.
//

#import "DetailViewController.h"
#import "Item.h"
#import "ImageStore.h"

@interface DetailViewController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cameraItem;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *serialNumberField;
@property (weak, nonatomic) IBOutlet UITextField *valueField;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (nonatomic) Item *item;
@property (nonatomic) ImageStore *imageStore;
@end

@implementation DetailViewController

- (IBAction)backgroundTapped:(id)sender {
    [self.view endEditing:YES];
    
//    for (UIView *subview in self.view.subviews) {
//        if([subview hasAmbiguousLayout]) {
//            [subview exerciseAmbiguityInLayout];
//        }
//    }
}

- (instancetype)initWithItem:(Item *)item
                  imageStore:(ImageStore *)images {
    self = [super initWithNibName:@"DetailViewController" bundle:nil];
    if (self) {
        self.item = item;
        self.navigationItem.title = item.name;
        self.imageStore = images;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // import values from the current item into the UI
    self.nameField.text = self.item.name;
    self.serialNumberField.text = self.item.serialNumber;
    self.valueField.text = [NSString stringWithFormat:@"%d", self.item.valueInDollars];
    
    // represent the date created legibly
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    dateFormatter.timeStyle = NSDateFormatterNoStyle;
    self.dateLabel.text = [dateFormatter stringFromDate:self.item.dateCreated];
    
    // display the items image, if there is one for it in the image store
    UIImage *itemImage = [self.imageStore imageForKey:self.item.itemKey];
    self.imageView.image = itemImage;
}

/* UPDATES THE VIEW TO HOLD THE EDITED DATA */
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // clear first responder
    [self.view endEditing:YES];
    
    // update the item with the text field contents
    self.item.name = self.nameField.text;
    self.item.serialNumber = self.serialNumberField.text;
    self.item.valueInDollars = [self.valueField.text intValue];
}

- (IBAction)pictureButtonPressed:(UIBarButtonItem *)sender {
    [self takePicture];
}

/* SEE IF THERE IS A CAMERA AVAILABLE AND SET A SOURCETYPE */
- (void)takePicture {
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    
    // if the device has a camera, take a picture
    // otherwise, pick from the library
    if ([UIImagePickerController
         isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else {
        ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    ipc.delegate = self;
    
    // present the UIImagePickerController
    [self presentViewController:ipc animated:YES completion:nil];
}

/* PUT THE IMAGE INTO THE UIIMAGEVIEW SO YOU CAN GO BACK AND SEE YOUR IMAGE */
- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info {
    // get the chosen image from the info dictionary
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    // store the image in the image store
    [self.imageStore setImage:image forKey:self.item.itemKey];
    
    // put the image into the image view
    self.imageView.image = image;
    
    // dismiss the image picker
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

/* MAKES IT SO THE KEYBOARD WILL LEAVE WHEN WE'RE DONE WITH IT */
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

/* OVERRIDING CONSTRAINT STUFF */
//- (void)viewDidLayoutSubviews {
//    for (UIView *subview in self.view.subviews) {
//        if ([subview hasAmbiguousLayout]) {
//            NSLog(@"AMBIGUOUS: %@", subview);
//        }
//    }
//}

@end
