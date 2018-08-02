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
@property (weak, nonatomic) IBOutlet UISegmentedControl *appointmentController;
@property (strong, nonatomic) NSArray *pastAppointments;
@property (strong, nonatomic) NSArray *upComingAppointments;
@property UILabel *NoAppointments;
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
    
    CGRect labelFrame = CGRectMake(self.view.frame.size.width/4,self.view.frame.size.height/2,200,44);
    
    self.NoAppointments = [[UILabel alloc] initWithFrame:labelFrame];
    
    self.NoAppointments.backgroundColor = [UIColor clearColor];
    self.NoAppointments.textColor = [UIColor grayColor];
    self.NoAppointments.font = [UIFont fontWithName:@"Verdana" size:18.0];
    
    self.NoAppointments.numberOfLines = 2;
    self.NoAppointments.text = @"No appointments";
    
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
    
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
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
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self displayNoApps];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

-(void)displayNoApps{
    
    
    if(self.appointmentsArray.count == 0){
        [self.view addSubview:self.NoAppointments];
        [self.view bringSubviewToFront:self.NoAppointments];
        
    } else{
        [self.view sendSubviewToBack:self.NoAppointments];
    }
    

}

-(void) fetchFilteredAppointments{
    
    //gets the appointments and updates their status of upcoming or not
    [self updateAppointments];

    //0 is upcoming , 1 is past
    NSInteger index = self.appointmentController.selectedSegmentIndex;
    if ( index == 0 ){
        NSLog( @"Fetching Upcoming Appointments...");
        
        self.appointmentsArray = self.upComingAppointments;
       // if( self.upComingAppointments.count == 0){
        
       // [self checkAppointmentLoader];
        
       // } else {
        self.appointmentsTableView.hidden = false;
       // [self checkAppointmentLoader];
        [self.appointmentsTableView reloadData];
        [self.refreshControl endRefreshing];
       // }
        
        
        
    } else {
        NSLog( @"Fetching Past Appointments...");
        
        self.appointmentsArray = self.pastAppointments;
        //if( self.pastAppointments.count == 0){
        
        //[self checkAppointmentLoader];
        
        //} else {
        NSLog( @"%lu", self.pastAppointments.count );
        //[self checkAppointmentLoader];
        [self.appointmentsTableView reloadData];
        [self.refreshControl endRefreshing];
        //}
        
    }
    
}

- (void) checkAppointmentLoader {
    
    UILabel *noAppointmentsLabel;
    
    if(![self.noAppointmentsScreenView isDescendantOfView:self.view]) {
        
        float startingHeight = self.appointmentsTableView.frame.size.height;
        float actualY = self.appointmentsTableView.frame.origin.y;
        
        self.noAppointmentsScreenView = [[UIView alloc] initWithFrame:CGRectMake(0, actualY, self.view.frame.size.width, startingHeight)];
        [self.appointmentsTableView addSubview:self.noAppointmentsScreenView];
        self.noAppointmentsScreenView.backgroundColor = [UIColor whiteColor];
        
        NSLog( @"AAAA" );
        noAppointmentsLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.noAppointmentsScreenView.frame.size.width*0.25, self.noAppointmentsScreenView.frame.size.height*0.4, self.noAppointmentsScreenView.frame.size.width*0.5, 100)];
        noAppointmentsLabel.textColor = [UIColor blackColor];
        noAppointmentsLabel.font = [UIFont systemFontOfSize:15];
        noAppointmentsLabel.text = @"No Upcoming Appointments Found";
        noAppointmentsLabel.numberOfLines = 0;
        noAppointmentsLabel.lineBreakMode = NSLineBreakByWordWrapping;
        noAppointmentsLabel.textAlignment = NSTextAlignmentCenter;
        
        
        [self.noAppointmentsScreenView addSubview:noAppointmentsLabel];
        self.appointmentsTableView.hidden = true;
        self.noAppointmentsScreenView.hidden = false;
        noAppointmentsLabel.hidden = false;
        
        
    } else {
        
        NSLog( @"BBBB" );
        
        [self.noAppointmentsScreenView removeFromSuperview];
        self.noAppointmentsScreenView.hidden = YES;
        noAppointmentsLabel.hidden = YES;
        
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
