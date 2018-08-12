//
//  AppointmentModel.m
//  MentorMe
//
//  Created by Taylor Murray on 7/18/18.
//  Copyright © 2018 Taylor Murray. All rights reserved.
//

#import "AppointmentModel.h"

@implementation AppointmentModel


@dynamic mentor;
@dynamic mentee;
//@dynamic isMentor;
@dynamic meetingLocation;
@dynamic meetingDate;
@dynamic meetingType;
@dynamic isUpcoming;
//@dynamic confirmed;
@dynamic confirmation;
@dynamic recipient;


+(nonnull NSString *)parseClassName{
    return @"AppointmentModel";
}

+ (void) postAppointment:(BOOL)isMentor withPerson:( PFUser * _Nullable )otherAttendee withMeetingLocation: (NSString * _Nullable )meetingLocation withMeetingType: (NSString *_Nullable ) meetingType withMeetingDate: (NSDate * _Nullable )meetingDate withIsComing: (BOOL) isUpcoming withMessage:(NSString *)message withconfirmation:(NSString *) confirmation withCompletion: (void(^_Nullable)(BOOL succeeded, NSError * _Nullable error, AppointmentModel * _Nullable newAppointment))completion {
    
    PFObject *appointment = [PFObject objectWithClassName:@"AppointmentModel"];
    
    appointment[@"mentor"] = (isMentor) ? PFUser.currentUser : otherAttendee;
    appointment[@"mentee"] = (isMentor) ? otherAttendee : PFUser.currentUser;
    appointment[@"meetingLocation"] = meetingLocation;
    appointment[@"meetingType"] = meetingType;
    appointment[@"meetingDate"] = meetingDate;
    appointment[@"message"] = message;
    appointment[@"isUpcoming"] = @(isUpcoming);
    appointment[@"confirmation"] = confirmation;
    appointment[@"recipient"] = otherAttendee;
    
    [appointment saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            NSLog(@"New Appointment saved!");
        } else {
            NSLog(@"Error: %@", error.description);
        }
    }];
    
    PFUser *mentor = (isMentor) ? PFUser.currentUser : otherAttendee;
    PFUser *mentee = (isMentor) ? otherAttendee : PFUser.currentUser;
    //query for past appointments -- if there are none of this mentor and mentee then make new appointnent
    //if there are past appointments with these people then incremenet by 1
    
    PFQuery *query = [PFQuery queryWithClassName:@"Milestone"];
    [query whereKey:@"mentor" equalTo:mentor];
    [query whereKey:@"mentee" equalTo:mentee];
    [query findObjectsInBackgroundWithBlock:^(NSArray * milestone, NSError * _Nullable error) {
        if(milestone.count == 0){
            [Milestone postMilestoneWithMentor:mentor withMentee:mentee];
        } else{
            [milestone[0] updateMeetingNumber];
        }
    }];
    
}

+(PFUser *)otherAttendee:(AppointmentModel *)appointment{
    if(PFUser.currentUser.username == appointment.mentor.username){
        return appointment.mentee;
    } else{
        return appointment.mentor;
    }
}

@end
