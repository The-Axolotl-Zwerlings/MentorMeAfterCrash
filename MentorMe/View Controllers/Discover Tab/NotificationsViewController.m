//
//  NotificationsViewController.m
//  MentorMe
//
//  Created by Nihal Riyadh Jemal on 8/8/18.
//  Copyright © 2018 Taylor Murray. All rights reserved.
//

#import "NotificationsViewController.h"
#import "Parse/Parse.h"
#import "AppointmentModel.h"
#import "NotificationsTableViewCell.h"
#import "PFUser+ExtendedUser.h"
#import "InviteDetailsView.h"
#import "Notifications.h"


@interface NotificationsViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *notificationsTable;
@property (strong, nonatomic) NSArray* appointmentArray;
@property (strong, nonatomic) IBOutlet InviteDetailsView *inviteDetails;
@property (nonatomic, strong) NSString* appointmentID;
@property (nonatomic, strong) NSIndexPath* index;
@property (nonatomic, strong) AppointmentModel* clickedAppointment;
@property (nonatomic, strong) NSArray* notificationArray;//notificationTypes;
@property (nonatomic, assign) NSInteger subtractor;
@property (nonatomic, strong) NSMutableArray* subtractors;
@property (nonatomic, assign) NSInteger tracker;
@property (nonatomic, assign) NSInteger notificationIndex;
@property (nonatomic, strong) Notifications* notification;
@property (nonatomic, assign) NSInteger specialNumber;
@property (nonatomic, strong) PFUser* other;
@property (nonatomic, strong)  UIVisualEffectView* blurEffectView;
@property (nonatomic, strong) NSMutableDictionary* getRealIndex;
@property (nonatomic, assign) NSNumber* currentAppointmentIndex;

@end

@implementation NotificationsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.notificationsTable.delegate = self;
    self.notificationsTable.dataSource = self;
    [self notificationsQuery];
}

-(void)notificationsQuery{
    self.subtractor = 0;
    self.subtractors = [[NSMutableArray alloc]init];
    self.tracker = 0;
    self.getRealIndex = [[NSMutableDictionary alloc]init];
    PFQuery* query = [PFQuery queryWithClassName:@"Notifications"];
    [query whereKey:@"reciever" equalTo:[PFUser currentUser]];
    [query includeKey:@"sender.name"];
    [query orderByDescending:@"_created_at"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError * _Nullable error) {
        if (!error) {
            NSLog(@"Successfully retrieved %lu notifications", objects.count);
            self.notificationArray = [NSArray arrayWithArray:objects];
            [self appointmentsQuery];
        }
        else {
            NSLog(@"Error");
        }
    }];
}

- (void) appointmentsQuery{
    PFQuery* query = [PFQuery queryWithClassName:@"AppointmentModel"];
    [query whereKey:@"recipient" equalTo:PFUser.currentUser];
    [query whereKey:@"confirmation" equalTo:@"NO"];
    [query includeKey:@"mentee.name"];
    [query includeKey:@"mentee.major"];
    [query includeKey:@"mentee.company"];
    [query includeKey:@"mentee.school"];
    [query includeKey:@"mentor.name"];
    [query includeKey:@"mentor.major"];
    [query includeKey:@"mentor.company"];
    [query includeKey:@"mentor.school"];
    [query includeKey:@"mentee.profilePic"];
    [query includeKey:@"mentor.profilePic"];
    [query orderByDescending:@"_created_at"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *appointments, NSError * _Nullable error) {
        if (!error) {
            self.appointmentArray = [NSArray arrayWithArray:appointments];
            [self.inviteDetails removeFromSuperview];
            [self.blurEffectView removeFromSuperview];
            [self.notificationsTable reloadData];
            }
        else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

- (IBAction)atTapBackButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

//TABLE VIEW//

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.notificationArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    self.notification = [self.notificationArray objectAtIndex:indexPath.row];
        if([self.notification.type isEqualToString:@"accepted"]){
            ++(self.subtractor);
            UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"accepted" forIndexPath:indexPath];
            //setting up cell
            UILabel* label = [[UILabel alloc]init];
            [label setFrame:CGRectMake(8, 0, 400, 50)];
            label.numberOfLines = 0;
            //Notifications* this = self.notificationTypes[indexPath.row];
            PFUser* sender = self.notification.sender;
            NSString* message = [sender.name stringByAppendingString:@" has accepted your appointment invite."];
            label.text = message;
            [cell addSubview:label];
           
            return  cell;
        }
    
        else if([self.notification.type isEqualToString:@"declined"]){
            ++self.subtractor;
            UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"declined" forIndexPath:indexPath];
            UILabel* label = [[UILabel alloc]init];
            label.numberOfLines = 0;
            //setting up cell
            [label setFrame:CGRectMake(8, 0, 400, 50)];
            //Notifications* this = self.notificationTypes[indexPath.row];
            PFUser* sender = self.notification.sender;
            NSString* message = [sender.name stringByAppendingString:@" has declined your appointment invite."];
            label.text = message;
            [cell.contentView addSubview:label];
            return  cell;
        }
        else if([self.notification.type isEqualToString:@"invite"]){
            NSNumber * x = @(self.subtractor);
            [self.subtractors addObject:x];
            NotificationsTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"invite" forIndexPath:indexPath];
            NSInteger t = self.tracker;
            NSInteger z = [[self.subtractors objectAtIndex:t]intValue];
            NSInteger n = indexPath.row - z;
            //self.specialNumber = n;
            [self.getRealIndex setObject: @(n)  forKey: @(indexPath.row)];
            AppointmentModel * appointment = self.appointmentArray[n];
            self.tracker = self.tracker+1;
            
            //setting cell
            self.other =  ([appointment.mentor.name isEqualToString:PFUser.currentUser.name]) ? appointment.mentee : appointment.mentor;
            cell.inviter.text = [self.other.name stringByAppendingString:@" wants to meet you"];
            NSDateFormatter* df = [[NSDateFormatter alloc]init];
            [df setDateFormat:@"MM/dd/yyyy"];
            NSString *result = [df stringFromDate:appointment.meetingDate];
            cell.when.text = [@"On: " stringByAppendingString:result];
            cell.where.text = [@"At: " stringByAppendingString:appointment.meetingLocation];
            
            return cell;
            }
        else{
            UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"declined" forIndexPath:indexPath];
            return  cell;
        }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%ld", indexPath.row);
    
    //blurr effect
    if (!UIAccessibilityIsReduceTransparencyEnabled()) {
        self.view.backgroundColor = [UIColor clearColor];
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        self.blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        self.blurEffectView.frame = self.view.bounds;
        self.blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.view addSubview:self.blurEffectView];
    } else {
        self.view.backgroundColor = [UIColor whiteColor];
    }
    
    //animated view appearance
    [UIView transitionWithView:self.view duration:0.5 options:UIViewAnimationOptionCurveEaseOut animations:^ {
                         [self.view addSubview:self.inviteDetails];
                         float width = 0.8*self.view.frame.size.width;
                         float height = width;
                         [self.inviteDetails setFrame:CGRectMake((self.view.frame.size.width / 2.)- (width/2.), (self.view.frame.size.height / 2.)- (height/2.), width, height)];
    }completion:nil];
    self.inviteDetails.layer.cornerRadius = 5;
    self.inviteDetails.layer.masksToBounds = true;
    
    //setting up fields
    self.currentAppointmentIndex = [self.getRealIndex objectForKey: @(indexPath.row)];
    NSInteger integerValue = [self.currentAppointmentIndex integerValue];
    AppointmentModel * appointment = self.appointmentArray[integerValue];
    NSDateFormatter* df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"MM/dd/yyyy"];
    NSString *result = [df stringFromDate:appointment.meetingDate];
    self.inviteDetails.dateLabel.text = result;
    self.inviteDetails.messageLabel.text = appointment.message;
    self.other =  ([appointment.mentor.name isEqualToString:PFUser.currentUser.name]) ? appointment.mentee : appointment.mentor;
    self.inviteDetails.nameLabel.text = self.other.name;
    self.inviteDetails.companyLabel.text = self.other.company;
    self.inviteDetails.majorLabel.text = self.other.major;
    self.inviteDetails.institutionLabel.text = self.other.school;
    self.inviteDetails.positionLabel.text = self.other.jobTitle;
    self.inviteDetails.picture.file = self.other.profilePic;

    self.notificationIndex = indexPath.row;

}

- (IBAction)atTapAccept:(id)sender {
    //update status
    NSInteger integerValue = [self.currentAppointmentIndex integerValue];
    AppointmentModel * appointment = self.appointmentArray[integerValue];
    PFQuery *query = [PFQuery queryWithClassName:@"AppointmentModel"];
    [query getObjectInBackgroundWithId:appointment.objectId block:^(PFObject *appointment, NSError *error) {
                                     appointment[@"confirmation"] = @"YES";
                                     [appointment saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                                         [self deleteNotification];
                                     }];
      }];
    Notifications* response = self.notificationArray[self.notificationIndex];
    self.other = response.sender;
   [Notifications addNotification:@"accepted" withSender:[PFUser currentUser] withReciever:self.other];
}
- (IBAction)atTapDecline:(id)sender {
    NSInteger integerValue = [self.currentAppointmentIndex integerValue];
    AppointmentModel * appointment = self.appointmentArray[integerValue];
    PFQuery *query = [PFQuery queryWithClassName:@"AppointmentModel"];
    [query getObjectInBackgroundWithId:appointment.objectId
                                 block:^(PFObject *appointment, NSError *error) {
                                     if (!error){
                                         [appointment deleteInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                                             NSLog(@"deleted appointment");
                                             [self deleteNotification];
                                         }];
                                     }
                                     else{NSLog(@"Error is deleting appointment");}
                                 }];
    
    Notifications* response = self.notificationArray[self.notificationIndex];
    self.other = response.sender;
    [Notifications addNotification:@"declined" withSender:[PFUser currentUser] withReciever:self.other];
}
-(void)deleteNotification{
    Notifications* toDelete = self.notificationArray[self.notificationIndex];
    PFQuery *query2 = [PFQuery queryWithClassName:@"Notifications"];
    [query2 getObjectInBackgroundWithId:toDelete.objectId
                                  block:^(PFObject *not, NSError *error) {
                                      if (!error){
                                          [not deleteInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                                              NSLog(@"deleted notification");
                                              [self notificationsQuery];
                                          }];
                                      }
                                      else{NSLog(@"Error is deleting notification");}
                                  }];
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
