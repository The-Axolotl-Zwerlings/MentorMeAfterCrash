//
//  AppointmentDetailsViewController.m
//  MentorMe
//
//  Created by Nico Salinas on 7/19/18.
//  Copyright © 2018 Taylor Murray. All rights reserved.
//

#import "AppointmentDetailsViewController.h"
#import "ParseUI.h"
#import "Parse.h"
#import "DateTools.h"

@interface AppointmentDetailsViewController ()
@property (strong, nonatomic) IBOutlet PFImageView *mentorProfileView;
@property (strong, nonatomic) IBOutlet PFImageView *menteeProfileView;

@property (strong, nonatomic) IBOutlet UILabel *messageLabel;
@property (strong, nonatomic) IBOutlet UILabel *messageTextLabel;



//buttons
@property (strong, nonatomic) IBOutlet UIButton *coffeeButton;
@property (strong, nonatomic) IBOutlet UIButton *lunchButton;
@property (strong, nonatomic) IBOutlet UIButton *VCbutton;

//details
@property (strong, nonatomic) IBOutlet UILabel *typeMeetingLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *locationLabel;
@property (strong, nonatomic) PFUser *mentor;
@end


@implementation AppointmentDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self loadAppointment];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadAppointment{
    
    NSString *titleString = [@"Meeting with " stringByAppendingString:self.appointment.mentorName];
    
    self.title = titleString;
    
    self.locationLabel.text = self.appointment.meetingLocation;
    self.timeLabel.text = [self.appointment.meetingDate timeAgoSinceNow];
    NSString *completeMeetingType = [@"Meeting for " stringByAppendingString:self.appointment.meetingType];
    self.typeMeetingLabel.text = completeMeetingType;
    self.messageLabel.text = [self.appointment.meetingType stringByAppendingString:[@" confirmed with " stringByAppendingString:self.appointment.mentorName]];
    //self.mentorProfileView.file = self.appointment.mentor.profilePic;
    //[self.mentorProfileView loadInBackground];
    
    //self.menteeProfileView.file = PFUser.currentUser.profilePic;
    //[self.menteeProfileView loadInBackground];
    
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
