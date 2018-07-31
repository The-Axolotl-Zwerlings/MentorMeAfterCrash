//
//  GetAdviceCollectionViewCell.h
//  MentorMe
//
//  Created by Nico Salinas on 7/24/18.
//  Copyright © 2018 Taylor Murray. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Parse/Parse.h"
#import "ParseUI.h"
#import "PFUser+ExtendedUser.h"
#import "InterestModel.h"
#import "MentorDetailsViewController.h"

@interface GetAdviceCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *backgroundCell;
@property (weak, nonatomic) IBOutlet UILabel *interestNameLabel;
@property (weak, nonatomic) InterestModel *interest;



@end
