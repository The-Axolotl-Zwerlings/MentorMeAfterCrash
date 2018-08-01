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
    // Do any additional setup after loading the view.
    if(self.filterPreferences == nil){
        self.filterPreferences = [NSArray arrayWithObjects:@(0),@(0),@(0),@(0),nil];
    }

    [self loadTitles];
    self.giveAdviceTTGView.delegate = self;
    self.getAdviceTTGView.delegate = self;
    [self loadTagCollectionViews];
   
    
    [self.schoolSwitch setOn:[self.filterPreferences[0] boolValue]];
    [self.companySwitch setOn:[self.filterPreferences[1] boolValue]];
    [self.locationSwitch setOn:[self.filterPreferences[2] boolValue]];
    [self.interestsSwitchs setOn:![self.filterPreferences[3] boolValue]];
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
    
    //1. Initialize Tag Collection Views
    TTGTextTagConfig *config = self.giveAdviceTTGView.defaultConfig;
    
   
    //2. Set Tag Properties
    config.tagTextFont = [UIFont boldSystemFontOfSize:18.0f];
    config.tagTextColor = [UIColor colorWithRed:0.18 green:0.19 blue:0.22 alpha:1.00];
    config.tagSelectedTextColor = [UIColor colorWithRed:0.18 green:0.19 blue:0.22 alpha:1.00];
    config.tagBackgroundColor = [UIColor colorWithRed:0.98 green:0.91 blue:0.43 alpha:1.00];
    config.tagSelectedBackgroundColor = [UIColor colorWithRed:0.97 green:0.64 blue:0.27 alpha:1.00];
    self.giveAdviceTTGView.horizontalSpacing = 6.0;
    self.giveAdviceTTGView.verticalSpacing = 8.0;
    config.tagBorderColor = [UIColor colorWithRed:0.18 green:0.19 blue:0.22 alpha:1.00];
    config.tagSelectedBorderColor = [UIColor colorWithRed:0.18 green:0.19 blue:0.22 alpha:1.00];
    config.tagBorderWidth = 1;
    config.tagSelectedBorderWidth = 1;
    config.tagShadowColor = [UIColor blackColor];
    config.tagShadowOffset = CGSizeMake(0, 0.3);
    config.tagShadowOpacity = 0.3f;
    config.tagShadowRadius = 0.5f;
    config.tagCornerRadius = 50;
    
    PFQuery *queryforCurrentUser = [PFUser query];
    [queryforCurrentUser includeKey:@"giveAdviceInterests"];
    [queryforCurrentUser includeKey:@"getAdviceInterests"];
    [queryforCurrentUser includeKey:@"username"];
    [queryforCurrentUser whereKey:@"username" equalTo:PFUser.currentUser[@"username"]];
    [queryforCurrentUser findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if(error == nil){
            PFUser *user = objects[0];
            for(InterestModel *interest in user.giveAdviceInterests){
                TTGTextTagConfig *config = [TTGTextTagConfig new];
                config.extraData = interest;
                [self.giveAdviceTTGView addTag:interest.subject withConfig:config];
            }
            for(InterestModel *interest in user.getAdviceInterests){
                TTGTextTagConfig *config = [TTGTextTagConfig new];
                config.extraData = interest;
                [self.getAdviceTTGView addTag:interest.subject withConfig:config];
            }
        }
    }];
    
    self.getAdviceTTGView.defaultConfig = config;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)textTagCollectionView:(TTGTextTagCollectionView *)textTagCollectionView didTapTag:(NSString *)tagText atIndex:(NSUInteger)index selected:(BOOL)selected tagConfig:(TTGTextTagConfig *)config{
    NSLog(@"you tapped %@", tagText);
}









/**** BUTTON OUTLETS *****/



- (IBAction)onTapBack:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}




- (IBAction)onTapConfirm:(UIBarButtonItem *)sender {
    
    NSNumber *school = [NSNumber numberWithBool:[self.schoolSwitch isOn]];
    NSNumber *location = [NSNumber numberWithBool:[self.locationSwitch isOn]];
    NSNumber *company = [NSNumber numberWithBool:[self.companySwitch isOn]];
    NSNumber *interests = [NSNumber numberWithBool:[self.interestsSwitchs isOn]];
    
    self.filterPreferences = [NSArray arrayWithObjects:school,company,location,interests,nil];
    
    NSMutableArray *giveData = [[NSMutableArray alloc]init];
    NSMutableArray *getData = [[NSMutableArray alloc]init];
    NSArray *configsGetAdvice = [self.getAdviceTTGView getConfigsAtSelected];
    NSArray *configsGiveAdvice = [self.giveAdviceTTGView getConfigsAtSelected];
    for(TTGTextTagConfig *config in configsGetAdvice){
        [getData addObject:((InterestModel *)config.extraData)];
    }
    for(TTGTextTagConfig *config in configsGiveAdvice){
        [giveData addObject:((InterestModel *)config.extraData)];
    }
    
    [self.delegate didChangeSchool:school withCompany:company withLocation:location andInterests:interests withGive:[NSArray arrayWithArray:giveData] andGet:[NSArray arrayWithArray:getData]];
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
