//
//  AppDelegate.m
//  MentorMe
//
//  Created by Taylor Murray on 7/8/18.
//  Copyright © 2018 Taylor Murray. All rights reserved.
//

#import "AppDelegate.h"
#import "Parse/Parse.h"
#import "AppointmentCell.h"
#import "AppointmentModel.h"
#import "AppointmentDetailsViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    ParseClientConfiguration *config = [ParseClientConfiguration   configurationWithBlock:^(id<ParseMutableClientConfiguration> configuration) {
        
        configuration.applicationId = @"bvtcnkhicidunnghcdevbchvjleuljlk";
        configuration.clientKey = @"bfjjninbknllljvgvlicruhfnunthnhg";
        configuration.server = @"http://mentorme18.herokuapp.com/parse";
    }];
    
    [Parse initializeWithConfiguration:config];
    

     /*
     PFObject *appointment = [PFObject objectWithClassName:@"AppointmentModel"];
     PFUser *newUser = [PFUser currentUser];
    
    
     newUser.name = @"Nihal Jemal";
     newUser.jobTitle = @"Software Engineering Intern";
     newUser.school = @"Spelman College";
     appointment[@"mentorName"] = newUser.name;
     appointment[@"mentor"] = newUser;
     appointment[@"mentee"] = [PFUser currentUser];
     appointment[@"meetingLocation"] = @"Menlo Park Building 13";
     appointment[@"meetingType"] = @"VideoChat in 13.1Z2";
    
    
    
     
     [appointment saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
     if (succeeded) {
     NSLog(@"New Appointment saved!");
     } else {
     NSLog(@"Error: %@", error.description);
     }
     }];
      
      */
     

    

    if (PFUser.currentUser) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"TabBarViewControllerStoryboard" bundle:nil];
        NSLog(@"already logged on");
        self.window.rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"TabBarNavigationController"];
    }
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
