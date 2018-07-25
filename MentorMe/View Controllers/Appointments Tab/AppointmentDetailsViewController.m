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
    NSString *titleString;
    if(self.appointment.mentor.username == PFUser.currentUser.username){
        titleString = [@"Meeting with " stringByAppendingString:self.appointment.mentee.name];
    } else{
        titleString = [@"Meeting with " stringByAppendingString:self.appointment.mentor.name];
    }
    if(![self.appointment.isUpcoming boolValue]){
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Write a Review" style:UIBarButtonItemStylePlain target:self action:@selector(random)];
    } else{
        self.navigationItem.rightBarButtonItem.title = @"Edit details";
    }
    
    self.title = titleString;
    self.locationLabel.text = self.appointment.meetingLocation;
    
    //Date
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM d, h:mm a"];
    self.timeLabel.text = [formatter stringFromDate:self.appointment.meetingDate];
    
    
    NSString *completeMeetingType = [@"Meeting for " stringByAppendingString:self.appointment.meetingType];
    self.typeMeetingLabel.text = completeMeetingType;
    self.messageTextLabel.text = self.appointment.message;
    self.messageLabel.text = @"Message:";
    //self.mentorProfileView.file = self.appointment.mentor.profilePic;
    //[self.mentorProfileView loadInBackground];
    
    //self.menteeProfileView.file = PFUser.currentUser.profilePic;
    //[self.menteeProfileView loadInBackground];
    
}
-(void)random{
    [self performSegueWithIdentifier:@"ReviewSegue" sender:self];
}

 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }


@end
