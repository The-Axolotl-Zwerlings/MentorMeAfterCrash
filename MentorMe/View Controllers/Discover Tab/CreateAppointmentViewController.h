//
//  CreateAppointmentViewController.h
//  MentorMe
//
//  Created by Taylor Murray on 7/19/18.
//  Copyright © 2018 Taylor Murray. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFUser+ExtendedUser.h"
#import "Parse/Parse.h"
#import "AppointmentModel.h"

@protocol AppointmentNotification <NSObject>
-(void) requestInformations:(NSString*) maker atDate:(NSDate*) date atLocation:(NSString*) location;
@end
@interface CreateAppointmentViewController : UIViewController
{
    UIDatePicker *datePicker;
}
@property (nonatomic) BOOL isMentorOfMeeting;
@property (nonatomic, strong) PFUser *otherAttendee;
@property (nonatomic, weak) id<AppointmentNotification> AppontmentNotificationDelegegate;
@end
