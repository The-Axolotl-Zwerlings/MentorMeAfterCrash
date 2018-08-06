//
//  Milestone.h
//  MentorMe
//
//  Created by Taylor Murray on 8/5/18.
//  Copyright © 2018 Taylor Murray. All rights reserved.
//

#import "PFObject.h"

@interface Milestone : PFObject <PFSubclassing>
@property (strong, nonatomic) PFUser *mentor;
@property (strong, nonatomic) PFUser *mentee;
@property (strong, nonatomic) NSNumber *meetingNumber;
@property (strong, nonatomic) NSArray *arrayOfArrayOfTasks; //1st element is an array of tasks from 1st meeting, 2nd is array of tasks from 2nd meeting, etc.

+(void)postMilestoneWithMentor:(PFUser *)mentor withMentee:(PFUser *)mentee;
-(void)updateMeetingNumber;
@end
