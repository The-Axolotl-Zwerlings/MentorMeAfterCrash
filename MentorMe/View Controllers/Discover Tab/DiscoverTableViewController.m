//
//  DiscoverTableViewController.m
//  MentorMe
//
//  Created by Nico Salinas on 7/12/18.
//  Copyright © 2018 Taylor Murray. All rights reserved.
//
#import "AppDelegate.h"
#import "DiscoverTableViewController.h"
#import "DiscoverCell.h"
#import "FilterViewController.h"
#import "HMSegmentedControl.h"
#import "InterestModel.h"
#import "LocationApiManager.h"
#import "LoginViewController.h"
#import "MentorDetailsViewController.h"
#import "MBProgressHUD.h"
#import "Parse.h"
#import "PFUser+ExtendedUser.h"


@interface DiscoverTableViewController () <UITableViewDelegate,UITableViewDataSource,FilterDelegate>{
    UITableView *getTableView;
    UITableView *giveTableView;
}
@property (strong, nonatomic) IBOutlet UIButton *filterButton;
@property (strong, nonatomic) UIRefreshControl *refreshControl;

@property (nonatomic, strong) HMSegmentedControl *segmentedControl;
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic) BOOL getAdvice;
@end

@implementation DiscoverTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tabBarController.navigationItem.title = @"Discover";
    self.filtersToSearchGetWith = [[NSMutableArray alloc] init];
    self.filtersToSearchGiveWith = [[NSMutableArray alloc] init];
    
    [self fetchAllUsers];
    [self initSegmentedControl];
    [self initScrollView];
    [self initTableViews];
    [self loadBarButtons];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchAllUsers) forControlEvents:UIControlEventValueChanged];
    [self.scrollView insertSubview:self.refreshControl atIndex:0];
    
}


- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.tabBarController.navigationItem.title = @"Discover";
    [self loadBarButtons];
    
    [giveTableView reloadData];
    [getTableView reloadData];
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
    
    //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    if( [PFUser currentUser] ){
        
        PFQuery *usersQuery = [PFUser query];
        NSArray *stringsToQueryAllUsers = [[NSArray alloc] initWithObjects:@"profilePic", @"giveAdviceInterests", @"getAdviceInterests", nil];
        [usersQuery includeKeys:stringsToQueryAllUsers];
        [usersQuery whereKey:@"username" notEqualTo:PFUser.currentUser.username];
        usersQuery.limit = 20;
        [usersQuery orderByDescending:@"createdAt"];
        [usersQuery findObjectsInBackgroundWithBlock:^(NSArray *users, NSError * error) {
            if(users){
                self.allUsersFromQuery = users;
                [giveTableView reloadData];
                [getTableView reloadData];
                [self.refreshControl endRefreshing];
                
                NSLog(@"WE GOT THE USERS 😇");
                //[MBProgressHUD hideHUDForView:self.view animated:YES];
                
            } else{
                //NSLog(@"didn't get the users 🙃");
            }
        }];
    }
    [giveTableView reloadData];
    [getTableView reloadData];
}

- (void) fetchUsersWithSelectedInterests: (NSMutableArray*)incomingSelectedInterestsArray {
    if( incomingSelectedInterestsArray.count != 0){
        NSSet *myUserInterestsSet = [NSSet setWithArray:incomingSelectedInterestsArray];
        self.filteredUsersFromQuery = nil;
        for(PFUser *user in self.allUsersFromQuery){
            NSSet *otherUserInterests = (self.segmentedControl.selectedSegmentIndex == 0) ? [NSSet setWithArray:[InterestModel giveMeSubjects:user.giveAdviceInterests]] : [NSSet setWithArray:[InterestModel giveMeSubjects:user.getAdviceInterests]] ;
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
                    [giveTableView reloadData];
                    [getTableView reloadData];
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




- (void) segueToFilters {
    [self performSegueWithIdentifier:@"filterSegue" sender:self];
}


/*** DELEGATE METHODS  ***/
- (void) didChangeFilters:(NSMutableArray *) incomingGetInterests withGiveInterests:(NSMutableArray *) incomingGiveInterests withGetIndex:(NSMutableArray *)incomingGetIndices withGiveIndex:(NSMutableArray *)incomingGiveIndices{
    
    self.getIndex = incomingGetIndices;
    self.giveIndex = incomingGiveIndices;
    
    
    if( incomingGetInterests.count != 0){
        self.filtersToSearchGetWith = nil;
        self.filtersToSearchGetWith = incomingGetInterests;
        [self fetchUsersWithSelectedInterests:self.filtersToSearchGetWith];
    }
    if ( incomingGiveInterests.count != 0 ){
        
        self.filtersToSearchGiveWith = nil;
        self.filtersToSearchGiveWith = incomingGiveInterests;
        [self fetchUsersWithSelectedInterests:self.filtersToSearchGiveWith];
    }
    
    
}




/*** SEGMENTED CONTROL ***/

- (void) initSegmentedControl{
    // Tying up the segmented control to a scroll view
    CGFloat viewWidth = CGRectGetWidth(self.view.frame);
    self.segmentedControl = [[HMSegmentedControl alloc] initWithFrame:CGRectMake(12, 12, viewWidth-24, 40)];
    [self.segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];

    self.segmentedControl.sectionTitles = @[@"Get Advice", @"Give Advice"];
    self.segmentedControl.selectedSegmentIndex = 0;
    self.segmentedControl.backgroundColor = [UIColor clearColor];
    self.segmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : [UIColor blackColor]};
    self.segmentedControl.selectionIndicatorColor = [UIColor grayColor];
    self.segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleArrow;
    self.segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationUp;
    self.segmentedControl.tag = 2;
    
    __weak typeof(self) weakSelf = self;
    [self.segmentedControl setIndexChangeBlock:^(NSInteger index) {
        [weakSelf.scrollView scrollRectToVisible:CGRectMake(viewWidth * index, 0, viewWidth, 200) animated:YES];
    }];
    
    [self.view addSubview:self.segmentedControl];
}

- (void) initScrollView {
    CGFloat viewWidth = CGRectGetWidth(self.view.frame);
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, viewWidth, 500)];
    self.scrollView.backgroundColor = [UIColor clearColor];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.contentSize = CGSizeMake(viewWidth * 2, 500);
    self.scrollView.delegate = self;
    [self.scrollView scrollRectToVisible:CGRectMake(0, 0, viewWidth, self.view.frame.size.height) animated:NO];
    [self.view addSubview:self.scrollView];
    
    UILabel *labelA = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 375, 500)];
    labelA.backgroundColor = UIColor.yellowColor;
    [self.scrollView addSubview:labelA];
    
    UILabel *labelB = [[UILabel alloc] initWithFrame:CGRectMake(375, 0, 375, 500)];
    labelB.backgroundColor = UIColor.blueColor;
    [self.scrollView addSubview:labelB];
}


- (void) initTableViews {
    getTableView= [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 375, 500)];
    [getTableView registerClass:[DiscoverCell class] forCellReuseIdentifier:@"DiscoverCell"];
    getTableView.delegate = self;
    getTableView.dataSource = self;
    [getTableView setRowHeight:200];
    getTableView.showsVerticalScrollIndicator = NO;
    [self.scrollView addSubview:getTableView];
    
    giveTableView = [[UITableView alloc] initWithFrame:CGRectMake(375, 0, 375, 500)];
    [giveTableView registerClass:[DiscoverCell class] forCellReuseIdentifier:@"DiscoverCell"];
    giveTableView.delegate = self;
    giveTableView.dataSource = self;
    [giveTableView setRowHeight:200];
    giveTableView.showsVerticalScrollIndicator = NO;
    [self.scrollView addSubview:giveTableView];
    
}

- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
    NSLog(@"Selected index %ld (via UIControlEventValueChanged)", (long)segmentedControl.selectedSegmentIndex);
    
    if( segmentedControl.selectedSegmentIndex == 0 ){
        [getTableView reloadData];
    } else{
        [giveTableView reloadData];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat pageWidth = scrollView.frame.size.width;
    NSInteger page = scrollView.contentOffset.x / pageWidth;
    
    [self.segmentedControl setSelectedSegmentIndex:page animated:YES];
    NSLog(@"Slided to index %ld", page);
    if( page == 0 ){
        [getTableView reloadData];
    } else{
        [giveTableView reloadData];
    }

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
        
        NSIndexPath *indexPath;
        
        if( self.segmentedControl.selectedSegmentIndex == 0){
            
            indexPath = [giveTableView indexPathForCell:tappedCell];
            
        }else {
            indexPath = [getTableView indexPathForCell:tappedCell];
        }
        
        
        PFUser *incomingMentor = self.allUsersFromQuery[indexPath.row];
        MentorDetailsViewController *mentorDetailsViewController = [segue destinationViewController];
        mentorDetailsViewController.mentor = incomingMentor;
        if(self.segmentedControl.selectedSegmentIndex == 0){
            mentorDetailsViewController.isMentorOfMeeting = NO;
        } else{
            mentorDetailsViewController.isMentorOfMeeting = YES;
        }
    }
}

/***** TABLE VIEW ******/
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if( self.filtersToSearchGetWith.count != 0 || self.filtersToSearchGiveWith.count != 0 ) {
        NSLog( @"Filtered Count %lu", self.filtersToSearchGetWith.count);
        NSLog( @"Filtered Count %lu", self.filtersToSearchGiveWith.count);
        return self.filteredUsersFromQuery.count;
    } else if (self.allUsersFromQuery.count != 0) {
        NSLog( @"All Count %lu", self.allUsersFromQuery.count);
        return self.allUsersFromQuery.count;
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DiscoverCell *cell =  [tableView dequeueReusableCellWithIdentifier:@"DiscoverCell" forIndexPath:indexPath];
    
    cell.selectedIndex = self.segmentedControl.selectedSegmentIndex;
    if( self.filtersToSearchGetWith.count != 0 ){
        cell.userForCell = self.filteredUsersFromQuery[indexPath.item];
    } else {
        cell.userForCell = self.allUsersFromQuery[indexPath.item];
    }
    cell.incomingGetInterests = cell.userForCell.getAdviceInterests;
    cell.incomingGiveInterests = cell.userForCell.giveAdviceInterests;
    
    
    
    if( self.segmentedControl.selectedSegmentIndex == 0 && cell.userForCell != nil ){

        [cell loadCell];
        [cell loadCollectionViews];
        
    } else if( self.segmentedControl.selectedSegmentIndex == 1 && cell.userForCell != nil )  {
        [cell loadCell];
        [cell loadCollectionViews];
        
    }
    
    
    
    return cell;
}



@end
