//
//  Author.h
//  RoposoAssignment
//
//  Created by Tapasya  Samal on 03/06/16.
//  Copyright (c) 2016 Roposo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Author : NSManagedObject

@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSNumber * followed;
@property (nonatomic, retain) NSString * name;

@end
