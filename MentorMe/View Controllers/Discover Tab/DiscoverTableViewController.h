//
//  DiscoverTableViewController.h
//  MentorMe
//
//  Created by Nico Salinas on 7/12/18.
//  Copyright © 2018 Taylor Murray. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DiscoverTableViewControllerDelegate;

@interface DiscoverTableViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) id <DiscoverTableViewControllerDelegate> delegate;

@property (strong, nonatomic) NSMutableArray *filteredUsersFromQuery;
@property (strong, nonatomic) NSArray *allUsersFromQuery;

@property (strong, nonatomic) NSMutableArray *filtersToSearchGetWith;
@property (strong, nonatomic) NSMutableArray *filtersToSearchGiveWith;

@property (strong, nonatomic) NSMutableArray *filterGive;
@property (strong, nonatomic) NSMutableArray *filterGet;

@property (strong, nonatomic) NSMutableArray *getIndex;
@property (strong, nonatomic) NSMutableArray *giveIndex;

@property (strong, nonatomic) NSArray *otherFiltersArray;

@end
