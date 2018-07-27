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



@interface DiscoverCell : UITableViewCell <UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *occupationLabel;
@property (strong, nonatomic) IBOutlet UILabel *educationLabel;
@property (strong, nonatomic) IBOutlet PFImageView *profilePicView;
@property (strong, nonatomic) NSNumber *isGivingAdvice;

@property (strong, nonatomic) IBOutlet UICollectionView *getCollectionView;
@property (strong, nonatomic) IBOutlet UICollectionView *giveCollectionView;

@property (nonatomic, strong) NSArray *getInterests;
@property (nonatomic, strong) NSArray *giveInterets;

@property (strong, nonatomic) PFUser *userForCell;

- (void)layoutCell:(PFUser *)user;


@end
