//
//  StoryCell.h
//  RoposoAssignment
//
//  Created by Tapasya  Samal on 02/06/16.
//  Copyright (c) 2016 Roposo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Story;

@interface StoryCell : UITableViewCell

+ (CGFloat)height;
- (void)assignCellDataWithStory:(Story *)story;

@end
