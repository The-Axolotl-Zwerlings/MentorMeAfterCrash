//
//  GiveAdviceCollectionViewCell.h
//  MentorMe
//
//  Created by Nico Salinas on 7/24/18.
//  Copyright © 2018 Taylor Murray. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Parse/Parse.h"
#import "PFUser+ExtendedUser.h"
#import "ParseUI.h"

@interface GiveAdviceCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet PFImageView *interestIcon;
@property (weak, nonatomic) IBOutlet UILabel *interestNameLabel;

@end
