//
//  AppointmentsViewController.h
//  MentorMe
//
//  Created by Nico Salinas on 7/18/18.
//  Copyright © 2018 Taylor Murray. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Parse/Parse.h"

@protocol AppointmentsViewControllerDelegate;

@interface AppointmentsViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITableView *appointmentsTableView;
@property (strong, nonatomic) NSMutableArray *appointmentsArray;


@property (weak, nonatomic) id<AppointmentsViewControllerDelegate> delegate;


@end
