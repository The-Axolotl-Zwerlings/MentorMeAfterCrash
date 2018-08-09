//
//  DiscoverCell.h
//  MentorMe
//
//  Created by Taylor Murray on 7/18/18.
//  Copyright © 2018 Taylor Murray. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParseUI.h"
#import "Parse/Parse.h"
#import "PFUser+ExtendedUser.h"
#import "QuartzCore/CALayer.h"

@interface DiscoverCell : UITableViewCell <UICollectionViewDelegate, UICollectionViewDataSource>{
    UICollectionView *collectionViewA;
    UICollectionView *collectionViewB;
}

@property (strong, nonatomic) PFUser *userForCell;

@property (nonatomic, strong) NSArray *incomingGetInterests;
@property (nonatomic, strong) NSArray *incomingGiveInterests;

@property (nonatomic, strong) UIImageView *backgroundImage;
@property (nonatomic) NSInteger selectedIndex;

@property (strong, nonatomic) NSSet *giveSet;
@property (strong, nonatomic) NSSet *getSet;

- (void) loadCell;
- (void) loadCollectionViews;

@end
