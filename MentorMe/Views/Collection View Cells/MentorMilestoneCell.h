//
//  MentorMilestoneCell.h
//  MentorMe
//
//  Created by Taylor Murray on 8/7/18.
//  Copyright © 2018 Taylor Murray. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFUser+ExtendedUser.h"
#import "ParseUI.h"

@protocol GoToMilestone
-(void)gotoMilestone:(PFUser *)mentor;
@end

@interface MentorMilestoneCell : UICollectionViewCell
@property (strong, nonatomic) id<GoToMilestone> delegate;
@property (strong, nonatomic) IBOutlet UIButton *buttonSecret;
@property (strong, nonatomic) IBOutlet PFImageView *mentorView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) PFUser *mentorUser;
-(void)formatWithMentor:(PFUser *)mentor;
@end
