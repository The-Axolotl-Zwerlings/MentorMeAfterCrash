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
#import "MBProgressHUD.h"
#import "InterestModel.h"
@interface DiscoverTableViewController () <UITableViewDelegate,UITableViewDataSource,FilterDelegate>
@property (strong, nonatomic) IBOutlet UISegmentedControl *mentorMenteeSegControl;
@property (strong, nonatomic) IBOutlet UIButton *filterButton;
@property (strong, nonatomic) UIRefreshControl *refreshControl;

@property (nonatomic) BOOL getAdvice;
@end

@implementation DiscoverTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Discover";
    self.tabBarController.navigationItem.title = @"Discover";
    self.tabBarController.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor colorWithRed:0.22 green:0.54 blue:0.41 alpha:1.0]};
    self.filtersToSearchGetWith = [[NSMutableArray alloc] init];
    self.filtersToSearchGiveWith = [[NSMutableArray alloc] init];
    
    self.discoverTableView.delegate = self;
    self.discoverTableView.dataSource = self;
    [self loadBarButtons];
    [self fetchAllUsers];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchAllUsers) forControlEvents:UIControlEventValueChanged];
    [self.discoverTableView insertSubview:self.refreshControl atIndex:0];
    [self.discoverTableView reloadData];
    
    
}


- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.navigationItem.title = @"Discover";
    
    [self loadBarButtons];
    
    [self.discoverTableView reloadData];
}

- (void) loadBarButtons {
    
    self.tabBarController.navigationItem.leftBarButtonItem = nil;
    UIImage *tabImage = [UIImage imageNamed:@"equalizer-1"];
    self.tabBarController.navigationItem.rightBarButtonItem =  [[UIBarButtonItem alloc] initWithImage:tabImage style:UIBarButtonItemStylePlain target:self action:@selector(segueToFilters)];
    self.tabBarController.navigationItem.rightBarButtonItem.tintColor = [UIColor colorWithRed:0.22 green:0.54 blue:0.41 alpha:1.0];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)fetchAllUsers{

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    PFQuery *usersQuery = [PFUser query];
    NSArray *stringsToQueryAllUsers = [[NSArray alloc] initWithObjects:@"profilePic", @"giveAdviceInterests", @"getAdviceInterests", nil];
    [usersQuery includeKeys:stringsToQueryAllUsers];
    //[usersQuery whereKey:@"username" notEqualTo:PFUser.currentUser.username];
    usersQuery.limit = 20;
    [usersQuery orderByDescending:@"createdAt"];
    [usersQuery findObjectsInBackgroundWithBlock:^(NSArray *users, NSError * error) {
        if(users){
            self.allUsersFromQuery = users;
            [self.discoverTableView reloadData];
            [self.refreshControl endRefreshing];

            NSLog(@"WE GOT THE USERS 😇");
            [MBProgressHUD hideHUDForView:self.view animated:YES];

        } else{
            //NSLog(@"didn't get the users 🙃");
        }
    }];

    

}
//- (IBAction)tappedCell:(UITapGestureRecognizer *)sender {
//    [self performSegueWithIdentifier:@"segueToMentorDetailsViewController" sender:sender];
//}

- (void) fetchUsersWithSelectedInterests: (NSMutableArray*)incomingSelectedInterestsArray {
    
    if( incomingSelectedInterestsArray.count != 0){
        NSSet *myUserInterestsSet = [NSSet setWithArray:incomingSelectedInterestsArray];
        self.filteredUsersFromQuery = nil;
        for(PFUser *user in self.allUsersFromQuery){
            NSSet *otherUserInterests = (self.mentorMenteeSegControl.selectedSegmentIndex == 0) ? [NSSet setWithArray:[InterestModel giveMeSubjects:user.giveAdviceInterests]] : [NSSet setWithArray:[InterestModel giveMeSubjects:user.getAdviceInterests]] ;
            BOOL intersectionOfInterests = [myUserInterestsSet intersectsSet:otherUserInterests];
            if( intersectionOfInterests == YES){
                if( self.filteredUsersFromQuery == nil ){
                    self.filteredUsersFromQuery = [[NSMutableArray alloc] initWithObjects:user, nil];
                    NSLog( @"Created a new array" );
                } else {
                    [self.filteredUsersFromQuery addObject:user];
                }
            }
        }
        NSLog( @"Returning the number of users: %lu", self.filteredUsersFromQuery.count );
    }else{
        [self fetchAllUsers];
    }
    [self.discoverTableView reloadData];
}


-(void)fetchUsersNearbyCurrentUser:(NSArray *)users{
    NSString *destination = [NSString stringWithFormat:@"%@,%@", PFUser.currentUser.cityLocation,PFUser.currentUser.stateLocation];
    NSMutableArray *oldArray = [[NSMutableArray alloc] init];
    dispatch_queue_t locationQueue = dispatch_queue_create("location Queue",NULL);
    
    for(PFUser *user in users){
        
        dispatch_async(locationQueue, ^{
            NSString *origin = [NSString stringWithFormat:@"%@,%@", user.cityLocation,user.stateLocation];
            LocationApiManager *manager = [LocationApiManager new];
            [manager fetchDistanceWithOrigin:origin andEnd:destination andCompletion:^(NSDictionary *elementDic, NSError *error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSNumber *distance = (NSNumber *)elementDic[@"value"];
                    if([distance floatValue] < 50){
                        [oldArray addObject:user];
                        NSLog(@"Added a new user %@", user.name);
                        NSLog(@"%lu",oldArray.count);
                    }
                    self.filteredUsersFromQuery = (NSMutableArray *)[NSArray arrayWithArray:oldArray];
                    NSLog(@"%lu", (unsigned long)self.filteredUsersFromQuery.count);
                    [self.discoverTableView reloadData];
                });
                //                NSNumber *distance = (NSNumber *)elementDic[@"value"];
                //                if([distance floatValue] < 50){
                //                    [oldArray addObject:user];
                //                    NSLog(@"Added a new user %@", user.name);
                //                    NSLog(@"%lu",oldArray.count);
                //                }
            }];
            //NSLog(@"%lu",oldArray.count);
        });
        
        
    
    }
//    self.filteredUsers = [NSArray arrayWithArray:oldArray];
//    NSLog(@"%lu", (unsigned long)self.filteredUsers.count);
//    [self.discoverTableView reloadData]
}


- (IBAction)onEdit:(UISegmentedControl *)sender {
    [self fetchAllUsers];
}


/***** TABLE VIEW ******/
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
   //1. Check what index we are on
    
    if( self.filtersToSearchGetWith.count != 0 || self.filtersToSearchGiveWith.count != 0 ) { // this means there are filters selected
        return self.filteredUsersFromQuery.count;
    } else {
        return self.allUsersFromQuery.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DiscoverCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DiscoverCell" forIndexPath:indexPath];
    
    if( self.filtersToSearchGetWith.count != 0 ){
        cell.userForCell = self.filteredUsersFromQuery[indexPath.item];
    } else {
        cell.userForCell = self.allUsersFromQuery[indexPath.item];
    }
    
    cell.isGivingAdvice = self.mentorMenteeSegControl.selectedSegmentIndex == 1 ? @(1) : @(0);
    if( [cell.isGivingAdvice integerValue] == 1 ){
        cell.profilePicView.layer.borderWidth = 5;
        cell.profilePicView.layer.borderColor = CGColorRetain(UIColor.yellowColor.CGColor);
        cell.profilePicView.layer.cornerRadius = cell.profilePicView.frame.size.width / 2;
        cell.profilePicView.layer.masksToBounds = true;
        cell.getCollectionView.hidden = false;
        cell.giveCollectionView.hidden = true;
        cell.statusLineLabel.text = [[@"What " stringByAppendingString:cell.userForCell.name] stringByAppendingString:@" can get advice about:"];
    } else {
        cell.profilePicView.layer.borderWidth = 5;
        cell.profilePicView.layer.borderColor = CGColorRetain(UIColor.cyanColor.CGColor);
        cell.profilePicView.layer.cornerRadius = cell.profilePicView.frame.size.width / 2;
        cell.profilePicView.layer.masksToBounds = true;
        cell.getCollectionView.hidden = true;
        cell.giveCollectionView.hidden = false;
        cell.statusLineLabel.text = [[@"What " stringByAppendingString:cell.userForCell.name] stringByAppendingString:@" can give advice about:"];
    }
    
    
    
    cell.getInterests = cell.userForCell.getAdviceInterests;
    cell.giveInterests = cell.userForCell.giveAdviceInterests;
    
    cell.getCollectionView.delegate = cell;
    cell.getCollectionView.dataSource = cell;
    cell.giveCollectionView.delegate = cell;
    cell.giveCollectionView.dataSource = cell;
    
    [cell.getCollectionView setShowsHorizontalScrollIndicator:NO];
    [cell.giveCollectionView setShowsHorizontalScrollIndicator:NO];
    cell.getCollectionView.alwaysBounceHorizontal = YES;
    cell.giveCollectionView.alwaysBounceHorizontal = YES;
    //cell.backgroundColor = [UIColor colorWithRed:0.14 green:0.20 blue:0.28 alpha:1.0];
    [cell layoutCell:cell.userForCell];
    [cell reloadInputViews];
    return cell;
}


- (void) segueToFilters {
    [self performSegueWithIdentifier:@"filterSegue" sender:self];
}


/*** DELEGATE METHODS  ***/


- (void) didChangeFilters:(NSMutableArray *) incomingGetInterests withGiveInterests:(NSMutableArray *) incomingGiveInterests withGetIndex:(NSMutableArray *)incomingGetIndices withGiveIndex:(NSMutableArray *)incomingGiveIndices{

    self.getIndex = incomingGetIndices;
    self.giveIndex = incomingGiveIndices;
    
    
    if( incomingGetInterests.count != nil){
        self.filtersToSearchGetWith = nil;
        self.filtersToSearchGetWith = incomingGetInterests;
        [self fetchUsersWithSelectedInterests:self.filtersToSearchGetWith];
    }
    if ( incomingGiveInterests.count != nil ){
        
        self.filtersToSearchGiveWith = nil;
        self.filtersToSearchGiveWith = incomingGiveInterests;
        [self fetchUsersWithSelectedInterests:self.filtersToSearchGiveWith];
    }
    [self.discoverTableView reloadData];
    
}


/*** SEGUE METHODS ***/

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"filterSegue"]){
        UINavigationController *navControl = [segue destinationViewController];
        FilterViewController *filterViewController = (FilterViewController *)navControl.topViewController;
        filterViewController.delegate = self;
        filterViewController.getAdvice = self.getAdvice;
        
        filterViewController.selectedIndexGive = self.giveIndex;
        filterViewController.selectedIndexGet = self.getIndex;
        
        filterViewController.selectedGetFilters = self.filtersToSearchGetWith;
        filterViewController.selectedGiveFilters = self.filtersToSearchGiveWith;
        
        
        
    } else if ( [segue.identifier isEqualToString:@"segueToMentorDetailsViewController"]    )  {
        
        UITableViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.discoverTableView indexPathForCell:tappedCell];
        PFUser *incomingMentor = self.allUsersFromQuery[indexPath.row];
        
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
