//
//  ItemCell.h
//  Homepwner
//
//  Created by Jaimie Zhu on 6/21/15.
//  Copyright © 2015 Jaimie Zhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ItemCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *serialNumber;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;

@end
