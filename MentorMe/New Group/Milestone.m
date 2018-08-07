//
//  Milestone.m
//  MentorMe
//
//  Created by Taylor Murray on 8/5/18.
//  Copyright © 2018 Taylor Murray. All rights reserved.
//

#import "Milestone.h"

@implementation Milestone
@dynamic arrayOfArrayOfTasks;
@dynamic mentee;
@dynamic mentor;
@dynamic meetingNumber;

+ (nonnull NSString *)parseClassName{
    return @"Milestone";
}
+(void)postMilestoneWithMentor:(PFUser *)mentor withMentee:(PFUser *)mentee{
    
    PFObject *milestone = [PFObject objectWithClassName:@"Milestone"];
    milestone[@"mentee"] = mentee;
    milestone[@"mentor"] = mentor;
    milestone[@"arrayOfArrayOfTasks"] = [[NSArray alloc]init];
    milestone[@"meetingNumber"] = [NSNumber numberWithInteger:1];
    
    [milestone saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if(succeeded){
            NSLog(@"We posted the Milestone👓");
        }
    }];
}
-(void)updateMeetingNumber{
    self[@"meetingNumber"] = [NSNumber numberWithDouble:[self.meetingNumber doubleValue] + 1];
    
    [self saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if(succeeded){
            NSLog(@"We updated the Milestone 💎");
        }
    }];
}
@end
