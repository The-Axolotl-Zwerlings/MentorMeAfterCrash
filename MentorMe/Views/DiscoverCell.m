//
//  DiscoverCell.m
//  MentorMe
//
//  Created by Taylor Murray on 7/18/18.
//  Copyright © 2018 Taylor Murray. All rights reserved.
//

#import "DiscoverCell.h"
#import "PFUser+ExtendedUser.h"
@implementation DiscoverCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutCell:(PFUser *)user{
    self.nameLabel.text = user.name;
    self.schoolLabel.text = user.school;
    self.jobLabel.text = user.jobTitle;
    self.profilePicView.image = [UIImage imageNamed:@"user"];
    self.interestsLabel.text = @"";
    if([self.isGivingAdvice boolValue]){
        for(NSString *interest in user.getAdviceInterests){
            NSString *stringInterest = [interest stringByAppendingString:@", "];
            self.interestsLabel.text = [self.interestsLabel.text stringByAppendingString:stringInterest];
        }
    } else{
        for(NSString *interest in user.giveAdviceInterests){
            NSString *stringInterest = [interest stringByAppendingString:@", "];
            self.interestsLabel.text = [self.interestsLabel.text stringByAppendingString:stringInterest];
        }
    }
    
}
@end
