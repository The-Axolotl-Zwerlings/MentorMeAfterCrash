//
//  Notifications.m
//  MentorMe
//
//  Created by Nihal Riyadh Jemal on 8/9/18.
//  Copyright © 2018 Taylor Murray. All rights reserved.
//

#import "Notifications.h"
#import "PFUser+ExtendedUser.h"

@implementation Notifications

@dynamic type;
@dynamic sender;
@dynamic reciever;

+(NSString *)parseClassName{
    return @"Notifications";
}

+(void)addNotification: (NSString*) type withSender:(PFUser*) sender withReciever:(PFUser*) reciever{
    PFObject* newNotification = [PFObject objectWithClassName:@"Notifications"];
    newNotification[@"type"] = type;
    newNotification[@"sender"] = sender;
    newNotification[@"reciever"] = reciever;
    [newNotification saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            NSLog(@"Notification made");
        } else {
            NSLog(@"Error: %@", error.description);
        }
    }];
}

@end
