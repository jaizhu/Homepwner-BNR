//
//  ItemsViewController.m
//  Homepwner
//
//  Created by Jaimie Zhu on 6/19/15.
//  Copyright (c) 2015 Jaimie Zhu. All rights reserved.
//

#import "ItemsViewController.h"
#import "ItemStore.h"
#import "Item.h"
#import "ItemCell.h"
#import "DetailViewController.h"
#import "ImageStore.h"

@interface ItemsViewController ()
@property (nonatomic) ItemStore *itemStore;
@property (nonatomic) IBOutlet UIView *headerView;
@property (nonatomic) ImageStore *imageStore;
@end

@implementation ItemsViewController

- (instancetype)initWithItemStore:(ItemStore *)store ImageStore:(ImageStore *)images {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.itemStore = store;
        self.imageStore = images;
        self.navigationItem.title = @"Homepwner";
        
        // create a new bar button item that will send addNewItem: to this VC
        UIBarButtonItem *barItem =
        [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                      target:self
                                                      action:@selector(addItemButtonPressed:)];
        
        // set the bar button item to the rightmost button in the nav bar for this VC
        self.navigationItem.rightBarButtonItem = barItem;
        
        self.navigationItem.leftBarButtonItem = [self editButtonItem];
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return self.itemStore.allItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // get a new or recycled cell
    ItemCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"ItemCell"
                                                          forIndexPath:indexPath];
    
    // configure the cell with the Item's properties
    Item *item = self.itemStore.allItems[indexPath.row];
    cell.nameLabel.text = item.name;
    cell.serialNumber.text = item.serialNumber;
    cell.valueLabel.text = [NSString stringWithFormat:@"$%d", item.valueInDollars];
    
    return cell;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // load the ItemCell nib
    UINib *itemCellNib = [UINib nibWithNibName:@"ItemCell" bundle:nil];
    
    // register this nib as the template for new ItemCells
    [self.tableView registerNib:itemCellNib forCellReuseIdentifier:@"ItemCell"];
}

- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {
    // if the tavle is asking to commit a delete operation...
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // find the item to delete and remove it from the ItemStore
        Item *item = self.itemStore.allItems[indexPath.row];
        
        // user must confirm deletion
        NSString *title = [NSString stringWithFormat:@"Delete %@?", item.name];
        NSString *message = @"Are you sure you want to delete this item?";
        
        UIAlertController *ac =
        [UIAlertController alertControllerWithTitle:title
                                            message:message
                                     preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *cancelAction =
        [UIAlertAction actionWithTitle:@"Cancel"
                                 style:UIAlertActionStyleCancel
                               handler:nil];
        
        [ac addAction:cancelAction];
        
        UIAlertAction *deleteAction =
        [UIAlertAction actionWithTitle:@"Delete"
                                 style:UIAlertActionStyleDestructive
                               handler:^(UIAlertAction *action) {
                                   [self.itemStore removeItem:item];
                                   
                                   // and remove its image from the image store
                                   [self.imageStore setImage:nil forKey:item.itemKey];
                                   
                                   // and remove the deleted row from the table
                                   [self.tableView deleteRowsAtIndexPaths:@[indexPath]
                                                         withRowAnimation:UITableViewRowAnimationFade];

                               }];
        
        [ac addAction:deleteAction];
        
        // use popover whenever possible (regular width environments)
        ac.modalPresentationStyle = UIModalPresentationPopover;
        
        // configure popover properties
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        if (cell) {
            ac.popoverPresentationController.sourceView = cell;
            ac.popoverPresentationController.sourceRect = cell.bounds;
        }
        
        // present the alert controller
        [self presentViewController:ac animated:YES completion:nil];
    }
}

- (void)tableView:(UITableView *)tableView
moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath
      toIndexPath:(NSIndexPath *)destinationIndexPath {
    // update the array
    [self.itemStore moveItemAtIndex:sourceIndexPath.row
                            toIndex:destinationIndexPath.row];
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // get the tiem for the selected row
    Item *itemToShow = self.itemStore.allItems[indexPath.row];
    
    // create a detail view controller
    DetailViewController *dvc =
    [[DetailViewController alloc] initWithItem:itemToShow
                                    imageStore:self.imageStore];
    
    // push it onto the navigation stack
    [self showViewController:dvc sender:self];
}

/* OVERRIDING VIEWWILLAPPEAR TO UPDATE THE EDITED DATA */
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

/* ADD A NEW ITEM (EXIST IN THE HEADER */
- (IBAction)addItemButtonPressed:(id)sender {
    [self presentDetailForNewItem];
}

- (void)presentDetailForNewItem {
    DetailViewController *dvc = [[DetailViewController alloc] initWithItem:nil
                                                                imageStore:self.imageStore];
    
    // this is where we are putting the blocks
    dvc.cancelBlock = ^{
        [self dismissViewControllerAnimated:YES completion:nil];
    };
    
    dvc.saveBlock = ^(Item *newItem) {
        [self dismissViewControllerAnimated:YES completion:^{
            // insert the item into the store
            [self.itemStore insertItem:newItem];
            
            // insert a cell for the item into the table view
            NSUInteger index = [self.itemStore.allItems indexOfObjectIdenticalTo:newItem];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
            [self.tableView insertRowsAtIndexPaths:@[indexPath]
                                  withRowAnimation:UITableViewRowAnimationTop];
        }];
    };
    
    UINavigationController *nc =
    [[UINavigationController alloc] initWithRootViewController:dvc];
    
    // make it fancy
    nc.modalPresentationStyle = UIModalPresentationFormSheet;
    
    [self presentViewController:nc animated:YES completion:nil];
}

//- (IBAction)toggleEditingMode:(id)sender {
//    // if you are currently in editing mode...
//    if (self.editing) {
//        // change the text of the button to inform the user
//        [sender setTitle:@"Edit" forState:UIControlStateNormal];
//        // and exit editing mode
//        [self setEditing:NO animated:YES];
//    } else {
//        // change the button
//        [sender setTitle:@"Done" forState:UIControlStateNormal];
//        // and enter editing mode
//        [self setEditing:YES animated:YES];
//    }
//}

@end
