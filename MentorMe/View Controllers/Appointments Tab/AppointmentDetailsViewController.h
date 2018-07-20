//
//  AppointmentDetailsViewController.h
//  MentorMe
//
//  Created by Nico Salinas on 7/19/18.
//  Copyright © 2018 Taylor Murray. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppointmentModel.h"


@protocol AppointmentDetailsViewControllerDelegate;

@interface AppointmentDetailsViewController : UIViewController

@property (strong, nonatomic) AppointmentModel *appointment;
@property (weak, nonatomic) id<AppointmentDetailsViewControllerDelegate> delegate;

@end
