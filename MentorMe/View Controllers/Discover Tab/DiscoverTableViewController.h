//
//  DiscoverTableViewController.h
//  MentorMe
//
//  Created by Nico Salinas on 7/12/18.
//  Copyright © 2018 Taylor Murray. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DiscoverTableViewControllerDelegate;

@interface DiscoverTableViewController : UIViewController <UITableViewDelegate,UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *discoverTableView;
@property (weak, nonatomic) id <DiscoverTableViewControllerDelegate> delegate;

@end
