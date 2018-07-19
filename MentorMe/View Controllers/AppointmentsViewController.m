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

@end

@implementation AppointmentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.appointmentsTableView.delegate = self;
    self.appointmentsTableView.dataSource = self;
    
    [self fetchAppointments];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    
    [self.refreshControl addTarget:self action:@selector(fetchAppointments) forControlEvents:UIControlEventValueChanged];
    
    [self.appointmentsTableView insertSubview:self.refreshControl atIndex:0];
    
    [self.appointmentsTableView reloadData];
    
}

- (void) viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.appointmentsTableView reloadData];
    
}

- (void) fetchAppointments {
    
    NSLog( @"Fetching Appointments...");
    [self.refreshControl endRefreshing];
    
    PFQuery *query = [PFQuery queryWithClassName:@"AppointmentModel"];
    
    [query includeKeys:@[@"mentorUsername"]];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        
        if (posts != nil) {
            self.appointmentsArray = (NSMutableArray *)posts;
            [self.appointmentsTableView reloadData];
            
            [self.refreshControl endRefreshing];
            NSLog(@"WE GOT THE APPOINTMENTS 😇");
            
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
    
    
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
    
    NSLog( @"Loading new cell" );
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ( [segue.identifier isEqualToString:@"segueToAppointmentsDetailsViewController"]){
        
        UITableViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.appointmentsTableView indexPathForCell:tappedCell];
        AppointmentModel *incomingAppointment = self.appointmentsArray[indexPath.row];
        AppointmentDetailsViewController * appointmentDetailsViewController = [segue destinationViewController];
        appointmentDetailsViewController.appointment = incomingAppointment;
        appointmentDetailsViewController.delegate = self;

    }
}

@end
