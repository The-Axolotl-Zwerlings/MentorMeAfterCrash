//
//  DiscoverTableViewController.m
//  MentorMe
//
//  Created by Nico Salinas on 7/12/18.
//  Copyright © 2018 Taylor Murray. All rights reserved.
//

#import "DiscoverTableViewController.h"
#import "DiscoverCell.h"
#import "FilterViewController.h"
#import "Parse.h"
#import "PFUser+ExtendedUser.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "MentorDetailsViewController.h"
#import "LocationApiManager.h"
@interface DiscoverTableViewController () <UITableViewDelegate,UITableViewDataSource,FilterDelegate>
@property (strong, nonatomic) IBOutlet UISegmentedControl *mentorMenteeSegControl;
@property (strong, nonatomic) IBOutlet UIButton *filterButton;
@property (strong, nonatomic) NSArray *filteredUsers;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) NSArray *filterArray;
@property (nonatomic) BOOL getAdvice;
@end

@implementation DiscoverTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Discover";
    
    NSNumber* noObj = [NSNumber numberWithBool:NO];
    self.filterArray = [[NSArray alloc] initWithObjects:noObj,noObj,noObj,nil];
    
    self.discoverTableView.delegate = self;
    self.discoverTableView.dataSource = self;
    // Do any additional setup after loading the view.
    
    [self fetchFilteredUsersGet];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchFilteredUsersGet) forControlEvents:UIControlEventValueChanged];
    [self.discoverTableView insertSubview:self.refreshControl atIndex:0];
    [self.discoverTableView reloadData];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)fetchFilteredUsersGet{
    PFQuery *usersQuery = [PFUser query];
    [usersQuery includeKey:@"giveAdviceInterests"];
    //[usersQuery whereKey:@"name" notEqualTo:PFUser.currentUser.name];
    usersQuery.limit = 20;
    [usersQuery orderByDescending:@"createdAt"];
    if([self.filterArray[0] boolValue]){
        [usersQuery whereKey:@"school" equalTo:PFUser.currentUser.school];
    }
    if([self.filterArray[1] boolValue]){
        [usersQuery whereKey:@"company" equalTo:PFUser.currentUser.company];
     }
    
    
    
    
    //[usersQuery orderByDescending:@"createdAt"];
    
    [usersQuery findObjectsInBackgroundWithBlock:^(NSArray *users, NSError * error) {
        
        if(users){
            
            //if they want to filter to nearby users
            if([self.filterArray[2] boolValue]){
                [self closeByUsers:users];
            } else{ //if they don't want to filter location
                self.filteredUsers = users;
            }
            
            [self.discoverTableView reloadData];
            [self.refreshControl endRefreshing];
            NSLog(@"WE GOT THE USERS 😇");
        } else{
            NSLog(@"didn't get the users 🙃");
        }
        
    }];
    
}

-(void)closeByUsers:(NSArray *)users{
    NSString *destination = [NSString stringWithFormat:@"%@,%@", PFUser.currentUser.cityLocation,PFUser.currentUser.stateLocation];
    for(PFUser *user in users){
        NSString *origin = [NSString stringWithFormat:@"%@,%@", user.cityLocation,user.stateLocation];
            LocationApiManager *manager = [LocationApiManager new];
            [manager fetchDistanceWithOrigin:origin andEnd:destination andCompletion:^(NSDictionary *elementDic, NSError *error) {
                NSNumber *distance = (NSNumber *)elementDic[@"distance"][@"value"];
                if([distance floatValue] < 50){
                    NSMutableArray *oldArray = [NSMutableArray arrayWithArray:self.filteredUsers];
                    [oldArray addObject:user];
                    self.filteredUsers = [NSArray arrayWithArray:oldArray];
                }
            }];
    }
}

-(void)fetchFilteredUsersGive{
    PFQuery *usersQuery = [PFUser query];
    [usersQuery includeKey:@"getAdviceInterests"];
    //[usersQuery whereKey:@"user" notEqualTo:PFUser.currentUser];
    usersQuery.limit = 20;
    [usersQuery orderByDescending:@"createdAt"];
    [usersQuery findObjectsInBackgroundWithBlock:^(NSArray *users, NSError * error) {
        
        if(users){
            
            self.filteredUsers = users;
            [self.discoverTableView reloadData];
            [self.refreshControl endRefreshing];
            NSLog(@"WE GOT THE USERS 😇");
        } else{
            NSLog(@"didn't get the users 🙃");
        }
        
    }];
    
}


- (IBAction)onEdit:(UISegmentedControl *)sender {
    
    //if we are going to give advice
    if(self.mentorMenteeSegControl.selectedSegmentIndex == 1){
        NSLog( @"Showing people who can give advice" );
        self.getAdvice = NO;
        [self fetchFilteredUsersGive];
        
    } else{
        NSLog( @"Showing people need advice" );
        self.getAdvice = YES;
        [self fetchFilteredUsersGet];
    }
    
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.filteredUsers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DiscoverCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DiscoverCell" forIndexPath:indexPath];
    cell.isGivingAdvice = self.mentorMenteeSegControl.selectedSegmentIndex == 1 ? @(1) : @(0);
    
    
    [cell layoutCell:self.filteredUsers[indexPath.row]];
    
    
    return cell;
}

- (IBAction)logoutButtonAction:(UIButton *)sender {
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        if(error == nil){
//            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//            LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"MainViewController"];
//            
            [self dismissViewControllerAnimated:YES completion:nil];
            
            
            NSLog(@"hey we did it");
        } else{
            NSLog(@"error in logging out");
        }
    }];
}

- (IBAction)logoutAction:(UIBarButtonItem *)sender {
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        if(error == nil){
            
            [self dismissViewControllerAnimated:YES completion:nil];
            NSLog(@"hey we did it");
        } else{
            NSLog(@"error in logging out");
        }
    }];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"filterSegue"]){
        UINavigationController *navControl = [segue destinationViewController];
        FilterViewController *filterViewController = (FilterViewController *)navControl.topViewController;
        filterViewController.delegate = self;
        filterViewController.filterPreferences = self.filterArray;
        filterViewController.getAdvice = self.getAdvice;
    } else if ( [segue.identifier isEqualToString:@"segueToMentorDetailsViewController"]    )  {
        
        
        UITableViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.discoverTableView indexPathForCell:tappedCell];
        PFUser *incomingMentor = self.filteredUsers[indexPath.row];
        MentorDetailsViewController *mentorDetailsViewController = [segue destinationViewController];
        mentorDetailsViewController.mentor = incomingMentor;
        if(self.mentorMenteeSegControl.selectedSegmentIndex == 0){
            mentorDetailsViewController.isMentorOfMeeting = NO;
        } else{
            mentorDetailsViewController.isMentorOfMeeting = YES;
        }
        
    }
}


@end
