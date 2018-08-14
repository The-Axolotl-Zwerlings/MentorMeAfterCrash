//
//  NotificationsTableViewCell.m
//  MentorMe
//
//  Created by Nihal Riyadh Jemal on 8/8/18.
//  Copyright © 2018 Taylor Murray. All rights reserved.
//

#import "NotificationsTableViewCell.h"
#import "Parse/Parse.h"

@implementation NotificationsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void) loadCell {
    self.titleText.text = self.senderString;
    
    if( [self.typeOfNotification isEqualToString: @"accepted" ]){
        self.titleText.text = [self.senderString stringByAppendingString:@" has accepted your invitation."];
    } else if ( [self.typeOfNotification isEqualToString:@"invite"]){
        self.titleText.text = [self.senderString stringByAppendingString:@" has requested a meeting with you."];
    }
    
}

- (IBAction)onTapAccept:(id)sender {
    PFQuery *query = [PFQuery queryWithClassName:@"AppointmentModel"];
    [query getObjectInBackgroundWithId:self.identity block:^(PFObject *appointment, NSError *error) {
        appointment[@"confirmation"] = @"YES";
        [appointment saveInBackground];
    }];
}

- (IBAction)onTapDecline:(id)sender {
    PFQuery *query = [PFQuery queryWithClassName:@"Notifications"];
    [query getObjectInBackgroundWithId:toDelete.objectId block:^(PFObject *not, NSError *error) {
        [not deleteInBackground];
        [self fetchNotifications];
        //[self.inviteDetails removeFromSuperview];
    }];
    
}


@end
