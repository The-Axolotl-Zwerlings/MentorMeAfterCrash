//
//  MentorDetailsViewController.m
//  MentorMe
//
//  Created by Nico Salinas on 7/19/18.
//  Copyright © 2018 Taylor Murray. All rights reserved.
//

#import "MentorDetailsViewController.h"
#import "PFUser+ExtendedUser.h"
#import "DiscoverTableViewController.h"
#import "Parse/Parse.h"
#import "ParseUI.h"
#import "CreateAppointmentViewController.h"
#import "InterestModel.h"
#import "Review.h"
#import "GetAdviceCollectionViewCell.h"
#import "GiveAdviceCollectionViewCell.h"
//#import "ComplimentCell.h"

@interface MentorDetailsViewController () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (strong, nonatomic) IBOutlet UICollectionView *complimentsCollectionView;
@property (strong, nonatomic) NSArray *complimentsArray;
@property (weak, nonatomic) IBOutlet PFImageView *bannerImage;
@property (weak, nonatomic) IBOutlet PFImageView *profileImage;
@property (strong, nonatomic) IBOutlet UILabel *rating;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *occupationLabel;
@property (weak, nonatomic) IBOutlet UILabel *educationLabel;
@property (weak, nonatomic) IBOutlet UITextView *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@property (strong, nonatomic) NSArray* adviceToGet;
@property (strong, nonatomic) NSArray* adviceToGive;

@property (strong, nonatomic) IBOutlet UICollectionView *getAdviceCollectionView;
@property (strong, nonatomic) IBOutlet UICollectionView *giveAdviceCollectionView;

@end

@implementation MentorDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadMentor];
    
    self.title = self.mentor.name;
    
    self.getAdviceCollectionView.delegate = self;
    self.getAdviceCollectionView.dataSource = self;
    self.giveAdviceCollectionView.delegate = self;
    self.giveAdviceCollectionView.dataSource = self;
    
    
}

-(void)getRating{
    __block NSNumber *starRating = nil;
    
    PFQuery *query = [PFQuery queryWithClassName:@"Review"];
    [query includeKey:@"reviewee"];
    [query whereKey:@"reviewee" equalTo:self.mentor];
    [query findObjectsInBackgroundWithBlock:^(NSArray *reviews, NSError * _Nullable error) {
        if(reviews){
            NSNumber *no = [NSNumber numberWithBool:NO];
            NSMutableArray *cumulativeCompliments = [[NSMutableArray alloc] initWithObjects:no,no,no,no,no,nil];
            int i = 0;
            float totalRating = 0;
            for(Review *review in reviews){
                totalRating += [review.rating floatValue];
                
                
                //increment i so we are only updating compliments that have no's still
                while(review.complimentsArray[i] != no){
                    ++i;
                }
                for(int j = i; j < 5; ++j){
                    [cumulativeCompliments replaceObjectAtIndex:j withObject:[NSNumber numberWithBool:YES]];
                }
                
            }
            starRating = [NSNumber numberWithFloat:totalRating/reviews.count];
            
            NSString* formattedNumber = [NSString stringWithFormat:@"%.01f", [starRating doubleValue]];
            self.rating.text = [NSString stringWithFormat:@"%@ stars", formattedNumber];
            self.complimentsArray = [NSArray arrayWithArray:cumulativeCompliments];
            
            
        }
    }];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) loadMentor {
    
    self.profileImage.file = self.mentor.profilePic;
    self.usernameLabel.text = self.mentor.username;
    self.nameLabel.text = self.mentor.name;
    self.occupationLabel.text = [[ self.mentor.jobTitle stringByAppendingString:@" at "] stringByAppendingString:self.mentor.company];
    self.educationLabel.text = [[[ @"Studied " stringByAppendingString:self.mentor.major] stringByAppendingString:@" at "] stringByAppendingString:self.mentor.school];
    self.descriptionLabel.text = self.mentor.bio;
    
    self.adviceToGet = [NSArray arrayWithArray:self.mentor[@"getAdviceInterests"]];
    self.adviceToGive = [NSArray arrayWithArray:self.mentor[@"giveAdviceInterests"]];
    
    self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width / 2;
    self.profileImage.layer.masksToBounds = true;
    self.profileImage.layer.borderWidth = 5;
    
    if( self.isMentorOfMeeting == false ) {
        self.profileImage.layer.borderColor = CGColorRetain(UIColor.yellowColor.CGColor);
    } else {
        self.profileImage.layer.borderColor = CGColorRetain(UIColor.cyanColor.CGColor);
    }
    
    [self getRating];
    
}


/**************   COLLECTION VIEW ***********/

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if ( [collectionView isEqual:self.getAdviceCollectionView] ){
        return self.adviceToGet.count;
    } /*else if([collectionView isEqual:self.complimentsCollectionView]){
        return self.complimentsArray.count;
    }*/else {
        return self.adviceToGive.count;
    }
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if ( [collectionView isEqual:self.getAdviceCollectionView] ){
        GetAdviceCollectionViewCell *cellA = [collectionView dequeueReusableCellWithReuseIdentifier:@"GetAdviceCollectionViewCell" forIndexPath:indexPath];
        cellA.interest = self.adviceToGet[indexPath.item];
        [cellA reloadInputViews];
        return cellA;
    } /*else if([collectionView isEqual:self.complimentsCollectionView]){
        ComplimentCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ComplimentCell" forIndexPath:indexPath];
        
        return cell;
        
        
    } */ else {
        GiveAdviceCollectionViewCell *cellB = [collectionView dequeueReusableCellWithReuseIdentifier:@"GiveAdviceCollectionViewCell" forIndexPath:indexPath];
        cellB.interest = self.adviceToGive[indexPath.item];
        [cellB reloadInputViews];
        return cellB;
    }
}

- (IBAction)onTapCancel:(id)sender {
    
    NSLog(@"Cancel Button");
    
}

-(void)viewWillAppear:(BOOL)animated{
    [self loadMentor];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"createAppointmentSegue"]){
        
        CreateAppointmentViewController *createAppointViewController = [segue destinationViewController];
        createAppointViewController.isMentorOfMeeting = self.isMentorOfMeeting;
        createAppointViewController.otherAttendee = self.mentor;
        
    }
}

@end
