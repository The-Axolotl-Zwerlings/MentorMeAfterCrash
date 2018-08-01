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

@interface AppointmentsViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong ) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *appointmentController;
@property (strong, nonatomic) NSArray *pastAppointments;
@property (strong, nonatomic) NSArray *upComingAppointments;

@end



@implementation AppointmentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Appointments";
    self.tabBarController.navigationItem.title = @"Appointments";
    
    self.appointmentsTableView.delegate = self;
    self.appointmentsTableView.dataSource = self;
    
    [self fetchFilteredAppointments];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    
    
    
    [self.refreshControl addTarget:self action:@selector(fetchFilteredAppointments) forControlEvents:UIControlEventValueChanged];
    [self.appointmentsTableView insertSubview:self.refreshControl atIndex:0];
    [self.appointmentsTableView reloadData];
    
}

- (void) viewWillAppear:(BOOL)animated {
    
    self.tabBarController.navigationItem.title = @"Appointments";
    
    [super viewWillAppear:animated];
    [self fetchFilteredAppointments];
    [self.appointmentsTableView reloadData];

    
}
- (IBAction)didChangeIndex:(id)sender {
    
    [self fetchFilteredAppointments];
    
}

-(void)updateAppointments{
    
    
    //Query for appointments that the current user is engaged in
    PFQuery *queryMentor = [PFQuery queryWithClassName:@"AppointmentModel"];
    PFQuery *queryMentee = [PFQuery queryWithClassName:@"AppointmentModel"];
    
    [queryMentor whereKey:@"mentor" equalTo:PFUser.currentUser];
    [queryMentee whereKey:@"mentee" equalTo:PFUser.currentUser];
    
    PFQuery *combinedQuery = [PFQuery orQueryWithSubqueries:[NSArray arrayWithObjects:queryMentor,queryMentee, nil]];
    
    [combinedQuery includeKey:@"mentor.name"];
    [combinedQuery includeKey:@"mentee.name"];
    
    //Used for adding elements to the pastAppointments Array and Upcoming Appointments array
    NSMutableArray *oldPast = [[NSMutableArray alloc]init];
    NSMutableArray *oldUpcoming = [[NSMutableArray alloc]init];
    
    
    [combinedQuery findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            NSDate *currentDate = [NSDate date];
            for(AppointmentModel *appointment in posts){
                
                //if appointment is in the future, edit it accordingly
                if([appointment.meetingDate compare:currentDate] != -1){
                    appointment.isUpcoming = [NSNumber numberWithBool:YES];
                    
                    [appointment saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                        
                        self.upComingAppointments = [NSArray arrayWithArray:oldUpcoming];
                    }];
                    
                    //else make it not upcoming
                } else{
                    appointment.isUpcoming = [NSNumber numberWithBool:NO];
                    
                    [appointment saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                        [oldPast addObject:appointment];
                        self.pastAppointments = [NSArray arrayWithArray:oldPast];
                    }];
                    
                }
            }
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

-(void) fetchFilteredAppointments{
    
    //gets the appointments and updates their status of upcoming or not
    [self updateAppointments];

    //0 is upcoming , 1 is past
    NSInteger index = self.appointmentController.selectedSegmentIndex;
                                                         
    
    
    
    if ( index == 0 ){
        NSLog( @"Fetching Upcoming Appointments...");

        self.appointmentsArray = self.upComingAppointments;
        [self.appointmentsTableView reloadData];
        [self.refreshControl endRefreshing];
    } else {
        NSLog( @"Fetching Past Appointments...");

        self.appointmentsArray = self.pastAppointments;
        [self.appointmentsTableView reloadData];
        [self.refreshControl endRefreshing];
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


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
