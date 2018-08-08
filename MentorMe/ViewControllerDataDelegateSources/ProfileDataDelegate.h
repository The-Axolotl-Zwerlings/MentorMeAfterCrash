//
//  ProfileDataDelegate.h
//  MentorMe
//
//  Created by Taylor Murray on 8/7/18.
//  Copyright © 2018 Taylor Murray. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface ProfileDataDelegate : NSObject <UICollectionViewDelegate,UICollectionViewDataSource>
-(id)init:(UICollectionView *)mentorsCollectionView andSource:(id)source;
-(void)queryforMentors;
@property (strong, nonatomic) NSArray *mentors;
@property (strong, nonatomic) UICollectionView *mentorsCollectionView;
@property (strong,nonatomic) id source;
@end
