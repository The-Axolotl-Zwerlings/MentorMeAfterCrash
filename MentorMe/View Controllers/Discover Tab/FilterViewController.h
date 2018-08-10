//
//  FilterViewController.h
//  MentorMe
//
//  Created by Taylor Murray on 7/19/18.
//  Copyright © 2018 Taylor Murray. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol FilterDelegate
- (void) didChangeFilters:(NSMutableArray *) incomingGetInterests withGiveInterests:(NSMutableArray *) incomingGiveInterests withGetIndex:(NSMutableArray *) incomingGetIndices withGiveIndex:(NSMutableArray *) incomingGiveIndices andOtherFilterArray:(NSArray *)otherFilterArray;
@end

@interface FilterViewController : UIViewController
@property (weak, nonatomic) id<FilterDelegate> delegate;
@property (strong, nonatomic) NSMutableArray *selectedGetFilters;
@property (strong, nonatomic) NSMutableArray *selectedGiveFilters;
@property (strong, nonatomic) NSMutableArray *selectedInterests;

@property (nonatomic) BOOL getAdvice;
@property (strong, nonatomic) IBOutlet UISwitch *schoolSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *companySwitch;
@property (strong, nonatomic) IBOutlet UISwitch *locationSwitch;

@property (strong, nonatomic) NSMutableArray *selectedIndexGet;
@property (strong, nonatomic) NSMutableArray *selectedIndexGive;

@property (strong, nonatomic) NSArray *otherFiltersArray;
@end

