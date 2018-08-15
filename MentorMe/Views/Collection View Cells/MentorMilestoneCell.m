//
//  MentorMilestoneCell.m
//  MentorMe
//
//  Created by Taylor Murray on 8/7/18.
//  Copyright © 2018 Taylor Murray. All rights reserved.
//

#import "MentorMilestoneCell.h"
#import "ProfileDataDelegate.h"
@implementation MentorMilestoneCell
-(void)formatWithMentor:(PFUser *)mentor{
    
    self.mentorView.file = mentor.profilePic;
    [self.mentorView loadInBackground];
    self.mentorView.layer.masksToBounds = YES;
    self.mentorView.layer.cornerRadius = self.mentorView.frame.size.width/2;
    self.mentorUser = mentor;
    self.nameLabel.text = mentor.name;
    self.nameLabel.font = [UIFont fontWithName:@"Avenir" size:12];
    self.buttonSecret = [[UIButton alloc]init];
    
}


- (IBAction)tappedSecretButton:(id)sender {
    [self.delegate gotoMilestone:self.mentorUser];
}

@end
