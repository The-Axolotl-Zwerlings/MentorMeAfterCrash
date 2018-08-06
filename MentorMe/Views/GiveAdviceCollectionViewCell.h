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
#import "InterestModel.h"
#import "MentorDetailsViewController.h"

@interface GiveAdviceCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;

@property (weak, nonatomic) IBOutlet UILabel *interestNameLabel;
@property (weak, nonatomic) InterestModel *interest;


@end
