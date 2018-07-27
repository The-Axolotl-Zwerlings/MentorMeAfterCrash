//
//  DiscoverCell.m
//  MentorMe
//
//  Created by Taylor Murray on 7/18/18.
//  Copyright © 2018 Taylor Murray. All rights reserved.
//

#import "DiscoverCell.h"
#import "PFUser+ExtendedUser.h"
#import "GetAdviceCollectionViewCell.h"
#import "GiveAdviceCollectionViewCell.h"

@interface DiscoverCell () <UICollectionViewDataSource, UICollectionViewDelegate>

@end

@implementation DiscoverCell


-(id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
   
    if (!(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) return nil;

    self.getCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];
    self.getCollectionView.dataSource = self;
    self.getCollectionView.delegate = self;
    
    self.giveCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];
    self.giveCollectionView.dataSource = self;
    self.giveCollectionView.delegate = self;
    
    
    self.giveInterets = self.userForCell.giveAdviceInterests;
    self.getInterests = self.userForCell.getAdviceInterests;

    return self;

    
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)layoutCell:(PFUser *)user{
    
    self.nameLabel.text = user.name;
    
    NSString *jobTitleAppend = user[@"jobTitle"];
    NSString *companyLabelAppend = user[@"company"];
    self.occupationLabel.text = [[jobTitleAppend stringByAppendingString:@" at "] stringByAppendingString:companyLabelAppend];
    NSString *majorLabelAppend = user[@"major"];
    NSString *schoolLabelAppend = user[@"school"];
    self.educationLabel.text = [[[@"Studied " stringByAppendingString:majorLabelAppend] stringByAppendingString:@" at " ] stringByAppendingString: schoolLabelAppend];
    
    [self.educationLabel sizeToFit];
    
    self.profilePicView.file = user[@"profilePic"];
    [self.profilePicView loadInBackground];
    
    self.profilePicView.layer.masksToBounds = true;
    self.profilePicView.layer.borderWidth = 5;
    self.profilePicView.layer.borderColor = CGColorRetain(UIColor.whiteColor.CGColor);
    self.profilePicView.layer.cornerRadius = self.profilePicView.frame.size.width /2;
    
}

- (void)setCollectionViewDataSourceDelegate:(id<UICollectionViewDataSource, UICollectionViewDelegate>)dataSourceDelegate indexPath:(NSIndexPath *)indexPath
{
    self.getCollectionView.dataSource = dataSourceDelegate;
    self.getCollectionView.delegate = dataSourceDelegate;
    
    //self.giveCollectionView.dataSource = dataSourceDelegate;
    //self.giveCollectionView.delegate = dataSourceDelegate;
    
   // self.getCollectionView.indexPath = indexPath;
    [self.getCollectionView setContentOffset:self.getCollectionView.contentOffset animated:NO];
    
    [self.getCollectionView reloadData];
}




@end
