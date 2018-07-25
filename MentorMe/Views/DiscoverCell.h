//
//  DiscoverCell.h
//  MentorMe
//
//  Created by Taylor Murray on 7/18/18.
//  Copyright © 2018 Taylor Murray. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParseUI.h"
@interface DiscoverCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *occupationLabel;
@property (strong, nonatomic) IBOutlet UILabel *educationLabel;
//@property (strong, nonatomic) IBOutlet UILabel *interestsLabel;
@property (strong, nonatomic) IBOutlet PFImageView *profilePicView;
@property (strong, nonatomic) NSNumber *isGivingAdvice;
-(void)layoutCell:(PFUser *)user;
@end
