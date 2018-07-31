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



//City
-(void)setCityLocation:(NSString *)cityLocation{
    self[@"cityLocation"] = cityLocation;
}
-(NSString *)cityLocation{
    return self[@"cityLocation"];
}

//State
-(void)setStateLocation:(NSString *)stateLocation{
    self[@"stateLocation"] = stateLocation;
}
-(NSString *)stateLocation{
    return self[@"stateLocation"];
}

//Profile Pic
-(void)setProfilePic:(PFFile *)profilePic{
    self[@"profilePic"] = profilePic;
}

-(PFFile *)profilePic{
    return self[@"profilePic"];
}

//Background Pic
-(PFFile *)backgroundPic{
    return self[@"backgroundPic"];
}
-(void)setBackgroundPic:(PFFile *)backgroundPic{
    self[@"backgroundPic"] = backgroundPic;
}

//Bio
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

//Job
-(void)setJobTitle:(NSString *)jobTitle{
    self[@"jobTitle"] = jobTitle;
}
-(NSString *)jobTitle{
    return self[@"jobTitle"];
}

//company
-(void)setCompany:(NSString *)company{
    self[@"company"] = company;
}
-(NSString*)company{
    return self[@"company"];
}

//major
-(NSString *)major{
    return self[@"major"];
}
-(void)setMajor:(NSString *)major{
    self[@"major"] = major;
}

//getAdvice
-(NSArray *)getAdviceInterests{
    return self[@"getAdviceInterests"];
}
-(void)setGetAdviceInterests:(NSArray *)getAdviceInterests{
    self[@"getAdviceInterests"] = getAdviceInterests;
}
//giveAdvice
-(NSArray *)giveAdviceInterests{
    return self[@"giveAdviceInterests"];
}

-(void)setGiveAdviceInterests:(NSArray *)giveAdviceInterests{
    self[@"giveAdviceInterests"] = giveAdviceInterests;
}
//meetupNumber
-(void)setMeetupNumber:(NSNumber *)meetupNumber{
    self[@"meetupNumber"] = meetupNumber;
}
-(NSNumber *)meetupNumber{
    return self[@"meetupNumber"];
}

//Nearby Users
-(void)setUsersNearby:(PFRelation *)usersNearby{
    self[@"usersNearby"] = usersNearby;
}
-(PFRelation *)usersNearby{
    return self[@"usersNearby"];
}
/*@property (strong, nonatomic) NSNumber *giveAdviceCount;
 @property (strong, nonatomic) NSNumber *getAdviceCount;
 */

@end
