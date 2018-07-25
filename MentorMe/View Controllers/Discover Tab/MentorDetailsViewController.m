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

#import "GetAdviceCollectionViewCell.h"
#import "GiveAdviceCollectionViewCell.h"

@interface MentorDetailsViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet PFImageView *bannerImage;
@property (weak, nonatomic) IBOutlet PFImageView *profileImage;

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
    
    self.getAdviceCollectionView.delegate = self;
    self.getAdviceCollectionView.dataSource = self;
    self.giveAdviceCollectionView.delegate = self;
    self.giveAdviceCollectionView.dataSource = self;
    
    self.adviceToGet = [[NSArray alloc]initWithArray:self.mentor[@"getAdviceInterests"]];
    self.adviceToGive = [[NSArray alloc]initWithArray:self.mentor[@"giveAdviceInterests"]];
    
    self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width / 2;
    self.profileImage.layer.masksToBounds;
    
    
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
    
}

- (void) refreshData {
    
    
}

/**************   COLLECTION VIEW ***********/

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if ( [collectionView isEqual:self.getAdviceCollectionView] ){
        
        return self.adviceToGet.count;
        
    } else {
        
        return self.adviceToGive.count;
        
    }
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
    
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if ( [collectionView isEqual:self.getAdviceCollectionView] ){
        GetAdviceCollectionViewCell *cellA = [collectionView dequeueReusableCellWithReuseIdentifier:@"GetAdviceCollectionViewCell" forIndexPath:indexPath];
        cellA.interestNameLabel.text = self.adviceToGet[indexPath.item];
        return cellA;
        
    } else {
        GiveAdviceCollectionViewCell *cellB = [collectionView dequeueReusableCellWithReuseIdentifier:@"GiveAdviceCollectionViewCell" forIndexPath:indexPath];
        cellB.interestNameLabel.text = self.adviceToGive[indexPath.item];
        
        return cellB;
    }
}



- (IBAction)onTapCancel:(id)sender {
    
    NSLog(@"Cancel Button");
    
    
    
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
