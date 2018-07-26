//
//  AppointmentCell.h
//  MentorMe
//
//  Created by Nico Salinas on 7/18/18.
//  Copyright © 2018 Taylor Murray. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Parse/Parse.h"
#import "ParseUI.h"
#import "AppointmentModel.h"

@interface AppointmentCell : UITableViewCell

@property (strong, nonatomic) AppointmentModel *appointment;
@property (weak, nonatomic) IBOutlet PFImageView *otherAttendeeProfilePic;
@property (weak, nonatomic) IBOutlet UILabel *otherAttendeeName;

@property (weak, nonatomic) IBOutlet UILabel *meetingSummaryLabel;


@property (nonatomic) BOOL isMentor;
//@property (strong, nonatomic) IBOutlet UILabel *mentorOrMenteeLabel;

@end
