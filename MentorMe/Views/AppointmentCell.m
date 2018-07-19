//
//  AppointmentCell.m
//  MentorMe
//
//  Created by Nico Salinas on 7/18/18.
//  Copyright © 2018 Taylor Murray. All rights reserved.
//

#import "AppointmentCell.h"
#import "AppointmentDetailsViewController.h"
#import "PFUser+ExtendedUser.h"
#import "Parse/Parse.h"
#import "DateTools.h"



@implementation AppointmentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setAppointment:(AppointmentModel *)appointment {
   
    _appointment = appointment;
   
/*    PFUser *mentor = self.appointment.mentor;
    self.mentorName.text = self.appointment.menteeUsername;
    self.mentorProfilePic.file = mentor.profilePic;
    
    _appointment = appointment;*/
    

    
    self.mentorName.text = self.appointment.mentorName;
    self.meetingDate.text = [self.appointment.meetingDate timeAgoSinceNow];
    self.meetingType.text = self.appointment.meetingType;
    self.meetingLocation.text = self.appointment.meetingLocation;
        
    
}

@end
