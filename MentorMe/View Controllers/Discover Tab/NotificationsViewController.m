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
@property (weak, nonatomic) IBOutlet UITableView *notificationsTableView;
@property (strong, nonatomic) IBOutlet InviteDetailsView *inviteDetails;

@property (strong, nonatomic) NSArray* appointmentsArray;
@property (nonatomic, strong) NSArray* notificationsArray;

@property (nonatomic, strong)  UIVisualEffectView* blurEffectView;

@end

@implementation NotificationsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.notificationsTableView.delegate = self;
    self.notificationsTableView.dataSource = self;
    
    [self fetchNotifications];
    [self fetchAppointments];
}

- (void) fetchAppointments{
    PFQuery* query1 = [PFQuery queryWithClassName:@"AppointmentModel"];
    [query1 whereKey:@"recipient" equalTo:PFUser.currentUser];
    [query1 whereKey:@"confirmation" equalTo:@"NO"];
    [query1 includeKeys:[[NSArray alloc] initWithObjects:@"mentee.name", @"mentee.major", @"mentee.company", @"mentee.school", @"mentor.name", @"mentor.major", @"mentor.company", @"mentor.school", @"mentor.profilePic", @"mentee.profilePic", nil ]];
    [query1 orderByDescending:@"_created_at"];
    [query1 findObjectsInBackgroundWithBlock:^(NSArray *appointments, NSError * _Nullable error) {
        if (!error) {
            self.appointmentsArray = [NSArray arrayWithArray:appointments];
            
            [self.inviteDetails removeFromSuperview];
            [self.blurEffectView removeFromSuperview];
        }
        else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

-(void)fetchNotifications{

    PFQuery* query = [PFQuery queryWithClassName:@"Notifications"];
    [query whereKey:@"reciever" equalTo:[PFUser currentUser]];
    [query includeKey:@"sender.name"];
    [query orderByDescending:@"_created_at"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError * _Nullable error) {
        if (!error) {
            if (objects.count != 0){
                NSLog(@"Successfully retrieved %lu scores.", objects.count);
                NSMutableArray* temporary = [[NSMutableArray alloc]init];
                for (Notifications *ping in objects) {
                    [temporary addObject:ping];
                }
                self.notificationsArray = [[NSArray alloc]initWithArray:temporary];
                [self.notificationsTableView reloadData];
            } else {
                NSLog(@"No appointments rn");
            }
        }
        else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

- (IBAction)atTapBackButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


/** TABLE VIEW METHODS **/

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.notificationsArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NotificationsTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"NotificationCell" forIndexPath:indexPath];
   
    Notifications* notificationForCell = self.notificationsArray[indexPath.row];
    
    
    PFUser *myUser = [PFUser currentUser];
    
    cell.senderString =  ([notificationForCell.sender.objectId isEqualToString: myUser.objectId] ) ? [PFUser currentUser][@"name"] : notificationForCell.sender.name;
    cell.receiverString = ([notificationForCell.reciever.objectId isEqualToString: myUser.objectId] ) ? [PFUser currentUser][@"name"] : notificationForCell.reciever.name;
    cell.typeOfNotification = notificationForCell.type;
    cell.notificationID = notificationForCell.objectId;
    

    
    
    if( [cell.typeOfNotification isEqualToString:@"invite"]){
        [cell.acceptButton setHidden:NO];
        [cell.declineButton setHidden:NO];
    } else {
        [cell.acceptButton setHidden: YES];
        [cell.declineButton setHidden: YES];
    }
    
    [cell loadCell];
    return  cell;
    
    
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSLog(@"%ld", indexPath.row);
//
//    if (!UIAccessibilityIsReduceTransparencyEnabled()) {
//        self.view.backgroundColor = [UIColor clearColor];
//
//        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
//        self.blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
//        //always fill the view
//        self.blurEffectView.frame = self.view.bounds;
//        self.blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//
//        [self.view addSubview:self.blurEffectView]; //if you have more UIViews, use an insertSubview API to place it where needed
//    } else {
//        self.view.backgroundColor = [UIColor whiteColor];
//    }
//
//    [UIView transitionWithView:self.view duration:0.5 options:UIViewAnimationOptionCurveEaseOut animations:^ {
//        [self.view addSubview:self.inviteDetails];
//        float width = 0.8*self.view.frame.size.width;
//        float height = width;
//        [self.inviteDetails setFrame:CGRectMake((self.view.frame.size.width / 2.)- (width/2.), (self.view.frame.size.height / 2.)- (height/2.), width, height)];
//    }
//                    completion:nil];
//    self.view.backgroundColor = UIColor.lightGrayColor;
//    self.inviteDetails.layer.cornerRadius = 5;
//    self.inviteDetails.layer.masksToBounds = true;
//    NSInteger x = indexPath.row;
//    NSInteger y = self.tracker - 1;
//    NSInteger z = [[self.subtractors objectAtIndex:y]intValue];
//    NSInteger n = x - z;
//    self.specialNumber = n;
//    self.itsIndex = x;
//    AppointmentModel * try = self.invites[n];
//    NSLog(@"%ld", n);
//    self.other =  ([try.mentor.name isEqualToString:PFUser.currentUser.name]) ? try.mentee : try.mentor;
//    self.identity = try.objectId;
//    self.index = indexPath;
//
//    self.current = self.invites[n];
//
//    self.inviteDetails.nameLabel.text = self.other.name;
//    self.inviteDetails.companyLabel.text = self.other.company;
//    self.inviteDetails.majorLabel.text = self.other.major;
//    self.inviteDetails.institutionLabel.text = self.other.school;
//    self.inviteDetails.positionLabel.text = self.other.jobTitle;
//    self.inviteDetails.picture.file = self.other.profilePic;
//
//    NSDateFormatter* df = [[NSDateFormatter alloc]init];
//    [df setDateFormat:@"MM/dd/yyyy"];
//    NSString *result = [df stringFromDate:try.meetingDate];
//    self.inviteDetails.dateLabel.text = result;
//    self.inviteDetails.messageLabel.text = try.message;
//}

- (IBAction)atTapAccept:(id)sender {
//    PFQuery *query = [PFQuery queryWithClassName:@"AppointmentModel"];
//    [query getObjectInBackgroundWithId:self.identity block:^(PFObject *appointment, NSError *error) {
//        appointment[@"confirmation"] = @"YES";
//        [appointment saveInBackground];
//    }];
    
//    AppointmentModel * try = self.invites[self.specialNumber];
//    self.other =  ([try.mentor.name isEqualToString:PFUser.currentUser.name]) ? try.mentee : try.mentor;
//    [Notifications addNotification:@"accepted" withSender:[PFUser currentUser] withReciever:self.other];
//    Notifications* toDelete = self.notificationsArray[self.itsIndex];
//    PFQuery *query2 = [PFQuery queryWithClassName:@"Notifications"];
//    [query2 getObjectInBackgroundWithId:toDelete.objectId
//                                  block:^(PFObject *not, NSError *error) {
//                                      if (!error){
//                                          [not deleteInBackground];
//                                          NSLog(@"deleted notification");
//                                          [self fetchNotifications];
//                                          //[self.inviteDetails removeFromSuperview];
//                                      }
//                                      else{NSLog(@"Error is deleting notification");}
//                                  }];
    
    
}
//-(void)deleteNotification{
//    Notifications* toDelete = self.notificationsArray[self.specialNumber];
//    PFQuery *query2 = [PFQuery queryWithClassName:@"Notifications"];
//    [query2 getObjectInBackgroundWithId:toDelete.objectId
//                                  block:^(PFObject *not, NSError *error) {
//                                      NSLog(@"deleted notification");
//                                      [not deleteInBackground];
//                                      [self fetchNotifications];
//                                      //[self.inviteDetails removeFromSuperview];
//                                  }];
//}
//- (IBAction)atTapDecline:(id)sender {
//    PFQuery *query = [PFQuery queryWithClassName:@"AppointmentModel"];
//    [query getObjectInBackgroundWithId:self.identity block:^(PFObject *appointment, NSError *error) {
//                                     if (!error){
//                                         [appointment deleteInBackground];
//                                         NSLog(@"deleted appointment");
//                                         [self deleteNotification];}
//                                     else{NSLog(@"Error is deleting appointment");}
//                                 }];
//    AppointmentModel * try = self.invites[self.specialNumber];
//    self.other =  ([try.mentor.name isEqualToString:PFUser.currentUser.name]) ? try.mentee : try.mentor;
//    [Notifications addNotification:@"declined" withSender:[PFUser currentUser] withReciever:self.other];
//
//
//}


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
