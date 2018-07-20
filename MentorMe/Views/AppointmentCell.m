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
   
    
    if(appointment.isMentor){
        self.otherAttendeeName.text = appointment.mentee.name;
        self.otherAttendeeProfilePic.file = appointment.mentee.profilePic;
        [self.otherAttendeeProfilePic loadInBackground];
        self.mentorOrMenteeLabel.text = @"You're the mentor!";
    } else{
        self.otherAttendeeName.text = appointment.mentor.name;
        self.otherAttendeeProfilePic.file = appointment.mentor.profilePic;
        [self.otherAttendeeProfilePic loadInBackground];
        self.mentorOrMenteeLabel.text = @"You're the mentee!";
    }
    
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM d, h:mm a"];
    
    
    self.meetingDate.text = [formatter stringFromDate:appointment.meetingDate];
    self.meetingType.text = self.appointment.meetingType;
    self.meetingLocation.text = self.appointment.meetingLocation;
        
    
}

@end
