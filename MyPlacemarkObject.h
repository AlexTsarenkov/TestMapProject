//
//  MyPlacemarkObject.h
//  TestMapProject
//
//  Created by Alexey Tsarenkov on 15.05.15.
//  Copyright (c) 2015 alextsarenkov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface MyPlacemarkObject : NSObject
@property NSString * text;
@property CLLocationCoordinate2D  coord;


- (instancetype)initWithData:(NSString *) title Coordinate:(CLLocationCoordinate2D ) coord;
@end
