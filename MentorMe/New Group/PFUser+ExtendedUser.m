//
//  PFUser+ExtendedUser.m
//  MentorMe
//
//  Created by Taylor Murray on 7/18/18.
//  Copyright © 2018 Taylor Murray. All rights reserved.
//

#import "PFUser+ExtendedUser.h"
#import "Parse/Parse.h"


@implementation PFUser (ExtendedUser)

-(void)setProfilePic:(PFFile *)profilePic{
    self[@"profilePic"] = profilePic;
}
-(PFFile *)backgroundPic{
    return self[@"backgroundPic"];
}
-(void)setBackgroundPic:(PFFile *)backgroundPic{
    self[@"backgroundPic"] = backgroundPic;
}
-(PFFile *)profilePic{
    return self[@"profilePic"];
}
-(void)setBio:(NSString *)bio{
    self[@"bio"] = bio;
}
-(NSString *)bio{
    return self[@"bio"];
}

//name
-(void)setName:(NSString *)name{
    self[@"name"] = name;
}
-(NSString *)name{
    return self[@"name"];
}

//school
-(void)setSchool:(NSString *)school{
    self[@"school"] = school;
}
-(NSString *)school{
    return self[@"school"];
}

-(void)setJobTitle:(NSString *)jobTitle{
    self[@"jobTitle"] = jobTitle;
}
-(NSString *)jobTitle{
    return self[@"jobTitle"];
}
-(void)setCompany:(NSString *)company{
    self[@"company"] = company;
}
-(NSString *)major{
    return self[@"major"];
}
-(void)setMajor:(NSString *)major{
    self[@"major"] = major;
}
-(NSArray *)getAdviceInterests{
    return self[@"getAdviceInterests"];
}
-(void)setGetAdviceInterests:(NSArray *)getAdviceInterests{
    self[@"getAdviceInterests"] = getAdviceInterests;
}
-(NSArray *)giveAdviceInterests{
    return self[@"giveAdviceInterests"];
}
-(void)setMeetupNumber:(NSNumber *)meetupNumber{
    self[@"meetupNumber"] = meetupNumber;
}
-(NSNumber *)meetupNumber{
    return self[@"meetupNumber"];
}
-(void)setUsersNearby:(PFRelation *)usersNearby{
    self[@"usersNearby"] = usersNearby;
}
-(PFRelation *)usersNearby{
    return self[@"usersNearby"];
}
@end
