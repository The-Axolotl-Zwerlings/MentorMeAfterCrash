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
@dynamic isMentor;
@dynamic meetingLocation;
@dynamic meetingDate;
@dynamic meetingType;

@dynamic isUpcoming;


+(nonnull NSString *)parseClassName{
    return @"AppointmentModel";
}


+ (void) postAppointment:(BOOL)isMentor withPerson:( PFUser * _Nullable )otherAttendee withMeetingLocation: (NSString * _Nullable )meetingLocation withMeetingType: (NSString *_Nullable ) meetingType withMeetingDate: (NSDate * _Nullable )meetingDate withIsComing: (BOOL) isUpcoming withMessage:(NSString *)message withCompletion: (void(^_Nullable)(BOOL succeeded, NSError * _Nullable error, AppointmentModel * _Nullable newAppointment))completion {
    
    PFObject *appointment = [PFObject objectWithClassName:@"AppointmentModel"];
    
    appointment[@"mentor"] = (isMentor) ? PFUser.currentUser : otherAttendee;
    appointment[@"mentee"] = (isMentor) ? otherAttendee : PFUser.currentUser;
    appointment[@"isMentor"] = @(isMentor);
    
    appointment[@"meetingLocation"] = meetingLocation;
    appointment[@"meetingType"] = meetingType;
    appointment[@"meetingDate"] = meetingDate;
    appointment[@"isUpcoming"] = @(isUpcoming);
    
    [appointment saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            NSLog(@"New Appointment saved!");
        } else {
            NSLog(@"Error: %@", error.description);
        }
    }];
}
 

@end
