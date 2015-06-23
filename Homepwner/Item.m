//
//  Item.m
//  RandomItems
//
//  Created by Jaimie Zhu on 6/18/15.
//  Copyright (c) 2015 Jaimie Zhu. All rights reserved.
//

#import "Item.h"

@interface Item ()
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_DESIGNATED_INITIALIZER;
@end

@implementation Item

// MARK: - NSCoding
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.dateCreated forKey:@"dateCreated"];
    [aCoder encodeObject:self.itemKey forKey:@"itemKey"];
    [aCoder encodeObject:self.serialNumber forKey:@"serialNumber"];
    [aCoder encodeInt:self.valueInDollars forKey:@"valueInDollars"];
}

//////////////////// ARCHIVING AND UNARCHIVING //////////////////////
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    
    if (self) {
        _name = [aDecoder decodeObjectForKey:@"name"];
        _dateCreated = [aDecoder decodeObjectForKey:@"dateCreated"];
        _itemKey = [aDecoder decodeObjectForKey:@"itemKey"];
        _serialNumber = [aDecoder decodeObjectForKey:@"serialNumber"];
        _valueInDollars = [aDecoder decodeIntForKey:@"valueInDollars"];
    }
    return self;
}

//////////////// OVERRIDING THE DESCRIPTION METHOD //////////////////
- (NSString *)description
{
    NSString *descriptionString =
    [[NSString alloc] initWithFormat:@"%@ (%@): Worth $%d, recorded on %@",
     self.name,
     self.serialNumber,
     self.valueInDollars,
     self.dateCreated];
    
    return descriptionString;
}

/////////////// IMPLEMENTING DESIGNATED INITIALIZER ////////////////
- (instancetype)initWithName:(NSString *)name
              valueInDollars:(int)value
                serialNumber:(NSString *)sNumber
{
    // call the super class's initializer
    // and check for nil
    if (self = [super init])
    {
        // give instance variables some valuessssss wooohooo
        _name = name;
        _valueInDollars = value;
        _serialNumber = sNumber;
        
        // set the date created to be today
        _dateCreated = [[NSDate alloc] init];
        _itemKey = [[NSUUID UUID] UUIDString];
    }
    return self;
}

- (instancetype)initWithName:(NSString *)name
{
    return [self initWithName:name
               valueInDollars:0
                 serialNumber:@""];
}

/////////// CHALLENGE: IMPLEMENTING OTHER INITIALIZER //////////////
- (instancetype)initWithName:(NSString *)name
                serialNumber:(NSString *)sNumber;
{
    return [self initWithName:(NSString *)name
               valueInDollars:0
                 serialNumber:(NSString *)sNumber];
    return self;
}

//////////////////////// OVERRIDING INIT //////////////////////////
- (instancetype)init
{
    return [self initWithName:@"Item"];
}

/////////////////// IMPLEMENTING CLASS METHOD ////////////////////
+ (instancetype)randomItem
{
    // create some array of three adjectives
    NSArray *randomAdjList = @[@"Fluffy", @"Rusty", @"Shiny"];
    
    // create some array of three nouns
    NSArray *randomNounList = @[@"Bear", @"Spork", @"Mac"];
    
    // get index of random adj/noun from the lists
    unsigned int adjIndex = arc4random_uniform((unsigned int)[randomAdjList count]);
    unsigned int nounIndex = arc4random_uniform((unsigned int)[randomNounList count]);
    
    NSString *randomName = [NSString stringWithFormat:@"%@ %@",
                            randomAdjList[adjIndex],
                            randomNounList[nounIndex]];
    
    // generate some random value in dollars, [0,99]
    int randomValue = arc4random_uniform(100);
    
    // use NSUUID to generate a random 5=letter string for serial number
    NSString *randomSerialNumber = [[[NSUUID UUID] UUIDString] substringToIndex:5];
    
    // instantiate the new item with the random values
    Item *newItem = [[self alloc] initWithName:randomName
                                valueInDollars:randomValue
                                  serialNumber:randomSerialNumber];
    return newItem;
}

////////////////////// OVERRIDING DEALLOC /////////////////////////
//- (void)dealloc
//{
//    NSLog(@"Setting items to nil...");
//}

///////////// IMPLEMENTING THINGS FOR WEAK REFERENCES //////////////
- (void)setContainedItem:(Item *)item
{
    _containedItems = item;
    
    // the container's contained item how has a
    // pointer to its owner!
    item.container = self;
}

@end







