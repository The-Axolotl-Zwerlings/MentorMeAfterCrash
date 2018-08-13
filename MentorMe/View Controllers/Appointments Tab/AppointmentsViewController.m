//
//  AppointmentsViewController.m
//  MentorMe
//
//  Created by Nico Salinas on 7/18/18.
//  Copyright © 2018 Taylor Murray. All rights reserved.
//

#import "AppointmentsViewController.h"
#import "AppointmentDetailsViewController.h"
#import "AppointmentCell.h"
#import "AppointmentModel.h"
#import "Parse/Parse.h"
#import "ParseUI.h"
#import "PFUser+ExtendedUser.h"
#import "MBProgressHUD.h"
@interface AppointmentsViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong ) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;


@property (strong, nonatomic) NSArray *pastAppointments;
@property (strong, nonatomic) IBOutlet UILabel *noAppointmentsLabel;
@property (strong, nonatomic) NSArray *upComingAppointments;

@property (nonatomic, assign) NSInteger give;
@end



@implementation AppointmentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.give = 0;
    
    self.appointmentsTableView.delegate = self;
    self.appointmentsTableView.dataSource = self;
    
    [self fetchFilteredAppointments];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchFilteredAppointments) forControlEvents:UIControlEventValueChanged];
    [self.appointmentsTableView insertSubview:self.refreshControl atIndex:0];

    UIFont *font = [UIFont systemFontOfSize:15.0f];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font
                                                           forKey:NSFontAttributeName];
    [self.segmentedControl setTitleTextAttributes:attributes
                                forState:UIControlStateNormal];
    
    
    self.tabBarController.navigationItem.title = @"Appointments";
    self.tabBarController.navigationItem.rightBarButtonItem = nil;
    self.tabBarController.navigationItem.leftBarButtonItem = nil;
    [self.appointmentsTableView reloadData];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.navigationItem.title = @"Appointments";
    self.tabBarController.navigationItem.rightBarButtonItem = nil;
    self.tabBarController.navigationItem.leftBarButtonItem = nil;
    
    [self.appointmentsTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)didChangeIndex:(id)sender {
    
    [self fetchFilteredAppointments];
    [self.appointmentsTableView reloadData];
    
}

-(void)runQuery{
    
    //Query for appointments that the current user is engaged in
    PFQuery *queryMentor = [PFQuery queryWithClassName:@"AppointmentModel"];
    PFQuery *queryMentee = [PFQuery queryWithClassName:@"AppointmentModel"];
    PFQuery *queryMe = [PFQuery queryWithClassName:@"AppointmentModel"];
    [queryMentor whereKey:@"mentor" equalTo:PFUser.currentUser];
    [queryMentee whereKey:@"mentee" equalTo:PFUser.currentUser];
    [queryMe whereKey:@"recipient" equalTo:PFUser.currentUser];
    [queryMe whereKey:@"confirmation" equalTo:@"NO"];
    PFQuery *combinedQuery = [PFQuery orQueryWithSubqueries:[NSArray arrayWithObjects:queryMentor,queryMentee,nil]];
    [combinedQuery includeKey:@"mentor.name"];
    [combinedQuery includeKey:@"mentee.name"];
    [combinedQuery whereKey:@"recipient" doesNotMatchKey:@"recipient" inQuery:queryMe];
    //Used for adding elements to the pastAppointments Array and Upcoming Appointments array
    NSMutableArray *oldPast = [[NSMutableArray alloc]init];
    NSMutableArray *oldUpcoming = [[NSMutableArray alloc]init];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [combinedQuery findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            NSDate *currentDate = [NSDate date];
            for(AppointmentModel *appointment in posts){
                //if appointment is in the future, edit it accordingly
                if([appointment.meetingDate compare:currentDate] != -1){
                    appointment.isUpcoming = [NSNumber numberWithBool:YES];
                    [oldUpcoming addObject:appointment];
                    self.upComingAppointments = [NSArray arrayWithArray:oldUpcoming];
                    [appointment saveInBackground];
                    //else make it not upcoming
                } else{
                    appointment.isUpcoming = [NSNumber numberWithBool:NO];
                    [oldPast addObject:appointment];
                    self.pastAppointments = [NSArray arrayWithArray:oldPast];
                    [appointment saveInBackground];
                }
            }
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            NSInteger *index = self.segmentedControl.selectedSegmentIndex;
            if ( index == 0 ){
                NSLog( @"Fetching Upcoming Appointments...");
                self.appointmentsArray = self.upComingAppointments;
                if( self.upComingAppointments.count == 0){
                    self.noAppointmentsLabel.text = @"No Upcoming appointments";
                    self.noAppointmentsView.hidden = false;
                    [self.view bringSubviewToFront:self.noAppointmentsView];
                } else {
                    self.noAppointmentsView.hidden = true;
                    [self.view sendSubviewToBack:self.noAppointmentsView];
                    [self.appointmentsTableView reloadData];
                    [self.refreshControl endRefreshing];
                }
            } else {
                NSLog( @"Fetching Past Appointments...");
                self.appointmentsArray = self.pastAppointments;
                if( self.pastAppointments.count == 0){
                    self.noAppointmentsView.hidden = false;
                    self.noAppointmentsLabel.text = @"No Past appointments";
                    [self.view bringSubviewToFront:self.noAppointmentsView];
                    
                } else {
                    self.noAppointmentsView.hidden = true;
                    [self.view sendSubviewToBack:self.noAppointmentsView];
                    ;
                }
                [self.appointmentsTableView reloadData];
                [self.refreshControl endRefreshing];
            }
            
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}


-(void) fetchFilteredAppointments{
    [self runQuery];
    
}


/***** TABLE VIEW METHODS ****/



- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.appointmentsArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AppointmentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AppointmentCell"];
    AppointmentModel *newAppointment = self.appointmentsArray[indexPath.row];
    cell.appointment = newAppointment;
    return cell;
}


#pragma segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ( [segue.identifier isEqualToString:@"segueToAppointmentsDetailsViewController"]){
        
        UITableViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.appointmentsTableView indexPathForCell:tappedCell];
        AppointmentModel *incomingAppointment = self.appointmentsArray[indexPath.row];
        
        AppointmentDetailsViewController * appointmentDetailsViewController = [segue destinationViewController];
        appointmentDetailsViewController.appointment = incomingAppointment;
        appointmentDetailsViewController.appointmentWith = [AppointmentModel otherAttendee:incomingAppointment];
        
        //appointmentDetailsViewController.delegate = self;
        
    }
}

@end
