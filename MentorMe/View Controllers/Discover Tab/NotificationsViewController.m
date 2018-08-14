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
@property (strong, nonatomic) NSArray* invites;
@property (strong, nonatomic) IBOutlet InviteDetailsView *inviteDetails;
@property (nonatomic, strong) NSString* identity;
@property (nonatomic, strong) NSIndexPath* index;
@property (nonatomic, strong) AppointmentModel* current;
@property (nonatomic, strong) NSArray* notificationTypes;
@property (nonatomic, assign) NSInteger subtractor;
@property (nonatomic, strong) NSMutableArray* subtractors;
@property (nonatomic, assign) NSInteger tracker;
@property (nonatomic, assign) NSInteger itsIndex;
@property (nonatomic, strong) Notifications* notificationsArray;
@property (nonatomic, assign) NSInteger specialNumber;
@property (nonatomic, strong) PFUser* other;
@property (nonatomic, strong)  UIVisualEffectView* blurEffectView;

@end

@implementation NotificationsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.notificationsTable.delegate = self;
    self.notificationsTable.dataSource = self;
    [self notificationsQuery];
    
    
}

- (void) querryInvites{
    PFQuery* query1 = [PFQuery queryWithClassName:@"AppointmentModel"];
    [query1 whereKey:@"recipient" equalTo:PFUser.currentUser];
    [query1 whereKey:@"confirmation" equalTo:@"NO"];
    [query1 includeKey:@"mentee.name"];
    [query1 includeKey:@"mentee.major"];
    [query1 includeKey:@"mentee.company"];
    [query1 includeKey:@"mentee.school"];
    [query1 includeKey:@"mentor.name"];
    [query1 includeKey:@"mentor.major"];
    [query1 includeKey:@"mentor.company"];
    [query1 includeKey:@"mentor.school"];
    [query1 includeKey:@"mentee.profilePic"];
    [query1 includeKey:@"mentor.profilePic"];
    [query1 orderByDescending:@"_created_at"];
    [query1 findObjectsInBackgroundWithBlock:^(NSArray *appointments, NSError * _Nullable error) {
        if (!error) {
            self.invites = [NSArray arrayWithArray:appointments];
            [self.notificationsTable reloadData];
            [self.inviteDetails removeFromSuperview];
            [self.blurEffectView removeFromSuperview];
            }
        else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

-(void)notificationsQuery{
    self.subtractors = [[NSMutableArray alloc]init];
    self.tracker = 0;
    self.subtractor = 0;
    PFQuery* query = [PFQuery queryWithClassName:@"Notifications"];
    [query whereKey:@"reciever" equalTo:[PFUser currentUser]];
    [query includeKey:@"sender.name"];
    [query orderByDescending:@"_created_at"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError * _Nullable error) {
        if (!error) {
            //if (objects.count != 0){
                [self querryInvites];
            NSLog(@"Successfully retrieved %lu scores.", objects.count);
            NSMutableArray* temporary = [[NSMutableArray alloc]init];
            for (Notifications *ping in objects) {
                [temporary addObject:ping];
            }
            self.notificationTypes = [[NSArray alloc]initWithArray:temporary];
            //}
        }
        else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

- (IBAction)atTapBackButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.notificationTypes.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    self.notificationsArray = [self.notificationTypes objectAtIndex:indexPath.row];
        if([self.notificationsArray.type isEqualToString:@"accepted"]){
            UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"accepted" forIndexPath:indexPath];

           // cell.contentView.layer.cornerRadius = 7;
           // cell.contentView.layer.masksToBounds = true;

            UILabel* label = [[UILabel alloc]init];
            [label setFrame:CGRectMake(8, 0, 400, 50)];
            NSString* suffix = @" has accepted your appointment invite.";
            Notifications* this = self.notificationTypes[indexPath.row];
            PFUser* person = this.sender;
            NSString* message = [person.name stringByAppendingString:suffix];
            label.text = message;
            [cell.contentView addSubview:label];
            ++self.subtractor;
            return  cell;
        }
        else if([self.notificationsArray.type isEqualToString:@"declined"]){
            UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"declined" forIndexPath:indexPath];
            UILabel* label = [[UILabel alloc]init];
            [label setFrame:CGRectMake(8, 0, 400, 50)];
            NSString* suffix = @" has declined your appointment invite.";
            Notifications* this = self.notificationTypes[indexPath.row];
            PFUser* person = this.sender;
            NSString* message = [person.name stringByAppendingString:suffix];
            label.text = message;
            [cell.contentView addSubview:label];
            ++self.subtractor;
            return  cell;
        }
        else if([self.notificationsArray.type isEqualToString:@"invite"]){
            NSNumber* x = [NSNumber numberWithInt:self.subtractor];
            [self.subtractors addObject:x];
            NotificationsTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"invite" forIndexPath:indexPath];
            NSInteger a = indexPath.row;
            NSInteger y = self.tracker;
            self.tracker = self.tracker+1;
            NSInteger z = [[self.subtractors objectAtIndex:y]intValue];
            NSInteger n = a - z;
            AppointmentModel * try = self.invites[n];
            self.other =  ([try.mentor.name isEqualToString:PFUser.currentUser.name]) ? try.mentee : try.mentor;
            cell.inviter.text = [self.other.name stringByAppendingString:@" wants to meet you"];
            NSDateFormatter* df = [[NSDateFormatter alloc]init];
            [df setDateFormat:@"MM/dd/yyyy"];
            NSString *result = [df stringFromDate:try.meetingDate];
            cell.when.text = [@"On: " stringByAppendingString:result];
            cell.where.text = [@"At: " stringByAppendingString:try.meetingLocation];
            return cell;
        }
        else{
            UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"declined" forIndexPath:indexPath];
            return  cell;
        }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%ld", indexPath.row);
    
    if (!UIAccessibilityIsReduceTransparencyEnabled()) {
        self.view.backgroundColor = [UIColor clearColor];
        
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        self.blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        //always fill the view
        self.blurEffectView.frame = self.view.bounds;
        self.blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        [self.view addSubview:self.blurEffectView]; //if you have more UIViews, use an insertSubview API to place it where needed
    } else {
        self.view.backgroundColor = [UIColor whiteColor];
    }
    
    [UIView transitionWithView:self.view duration:0.5 options:UIViewAnimationOptionCurveEaseOut animations:^ {
                         [self.view addSubview:self.inviteDetails];
                         float width = 0.8*self.view.frame.size.width;
                        float height = width;
                         [self.inviteDetails setFrame:CGRectMake((self.view.frame.size.width / 2.)- (width/2.), (self.view.frame.size.height / 2.)- (height/2.), width, height)];
                     }
                     completion:nil];
    self.view.backgroundColor = UIColor.lightGrayColor;
    self.inviteDetails.layer.cornerRadius = 5;
    self.inviteDetails.layer.masksToBounds = true;
    NSInteger x = indexPath.row;
    NSInteger y = self.tracker - 1;
    NSInteger z = [[self.subtractors objectAtIndex:y]intValue];
    NSInteger n = x - z;
    self.specialNumber = n;
    self.itsIndex = x;
    AppointmentModel * try = self.invites[n];
    NSLog(@"%ld", n);
    self.other =  ([try.mentor.name isEqualToString:PFUser.currentUser.name]) ? try.mentee : try.mentor;
    self.identity = try.objectId;
    self.index = indexPath;
    
    self.current = self.invites[n];
    
    self.inviteDetails.nameLabel.text = self.other.name;
    self.inviteDetails.companyLabel.text = self.other.company;
    self.inviteDetails.majorLabel.text = self.other.major;
    self.inviteDetails.institutionLabel.text = self.other.school;
    self.inviteDetails.positionLabel.text = self.other.jobTitle;
    self.inviteDetails.picture.file = self.other.profilePic;
    
    NSDateFormatter* df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"MM/dd/yyyy"];
    NSString *result = [df stringFromDate:try.meetingDate];
    self.inviteDetails.dateLabel.text = result;
    self.inviteDetails.messageLabel.text = try.message;
}

- (IBAction)atTapAccept:(id)sender {
    PFQuery *query = [PFQuery queryWithClassName:@"AppointmentModel"];
    [query getObjectInBackgroundWithId:self.identity
                                 block:^(PFObject *appointment, NSError *error) {
                                     appointment[@"confirmation"] = @"YES";
                                     [appointment saveInBackground];
                                 }];
    AppointmentModel * try = self.invites[self.specialNumber];
    self.other =  ([try.mentor.name isEqualToString:PFUser.currentUser.name]) ? try.mentee : try.mentor;
   [Notifications addNotification:@"accepted" withSender:[PFUser currentUser] withReciever:self.other];
    Notifications* toDelete = self.notificationTypes[self.itsIndex];
    PFQuery *query2 = [PFQuery queryWithClassName:@"Notifications"];
    [query2 getObjectInBackgroundWithId:toDelete.objectId
                                 block:^(PFObject *not, NSError *error) {
                                     if (!error){
                                     [not deleteInBackground];
                                     NSLog(@"deleted notification");
                                     [self notificationsQuery];
                                     //[self.inviteDetails removeFromSuperview];
                                     }
                                    else{NSLog(@"Error is deleting notification");}
                                 }];
    
    
}
-(void)deleteNotification{
    Notifications* toDelete = self.notificationTypes[self.specialNumber];
    PFQuery *query2 = [PFQuery queryWithClassName:@"Notifications"];
    [query2 getObjectInBackgroundWithId:toDelete.objectId
                                  block:^(PFObject *not, NSError *error) {
                                      NSLog(@"deleted notification");
                                      [not deleteInBackground];
                                      [self notificationsQuery];
                                      //[self.inviteDetails removeFromSuperview];
                                  }];
}
- (IBAction)atTapDecline:(id)sender {
    PFQuery *query = [PFQuery queryWithClassName:@"AppointmentModel"];
    [query getObjectInBackgroundWithId:self.identity
                                 block:^(PFObject *appointment, NSError *error) {
                                     if (!error){
                                     [appointment deleteInBackground];
                                     NSLog(@"deleted appointment");
                                    [self deleteNotification];}
                                     else{NSLog(@"Error is deleting appointment");}
                                 }];
    AppointmentModel * try = self.invites[self.specialNumber];
     self.other =  ([try.mentor.name isEqualToString:PFUser.currentUser.name]) ? try.mentee : try.mentor;
     [Notifications addNotification:@"declined" withSender:[PFUser currentUser] withReciever:self.other];

    
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
