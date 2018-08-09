//
//  FilterViewController.m
//  MentorMe
//
//  Created by Taylor Murray on 7/19/18.
//  Copyright © 2018 Taylor Murray. All rights reserved.
//

#import "FilterViewController.h"
#import "Parse.h"
#import "PFUser+ExtendedUser.h"
#import <TTGTextTagCollectionView.h>
#import "InterestModel.h"

@interface CustomTagData: NSObject
@property (nonatomic, strong) InterestModel *interestInfo;
@end

@implementation CustomTagData
- (NSString *)getInterestString {
    return _interestInfo.subject;
}
@end

@interface FilterViewController () <TTGTextTagCollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *schoolLabel;
@property (weak, nonatomic) IBOutlet UILabel *companyLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;


@property (strong, nonatomic) IBOutlet TTGTextTagCollectionView *getAdviceTTGView;
@property (strong, nonatomic) IBOutlet TTGTextTagCollectionView *giveAdviceTTGView;

@end

@implementation FilterViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view
    
    if(self.selectedGetFilters.count == 0){
        self.selectedGetFilters = [[NSMutableArray alloc] init];
    }
    if(self.selectedGiveFilters.count == 0){
        self.selectedGiveFilters = [[NSMutableArray alloc]init];
    }
    
    
    
    [self loadTitles];
    self.giveAdviceTTGView.delegate = self;
    self.getAdviceTTGView.delegate = self;
    
    
    //[self checkSelectedTags:self.giveAdviceTTGView withArrayOfIndices:self.selectedIndexGive];
    //[self checkSelectedTags:self.getAdviceTTGView withArrayOfIndices:self.selectedIndexGet];
   
    [self.schoolSwitch setOn:false];
    [self.companySwitch setOn:false];
    [self.locationSwitch setOn:false];
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [self loadTagCollectionViews];
    
    
    
}

- (void) loadTitles {
    PFUser *myUser = [PFUser currentUser];
    self.schoolLabel.text =  [@"Attends " stringByAppendingString: myUser.school];
    self.companyLabel.text = [@"Works at " stringByAppendingString: myUser.company];
    self.locationLabel.text = [@"Lives in " stringByAppendingString: myUser.cityLocation];

    
    self.schoolLabel.adjustsFontSizeToFitWidth = YES;
    self.companyLabel.adjustsFontSizeToFitWidth = YES;
    self.locationLabel.adjustsFontSizeToFitWidth = YES;
}

- (void) loadTagCollectionViews{
    
    self.getAdviceTTGView.scrollView.alwaysBounceHorizontal = YES;
    self.giveAdviceTTGView.scrollView.alwaysBounceHorizontal = YES;
    
    self.getAdviceTTGView.scrollView.showsHorizontalScrollIndicator = NO;
    self.giveAdviceTTGView.scrollView.showsHorizontalScrollIndicator = NO;
    
    self.getAdviceTTGView.scrollView.alwaysBounceVertical = YES;
    self.giveAdviceTTGView.scrollView.alwaysBounceVertical = YES;
    
    self.getAdviceTTGView.scrollView.showsVerticalScrollIndicator = NO;
    self.giveAdviceTTGView.scrollView.showsVerticalScrollIndicator = NO;
    
    //1. Initialize Tag Collection Views
    TTGTextTagConfig *config = self.giveAdviceTTGView.defaultConfig;
    
   
    //2. Set Tag Properties
    config.tagTextFont = [UIFont fontWithName:@"Avenir" size:17];
    config.tagTextColor = [UIColor whiteColor];
    config.tagSelectedTextColor = [UIColor whiteColor];
    config.tagBackgroundColor = [UIColor colorWithRed:0.67 green:0.71 blue:1.00 alpha:1.00];
    config.tagSelectedBackgroundColor = [UIColor colorWithRed:0.38 green:0.12 blue:1.00 alpha:1.00];
    self.giveAdviceTTGView.horizontalSpacing = 8.0;
    self.giveAdviceTTGView.verticalSpacing = 8.0;
    config.tagBorderColor = [UIColor colorWithRed:0.18 green:0.19 blue:0.22 alpha:1.00];
    config.tagSelectedBorderColor = [UIColor colorWithRed:0.18 green:0.19 blue:0.22 alpha:1.00];
    config.tagBorderWidth = 1;
    config.tagCornerRadius = 6;
    
    
    //3. Fetch Query to Fill Tags
    PFQuery *queryforCurrentUser = [PFUser query];
    NSArray *queryStrings = [NSArray arrayWithObjects:@"giveAdviceInterests", @"getAdviceInterests", @"username", nil];
    [queryforCurrentUser includeKeys:queryStrings];
    [queryforCurrentUser whereKey:@"username" equalTo:PFUser.currentUser[@"username"]];
    [queryforCurrentUser findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if(error == nil){
            PFUser *myUser = [objects firstObject];
            for(InterestModel *interest in myUser.giveAdviceInterests){
                
                config.extraData = interest;
                [self.giveAdviceTTGView addTag:interest.subject withConfig:config];
            }
            for(InterestModel *interest in myUser.getAdviceInterests){
                
                config.extraData = interest;
                [self.getAdviceTTGView addTag:interest.subject withConfig:config];
            }
            
            [self checkSelectedTags:self.giveAdviceTTGView withArrayOfIndices:self.selectedIndexGive];
            [self checkSelectedTags:self.getAdviceTTGView withArrayOfIndices:self.selectedIndexGet];
        }
    }];
    self.getAdviceTTGView.defaultConfig = config;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)checkSelectedTags:(TTGTextTagCollectionView *)textTagCollectionView withArrayOfIndices:(NSMutableArray *)arrayOfIndices {
    
    if( arrayOfIndices != nil ){
        NSLog(@"Checking selected tags");
        for(NSNumber *index in arrayOfIndices ){
            [textTagCollectionView setTagAtIndex:[index integerValue] selected:YES];
        }
    }
}



- (void)textTagCollectionView:(TTGTextTagCollectionView *)textTagCollectionView didTapTag:(NSString *)tagText atIndex:(NSUInteger)index selected:(BOOL)selected tagConfig:(TTGTextTagConfig *)config{
    
    if( textTagCollectionView == self.getAdviceTTGView ){
        if(selected){
            [self.selectedGetFilters addObject:tagText];
            NSNumber *indexAsNumber = [NSNumber numberWithUnsignedInteger:index];
            
            if( self.selectedIndexGet == nil ){
                self.selectedIndexGet = [[NSMutableArray alloc] initWithObjects:indexAsNumber, nil];
            } else {
                [self.selectedIndexGet addObject:indexAsNumber];
            }
            NSLog(@"%@", [self.selectedIndexGet firstObject]);
        } else{
            [self.selectedGetFilters removeObject:tagText];
            NSNumber *indexAsNumber = [NSNumber numberWithUnsignedInteger:index];
            
            if( self.selectedIndexGet == nil ){
                self.selectedIndexGet = [[NSMutableArray alloc] initWithObjects:indexAsNumber, nil];
            } else {
                [self.selectedIndexGet removeObject:indexAsNumber];
            }
            NSLog(@"%@", [self.selectedIndexGet firstObject]);
        }
        
    } else {
        if(selected){
            [self.selectedGiveFilters addObject:tagText];
            NSNumber *indexAsNumber = [NSNumber numberWithUnsignedInteger:index];
            
            if( self.selectedIndexGive == nil ){
                self.selectedIndexGive = [[NSMutableArray alloc] initWithObjects:indexAsNumber, nil];
            } else {
                [self.selectedIndexGive addObject:indexAsNumber];
            }
            NSLog(@"%@", [self.selectedIndexGive firstObject]);
        } else{
            [self.selectedGiveFilters removeObject:tagText];
            NSNumber *indexAsNumber = [NSNumber numberWithUnsignedInteger:index];
            
            if( self.selectedIndexGive == nil ){
                self.selectedIndexGive = [[NSMutableArray alloc] initWithObjects:indexAsNumber, nil];
            } else {
                [self.selectedIndexGive removeObject:indexAsNumber];
            }
            NSLog(@"%@", [self.selectedIndexGive firstObject]);
        }
        
    }
}



/**** BUTTON OUTLETS *****/
- (IBAction)onTapBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onTapConfirm:(UIBarButtonItem *)sender {
    
    
    [self.delegate didChangeFilters:self.selectedGetFilters withGiveInterests:self.selectedGiveFilters withGetIndex:self.selectedIndexGet withGiveIndex:self.selectedIndexGive];
    [self dismissViewControllerAnimated:YES completion:nil];
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
