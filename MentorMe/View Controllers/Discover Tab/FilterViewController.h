//
//  FilterViewController.h
//  MentorMe
//
//  Created by Taylor Murray on 7/19/18.
//  Copyright © 2018 Taylor Murray. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol FilterDelegate
- (void)didChangeSchool:(NSNumber *)school withCompany:(NSNumber *)company withLocation:(NSNumber *)location andInterests:(NSNumber *)interests withGive:(NSArray *)give andGet:(NSArray *)get;
- (void) didChangeFilters;
@end

@interface FilterViewController : UIViewController

@property (weak, nonatomic) id<FilterDelegate> delegate;

@property (strong, nonatomic) NSArray *filterPreferences;

@property (nonatomic) BOOL getAdvice;
@property (strong, nonatomic) IBOutlet UISwitch *schoolSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *companySwitch;
@property (strong, nonatomic) IBOutlet UISwitch *locationSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *interestsSwitchs;

@end

