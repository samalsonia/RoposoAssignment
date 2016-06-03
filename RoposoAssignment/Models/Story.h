//
//  Story.h
//  RoposoAssignment
//
//  Created by Tapasya  Samal on 03/06/16.
//  Copyright (c) 2016 Roposo. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Author;

@interface Story : NSObject

@property (nonatomic, strong) NSString * identifier;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * descriptionText;
@property (nonatomic, strong) NSString * image;
@property (nonatomic, strong) NSString * imageUrl;
@property (nonatomic, strong) NSString * authorId;
@property (nonatomic, strong) Author * author;

- (instancetype)initWithId:(NSString *)identifier authorId:(NSString *)authorId title:(NSString *)titleText description:(NSString *)description thumbnailImage:(NSString *)imageName imageUrl:(NSString *)imageUrl;

@end
