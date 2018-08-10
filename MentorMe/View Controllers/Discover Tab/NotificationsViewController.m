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

@end

@implementation NotificationsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.notificationsTable.delegate = self;
    self.notificationsTable.dataSource = self;
    
    [self notificationsQuery];
  
    self.tracker = 0;
    self.subtractors = [[NSMutableArray alloc]init];
   // [self.subtractors addObject:@0];
    
}

- (void) querryInvites{
    
    PFQuery* query = [PFQuery queryWithClassName:@"AppointmentModel"];
    [query whereKey:@"mentor" equalTo:PFUser.currentUser];
    [query includeKey:@"mentee.name"];
    [query includeKey:@"mentee.major"];
    [query includeKey:@"mentee.company"];
    [query includeKey:@"mentee.school"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *appointments, NSError * _Nullable error) {
        if (!error) {
            self.invites = [NSArray arrayWithArray:appointments];
            [self.notificationsTable reloadData];
            }
        else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

-(void)notificationsQuery{
    PFQuery* query = [PFQuery queryWithClassName:@"Notifications"];
    [query whereKey:@"reciever" equalTo:[PFUser currentUser]];
    [query includeKey:@"sender.name"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError * _Nullable error) {
        if (!error) {
            if (objects.count != 0){
                [self querryInvites];
            NSLog(@"Successfully retrieved %lu scores.", objects.count);
            NSMutableArray* temporary = [[NSMutableArray alloc]init];
            for (Notifications *ping in objects) {
                [temporary addObject:ping];
            }
            
            self.notificationTypes = [[NSArray alloc]initWithArray:temporary];
            }
            //[self.notificationsTable reloadData];
        }
        else {
            // Log details of the failure
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
    //Notifications* typesArray = [self.notificationTypes objectAtIndex:indexPath.row];
    self.notificationsArray = [self.notificationTypes objectAtIndex:indexPath.row];
        //self.notificationTypes[indexPath.row];
        if([self.notificationsArray.type isEqualToString:@"accepted"]){
            UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"accepted" forIndexPath:indexPath];
            UILabel* label = [[UILabel alloc]init];
            [label setFrame:CGRectMake(0, 0, 400, 50)];
            label.backgroundColor = UIColor.greenColor;
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
            [label setFrame:CGRectMake(0, 0, 400, 50)];
            label.backgroundColor = UIColor.redColor;
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
            //here i', finding appointments where i am the reciever
            NotificationsTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"invite" forIndexPath:indexPath];
            //here i make a cell of invite type
            cell.contentView.backgroundColor = UIColor.lightGrayColor;
            // make backround grey
            AppointmentModel * try = self.invites[(indexPath.row)-self.subtractor];
            //i'm pointing to first in array;
            PFUser* user = try.mentee;
            cell.inviter.text = user.name;
            NSDateFormatter* df = [[NSDateFormatter alloc]init];
            [df setDateFormat:@"MM/dd/yyyy"];
            NSString *result = [df stringFromDate:try.meetingDate];
            cell.when.text = result;
            cell.where.text = try.meetingLocation;
            return cell;
        }
        else{
            UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"declined" forIndexPath:indexPath];
            return  cell;
        }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%ld", indexPath.row);
    [UIView transitionWithView:self.view duration:0.5                        options:UIViewAnimationOptionCurveEaseOut//change to whatever animation you like
                     animations:^ {
                         [self.view addSubview:self.inviteDetails];
                         float width = 0.8*self.view.frame.size.width;
                        float height = width;
                         [self.inviteDetails setFrame:CGRectMake((self.view.frame.size.width / 2.)- (width/2.), (self.view.frame.size.height / 2.)- (height/2.), width, height)];
                     }
                     completion:nil];
    self.view.backgroundColor = UIColor.lightGrayColor;
    self.inviteDetails.layer.cornerRadius = 5;
    self.inviteDetails.layer.masksToBounds = true;
    
    
    //i need to make sure the information for the right cell is retrieved
    
    NSInteger x = indexPath.row;
    NSInteger y = self.tracker;
    NSInteger z = [[self.subtractors objectAtIndex:y]intValue];
    NSInteger n = x - z;
    self.itsIndex = x;
    AppointmentModel * try = self.invites[n];
    NSLog(@"%ld", n);
    PFUser* user = try.mentee;
    
    self.identity = try.objectId;
    self.index = indexPath;
    
    self.current = self.invites[n];//
    
    self.inviteDetails.nameLabel.text = user.name;
    self.inviteDetails.companyLabel.text = user.company;
    self.inviteDetails.majorLabel.text = user.major;
    self.inviteDetails.institutionLabel.text = user.school;
    self.inviteDetails.positionLabel.text = user.jobTitle;
    
    NSDateFormatter* df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"MM/dd/yyyy"];
    NSString *result = [df stringFromDate:try.meetingDate];
    self.inviteDetails.dateLabel.text = result;
    self.inviteDetails.messageLabel.text = try.message;
    //add location
}

- (IBAction)atTapAccept:(id)sender {
    PFQuery *query = [PFQuery queryWithClassName:@"AppointmentModel"];
    [query getObjectInBackgroundWithId:self.identity
                                 block:^(PFObject *appointment, NSError *error) {
                                     appointment[@"confirmation"] = @"YES";
                                     [appointment saveInBackground];
                                 }];
   [Notifications addNotification:@"accepted" withSender:[PFUser currentUser] withReciever:self.current.mentee];
//delete row by deleting notification
    
    
    Notifications* toDelete = self.notificationTypes[self.itsIndex];
    //NSLog(@"%@", toDelete.objectId);
    PFQuery *query2 = [PFQuery queryWithClassName:@"Notifications"];
    [query2 getObjectInBackgroundWithId:toDelete.objectId
                                 block:^(PFObject *not, NSError *error) {
                                     NSLog(@"deleted");
                                     [not deleteInBackground];
                                     [self notificationsQuery];
                                 }];
    
    [self.inviteDetails removeFromSuperview];
    
}
-(void)deleteNotification{
    Notifications* toDelete = self.notificationTypes[self.itsIndex];
    //NSLog(@"%@", toDelete.objectId);
    PFQuery *query2 = [PFQuery queryWithClassName:@"Notifications"];
    [query2 getObjectInBackgroundWithId:toDelete.objectId
                                  block:^(PFObject *not, NSError *error) {
                                      NSLog(@"deleted");
                                      [not deleteInBackground];
                                      [self notificationsQuery];
                                  }];
}
- (IBAction)atTapDecline:(id)sender {
    PFQuery *query = [PFQuery queryWithClassName:@"AppointmentModel"];
    [query getObjectInBackgroundWithId:self.identity
                                 block:^(PFObject *appointment, NSError *error) {
                                     [appointment deleteInBackground];
                                     [self deleteNotification];
                                 }];
     [Notifications addNotification:@"declined" withSender:[PFUser currentUser] withReciever:self.current.mentee];
    
    
    
    [self.inviteDetails removeFromSuperview];    
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
