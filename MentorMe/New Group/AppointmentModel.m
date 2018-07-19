//
//  AppointmentModel.m
//  MentorMe
//
//  Created by Taylor Murray on 7/18/18.
//  Copyright © 2018 Taylor Murray. All rights reserved.
//

#import "AppointmentModel.h"

@implementation AppointmentModel


@dynamic mentorName;
@dynamic mentor;
@dynamic mentee;

@dynamic meetingLocation;
@dynamic meetingDate;
@dynamic meetingType;


+(nonnull NSString *)parseClassName{
    return @"AppointmentModel";
}


+ (void) postAppointment: ( PFUser * _Nullable )mentor withMeetingLocation: (NSString * _Nullable )meetingLocation withMeetingType: (NSString *_Nullable ) meetingType withMeetingDate: (NSDate * _Nullable )meetingDate withCompletion: (void(^_Nullable)(BOOL succeeded, NSError * _Nullable error, AppointmentModel * _Nullable newAppointment))completion {
    
    PFObject *appointment = [PFObject objectWithClassName:@"AppointmentModel"];
    PFUser *newUser = [PFUser currentUser];
    newUser.name = @"Mentor A";
    newUser.jobTitle = @"Instructor A";
    newUser.school = @"School A";
    
    
    appointment[@"mentorName"] = @"nsalinas";
    appointment[@"mentor"] = newUser;
    appointment[@"mentee"] = [PFUser currentUser];
    appointment[@"meetingLocation"] = @"Menlo Park Building 1";
    appointment[@"meetingType"] = @"Lunch A";
    
    [appointment saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            NSLog(@"New Appointment saved!");
        } else {
            NSLog(@"Error: %@", error.description);
        }
    }];
}
 

@end
