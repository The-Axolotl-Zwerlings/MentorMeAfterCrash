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
@property (nonatomic, strong) NSNumber *isMentor;
@property( nonatomic, strong ) NSDate *meetingDate;
@property( nonatomic, strong ) NSString *meetingType;
@property( nonatomic, strong ) NSString *meetingLocation;
@property (nonatomic, strong) NSNumber *isUpcoming;
@property (nonatomic, strong) NSString *message;


+ (void) postAppointment:(BOOL)isMentor withPerson:( PFUser * _Nullable )otherAttendee withMeetingLocation: (NSString * _Nullable )meetingLocation withMeetingType: (NSString *_Nullable ) meetingType withMeetingDate: (NSDate * _Nullable )meetingDate withIsComing: (BOOL) isUpcoming withMessage:(NSString *)message withCompletion: (void(^_Nullable)(BOOL succeeded, NSError * _Nullable error, AppointmentModel * _Nullable newAppointment))completion;




@end
