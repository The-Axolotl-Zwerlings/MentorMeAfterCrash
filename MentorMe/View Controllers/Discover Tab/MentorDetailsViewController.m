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
#import "ComplimentsCell.h"



@interface MentorDetailsViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong, nonatomic) IBOutlet UICollectionView *complimentsCollectionView;

@property (strong, nonatomic) NSArray *complimentsArray;
@property (weak, nonatomic) IBOutlet PFImageView *profileImage;
@property (strong, nonatomic) IBOutlet UILabel *rating;

@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIView *ratingVIew;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *occupationLabel;
@property (weak, nonatomic) IBOutlet UILabel *educationLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollViewMentor;
@property (weak, nonatomic) IBOutlet UIButton *connectButton;

@property (strong, nonatomic) NSArray* adviceToGet;
@property (strong, nonatomic) NSArray* adviceToGive;

@property (strong, nonatomic) IBOutlet UICollectionView *getAdviceCollectionView;
@property (strong, nonatomic) IBOutlet UICollectionView *giveAdviceCollectionView;
@property (weak, nonatomic) IBOutlet PFImageView *largeImage;

@end

@implementation MentorDetailsViewController

int myCounter;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.scrollViewMentor setContentSize:CGSizeMake(375, self.complimentsCollectionView.frame.size.height + self.complimentsCollectionView.frame.origin.y+238)];
    
    [self loadMentor];
    
    self.connectButton.layer.shadowColor = UIColor.grayColor.CGColor;
    self.connectButton.layer.shadowOffset = CGSizeMake(0, 5);
    self.connectButton.layer.shadowRadius = 3;
    self.connectButton.layer.shadowOpacity = 0.5f;
    
    self.title = self.mentor.name;
    
    self.scrollViewMentor.showsVerticalScrollIndicator = NO;
    self.scrollViewMentor.alwaysBounceVertical = YES;
    
    self.getAdviceCollectionView.delegate = self;
    self.getAdviceCollectionView.dataSource = self;
    
    self.giveAdviceCollectionView.delegate = self;
    self.giveAdviceCollectionView.dataSource = self;
    
    self.complimentsCollectionView.dataSource = self;
    self.complimentsCollectionView.delegate = self;
    
    self.getAdviceCollectionView.alwaysBounceHorizontal = YES;
    self.getAdviceCollectionView.showsHorizontalScrollIndicator = NO;
    
    self.giveAdviceCollectionView.alwaysBounceHorizontal = YES;
    self.giveAdviceCollectionView.showsHorizontalScrollIndicator = NO;
    
    self.complimentsCollectionView.alwaysBounceHorizontal = YES;
    self.complimentsCollectionView.showsHorizontalScrollIndicator = NO;
    
//initializing a tap gesture recogniser
    UITapGestureRecognizer *imageTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleImageTap:)];
    [self.profileImage addGestureRecognizer:imageTap];
    
}

//action for image tap
-(void)handleImageTap: (UITapGestureRecognizer *) recognizer{

    UIViewController *bbp=[[UIViewController alloc]init];
    UINavigationController *passcodeNavigationController = [[UINavigationController alloc] initWithRootViewController:bbp];
    UIBarButtonItem *myNavBtn = [[UIBarButtonItem alloc] initWithTitle:
                               @"Back" style:UIBarButtonItemStylePlain target:
                             self action:@selector(myButtonClicked:)];
    [self.navigationController presentViewController:passcodeNavigationController animated:YES completion:nil];
    bbp.view.backgroundColor = UIColor.blackColor;
    bbp.navigationController.navigationBar.barTintColor = UIColor.blackColor;
    bbp.navigationItem.leftBarButtonItem = myNavBtn;
    PFImageView* large = [[PFImageView alloc]init];
    large.translatesAutoresizingMaskIntoConstraints = false;
    [bbp.view addSubview:large];
    large.file = self.mentor.profilePic;
    [large loadInBackground:^(UIImage * _Nullable image, NSError * _Nullable error) {
        if(error == nil){
            NSLog(@"We did it!");
        }
    }];
    [large.widthAnchor constraintEqualToConstant:bbp.view.frame.size.width].active = YES;
    [large.heightAnchor constraintEqualToConstant:bbp.view.frame.size.width].active = YES;
    
    [large.centerXAnchor constraintEqualToAnchor:bbp.view.centerXAnchor].active = YES;
    [large.centerYAnchor constraintEqualToAnchor:bbp.view.centerYAnchor].active = YES;
}

- (void)myButtonClicked:(UIBarButtonItem*)sender
{
     [self dismissViewControllerAnimated:YES completion:nil];
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
            float totalRating = 0;
            for(Review *review in reviews){
                totalRating += [review.rating floatValue];
                
                
                for(int i = 0; i < 5; ++i){
                    if(review.complimentsArray[i] == [NSNumber numberWithBool:YES]){
                        NSNumber *newTotalOfCompliment = [NSNumber numberWithFloat:([cumulativeCompliments[i] floatValue] + 1)];
                        [cumulativeCompliments replaceObjectAtIndex:i withObject:newTotalOfCompliment];
                    }
                }
                
            }
            starRating = [NSNumber numberWithFloat:totalRating/reviews.count];
            
            if( isnan([starRating doubleValue]) == 0 ){
                self.ratingVIew.hidden = false;
                 NSString* formattedNumber = [NSString stringWithFormat:@"%.01f", [starRating doubleValue]];
                self.rating.text = [NSString stringWithFormat:@"%@", formattedNumber];
                self.complimentsArray = [NSArray arrayWithArray:cumulativeCompliments];
                [self.complimentsCollectionView reloadData];
                
                self.ratingVIew.layer.cornerRadius = 13;
                self.ratingVIew.layer.masksToBounds = YES;
                
            } else {
                self.ratingVIew.hidden = true;
            }
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) loadMentor {
    
    self.profileImage.file = self.mentor.profilePic;
    self.nameLabel.text = self.mentor.name;
    self.occupationLabel.text = [[ self.mentor.jobTitle stringByAppendingString:@" at "] stringByAppendingString:self.mentor.company];
    self.educationLabel.text = [[[ @"Studied " stringByAppendingString:self.mentor.major] stringByAppendingString:@" at "] stringByAppendingString:self.mentor.school];
    self.descriptionLabel.text = self.mentor.bio;
    NSString *cityLabelAppend = self.mentor[@"cityLocation"];
    NSString *stateLabelAppend = self.mentor[@"stateLocation"];
    
    self.locationLabel.text = [[[@"Lives in " stringByAppendingString:cityLabelAppend] stringByAppendingString:@", "] stringByAppendingString:stateLabelAppend];
    
    self.adviceToGet = [NSArray arrayWithArray:self.mentor[@"getAdviceInterests"]];
    self.adviceToGive = [NSArray arrayWithArray:self.mentor[@"giveAdviceInterests"]];
    
    self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width / 2;
    self.profileImage.layer.masksToBounds = true;
    self.profileImage.layer.borderWidth = 5;
    
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    
    //[self.nameLabel sizeToFit];
    
    UIColor *colorA = [UIColor colorWithRed:0.87 green:0.77 blue:0.87 alpha:1.0];
    UIColor *colorB = [UIColor colorWithRed:0.86 green:0.81 blue:0.93 alpha:1.0];
    
    if( self.isMentorOfMeeting == false ) {
        self.profileImage.layer.borderColor = CGColorRetain(colorA.CGColor);
    } else {
        self.profileImage.layer.borderColor = CGColorRetain(colorB.CGColor);
    }
    
    [self getRating];
    
    
}


/**************   COLLECTION VIEW ***********/

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if ( [collectionView isEqual:self.getAdviceCollectionView] ){
        return self.adviceToGet.count;
    } else if([collectionView isEqual:self.complimentsCollectionView]){
        if(self.complimentsArray != nil){
            int count = 0;
            for(int i = 0; i < 5; ++i){
                if(self.complimentsArray[i] != [NSNumber numberWithBool:NO]){
                    ++count;
                }
            }
            return count;
        } else{
            return 0;
        }
    }else {
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
        [cellA loadCollectionViewCell];
        [cellA layoutInterests];
        return cellA;
    } else if([collectionView isEqual:self.complimentsCollectionView]){
        ComplimentsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ComplimentsCell" forIndexPath:indexPath];
        if(indexPath.item == 0){
            myCounter = 0;
        }
        while(self.complimentsArray[myCounter] == [NSNumber numberWithBool:NO]){
            ++myCounter;
        }
        [cell formatCellWithIndex:[NSNumber numberWithInteger:myCounter] andCount:(self.complimentsArray[myCounter])];
        
        ++myCounter;
        return cell;
        
    } else {
        GiveAdviceCollectionViewCell *cellB = [collectionView dequeueReusableCellWithReuseIdentifier:@"GiveAdviceCollectionViewCell" forIndexPath:indexPath];
        cellB.interest = self.adviceToGive[indexPath.item];
        [cellB loadCollectionViewCell];
        [cellB layoutInterests];
        return cellB;
    }
}


-(void)viewWillAppear:(BOOL)animated{
    [self loadMentor];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    InterestModel *modelA;
    if( [collectionView isEqual: self.getAdviceCollectionView] ){
        modelA = self.adviceToGet[indexPath.row];
    } else {
        modelA = self.adviceToGive[indexPath.row];
    }
    
    NSString *testString = modelA.subject;
    
    CGSize textSize = [testString sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Avenir" size:17.0f]}];
    textSize.height += 8;
    textSize.width += 24;
    return textSize;
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
