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
@end
@interface FilterViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITableView *interestsTableView;
@property (nonatomic) BOOL getAdvice;
@property (weak, nonatomic) id<FilterDelegate> delegate;
@property (strong, nonatomic) NSArray *filterPreferences;
@end

