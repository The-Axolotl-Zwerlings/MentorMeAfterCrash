//
//  Notifications.h
//  MentorMe
//
//  Created by Nihal Riyadh Jemal on 8/9/18.
//  Copyright © 2018 Taylor Murray. All rights reserved.
//

#import "PFObject.h"
#import "Parse/Parse.h"
#import "ParseUI.h"

@interface Notifications : PFObject<PFSubclassing>

@property (nonatomic, strong) NSString* type;
@property (nonatomic, strong) PFUser* sender;
@property (nonatomic, strong) PFUser* reciever;

+(void)addNotification: (NSString*) type withSender:(PFUser*) sender withReciever:(PFUser*) reciever;
//+(NSArray*)fetchMyNotificationsby:(PFUser*) me andfrom: (PFUser*) others;
@end
