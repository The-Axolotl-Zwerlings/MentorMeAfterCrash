//
//  AppointmentModel.h
//  MentorMe
//
//  Created by Taylor Murray on 7/18/18.
//  Copyright © 2018 Taylor Murray. All rights reserved.
//

#import "PFObject.h"
#import "PFUser+ExtendedUser.h"
#import "Parse/Parse.h"
#import "ParseUI.h"

@interface AppointmentModel : PFObject <PFSubclassing>

@property (nonatomic, strong ) PFUser *mentor;
@property (nonatomic, strong ) PFUser *mentee;
@property (nonatomic, strong ) NSString *mentorName;
@property( nonatomic, strong ) NSDate *meetingDate;
@property( nonatomic, strong ) NSString *meetingType;
@property( nonatomic, strong ) NSString *meetingLocation;

+ (void) postAppointment: ( PFUser * _Nullable )mentor withMeetingLocation: (NSString * _Nullable )meetingLocation withMeetingType: (NSString *_Nullable ) meetingType withMeetingDate: (NSDate * _Nullable )meetingDate withCompletion: (void(^_Nullable)(BOOL succeeded, NSError * _Nullable error, AppointmentModel * _Nullable newAppointment))completion;




@end
