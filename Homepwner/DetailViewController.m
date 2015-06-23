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

/* BLOCKS FOR MODAL VIEWS */
- (void)cancel:(id)sender {
    if (self.cancelBlock) {
        self.cancelBlock();
    }
}

- (void)save:(id)sender {
    if (self.saveBlock) {
        self.saveBlock(self.item);
    }
}

- (instancetype)initWithItem:(Item *)item
                  imageStore:(ImageStore *)images {
    self = [super initWithNibName:@"DetailViewController" bundle:nil];
    if (self) {
        self.item = item;
        self.imageStore = images;
        self.navigationItem.title = item.name;
        
        if (item == nil) {
            // we were not given an item, so make an empty one
            self.item = [[Item alloc] init];
            
            // since this is a new item, provide cancel and done buttons
            UIBarButtonItem *cancelItem =
            [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                          target:self
                                                          action:@selector(cancel:)];
            self.navigationItem.leftBarButtonItem = cancelItem;
            
            UIBarButtonItem *doneItem =
            [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                          target:self
                                                          action:@selector(save:)];
            self.navigationItem.rightBarButtonItem = doneItem;
        } else {
            // otherwise, just provide defaults
            self.navigationItem.leftBarButtonItem = self.navigationItem.backBarButtonItem;
            self.navigationItem.rightBarButtonItem = nil;
        }
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
//    [_imageView setClipsToBounds:YES];
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

/* OVERRIDING FOR CONSTRAINING ADDITIONAL VIEW TO ADD TO HEIRARCHY */
/*
- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *iv = [UIImageView new];
    
    // the contentmode of the image view in the XIB was aspect fit:
    iv.contentMode = UIViewContentModeScaleAspectFit;
    
    // do not produce a translated constraint for this view
    iv.translatesAutoresizingMaskIntoConstraints = NO;
    
    // the image view was a subview of the view
    [self.view addSubview:iv];
    
    // the image view was pointed-to by the imageView property
    self.imageView = iv;
    
    // setting hugging property to be less those that of the text fields
    [self.imageView setContentHuggingPriority:200
                                      forAxis:UILayoutConstraintAxisVertical];
    
    // creating a dictionary of names for the views
    NSDictionary *nameMap = @{ @"imageView" : self.imageView,
                               @"dateLabel" : self.dateLabel,
                               @"toolbar" : self.toolbar };
    
    // create horizontal and vertical image constraints
    NSArray *horizontalConstraints =
        [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[imageView]-0-|"
                                                options:0
                                                metrics:nil
                                                  views:nameMap];
    NSArray *verticalConstraints =
        [NSLayoutConstraint constraintsWithVisualFormat:@"V:[dateLabel]-[imageView]-[toolbar]"
                                                options:0
                                                metrics:nil
                                                  views:nameMap];
    
    // set the constraint properities to YES
    [NSLayoutConstraint activateConstraints:horizontalConstraints];
    [NSLayoutConstraint activateConstraints:verticalConstraints];
}
*/

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
    ipc.modalPresentationStyle = UIModalPresentationPopover;
    ipc.popoverPresentationController.barButtonItem = self.cameraItem;
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

// OVERRIDING CONSTRAINT STUFF 
- (void)viewDidLayoutSubviews {
    for (UIView *subview in self.view.subviews) {
        if ([subview hasAmbiguousLayout]) {
            NSLog(@"AMBIGUOUS: %@", subview);
        }
    }
}

@end
