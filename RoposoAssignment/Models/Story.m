//
//  Story.m
//  RoposoAssignment
//
//  Created by Tapasya  Samal on 03/06/16.
//  Copyright (c) 2016 Roposo. All rights reserved.
//

#import "Story.h"

@implementation Story

- (instancetype)initWithId:(NSString *)identifier authorId:(NSString *)authorId title:(NSString *)titleText description:(NSString *)description thumbnailImage:(NSString *)imageName imageUrl:(NSString *)imageUrl
{
    self = [super init];
    if (self) {
        self.identifier = identifier;
        self.authorId = authorId;
        self.title = titleText;
        self.descriptionText= description;
        self.image = imageName;
        self.imageUrl = imageUrl;
    }
    return self;
}

@end
