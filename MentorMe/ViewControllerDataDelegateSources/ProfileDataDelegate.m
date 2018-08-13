//
//  ProfileDataDelegate.m
//  MentorMe
//
//  Created by Taylor Murray on 8/7/18.
//  Copyright © 2018 Taylor Murray. All rights reserved.
//

#import "ProfileDataDelegate.h"
#import "Parse.h"
#import "PFUser+ExtendedUser.h"
#import "AppointmentModel.h"
#import "MentorMilestoneCell.h"
@implementation ProfileDataDelegate
-(id)init:(UICollectionView *)mentorsCollectionView andSource:(id)source{
    self = [super init];
    if(self){
        self.mentorsCollectionView = mentorsCollectionView;
        [self queryforMentors];
        self.source = source;
    }
    return self;
}

-(void)queryforMentors{
    PFQuery *queryForMentors = [PFQuery queryWithClassName:@"AppointmentModel"];
    [queryForMentors includeKey:@"mentee"];
    [queryForMentors whereKey:@"mentee" equalTo:PFUser.currentUser];
    [queryForMentors includeKeys:[NSArray arrayWithObjects:@"mentor.profilePic",@"mentor.name", nil]];
    [queryForMentors findObjectsInBackgroundWithBlock:^(NSArray * appointments, NSError * _Nullable error) {
        if(appointments){
            NSMutableArray *mentorsMutable = [[NSMutableArray alloc]init];
            NSArray *mentorNames = [NSArray arrayWithArray:mentorsMutable];
            NSMutableArray *mentorNamesMutable = [NSMutableArray arrayWithArray:mentorsMutable];
            for(AppointmentModel *appointment in appointments){
                if([mentorNames containsObject:appointment.mentor.name]){
                    NSLog(@"SKIP");
                } else{
                    [mentorsMutable addObject:appointment.mentor];
                    [mentorNamesMutable addObject:appointment.mentor.name];
                    mentorNames = [NSArray arrayWithArray:mentorNamesMutable];
                }
                
            }
            self.mentors = [NSArray arrayWithArray:mentorsMutable];
            [self.mentorsCollectionView reloadData];
        }
        else{
            NSLog(@"We ran into a problem getting mentors...");
        }
    }];
}



- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    MentorMilestoneCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MentorMilestoneCell" forIndexPath:indexPath];
    [cell formatWithMentor:(self.mentors[indexPath.item])];
    cell.delegate = self.source;
    return cell;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.mentors.count;
}

@end
