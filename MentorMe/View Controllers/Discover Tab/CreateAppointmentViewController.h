//
//  CreateAppointmentViewController.h
//  MentorMe
//
//  Created by Taylor Murray on 7/19/18.
//  Copyright © 2018 Taylor Murray. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFUser+ExtendedUser.h"
#import "Parse.h"
#import "AppointmentModel.h"

@interface CreateAppointmentViewController : UIViewController
@property (nonatomic) BOOL isMentorOfMeeting;
@property (nonatomic, strong) PFUser *otherAttendee;
@end
