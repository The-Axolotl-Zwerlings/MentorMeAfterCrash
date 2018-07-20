//
//  CreateAppointmentViewController.m
//  MentorMe
//
//  Created by Taylor Murray on 7/19/18.
//  Copyright © 2018 Taylor Murray. All rights reserved.
//

#import "CreateAppointmentViewController.h"
#import "ParseUI.h"
#import "Parse.h"
@interface CreateAppointmentViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *mentorIconView;
@property (strong, nonatomic) IBOutlet PFImageView *mentorProfilePicView;
@property (strong, nonatomic) IBOutlet UITextView *messageTextView;
@property (strong, nonatomic) IBOutlet UIImageView *menteeIconView;
@property (strong, nonatomic) IBOutlet UISegmentedControl *appointmentTypeSegControl;
@property (strong, nonatomic) IBOutlet PFImageView *menteeProfilePicView;
@property (strong, nonatomic) IBOutlet UILabel *meetingWithLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *locationLabel;
@property (strong, nonatomic) NSString *meetingType;
@property (strong, nonatomic) NSDictionary *meetingTypeDic;
@end

@implementation CreateAppointmentViewController


- (IBAction)createAction:(UIButton *)sender {
    
    
    [AppointmentModel postAppointment:self.isMentorOfMeeting withPerson:self.otherAttendee withMeetingLocation:self.locationLabel.text withMeetingType:self.meetingTypeDic[@(self.appointmentTypeSegControl.selectedSegmentIndex)] withMeetingDate:[NSDate date] withIsComing:YES withMessage:self.messageTextView.text withCompletion:nil];
}
- (IBAction)cancelAction:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.meetingWithLabel.text = [@"Meeting With " stringByAppendingString:self.otherAttendee.name];
    
    self.meetingTypeDic = @{ @(0) : @"coffee", @(1) : @"lunch", @(2) : @"VC"};
    
    
    if(self.appointmentTypeSegControl.selectedSegmentIndex == 0){ //coffww
        self.timeLabel.text = [@"At " stringByAppendingString:@"2:00 pm on 6/1/18"];
        self.locationLabel.text = [@"At " stringByAppendingString:@"Red Rock Café"];
    } else if(self.appointmentTypeSegControl.selectedSegmentIndex == 1){ //lunch
        self.timeLabel.text = [@"At" stringByAppendingString:@"12:00 pm on 6/2/18"];
        self.locationLabel.text = [@"At " stringByAppendingString:@"Jimmy Johns"];
    } else{
        self.timeLabel.text = [@"At" stringByAppendingString:@"9:00pm on 6/3/18"];
        self.locationLabel.text = [@"On " stringByAppendingString:@"Skype"];
    }
}
- (IBAction)didChangeType:(UISegmentedControl *)sender {
    if(self.appointmentTypeSegControl.selectedSegmentIndex == 0){ //coffww
        self.timeLabel.text = [@"At " stringByAppendingString:@"2:00 pm on 6/1/18"];
        self.locationLabel.text = [@"At " stringByAppendingString:@"Red Rock Café"];
    } else if(self.appointmentTypeSegControl.selectedSegmentIndex == 1){ //lunch
        self.timeLabel.text = [@"At" stringByAppendingString:@"12:00 pm on 6/2/18"];
        self.locationLabel.text = [@"At " stringByAppendingString:@"Jimmy Johns"];
    } else{
        self.timeLabel.text = [@"At" stringByAppendingString:@"9:00pm on 6/3/18"];
        self.locationLabel.text = [@"On " stringByAppendingString:@"Skype"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
