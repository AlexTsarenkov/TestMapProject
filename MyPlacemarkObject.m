//
//  MyPlacemarkObject.m
//  TestMapProject
//
//  Created by Alexey Tsarenkov on 15.05.15.
//  Copyright (c) 2015 alextsarenkov. All rights reserved.
//

#import "MyPlacemarkObject.h"

@implementation MyPlacemarkObject

- (instancetype)initWithData:(NSString *) title Coordinate:(CLLocationCoordinate2D  ) coord
{
    self = [super init];
    if (self) {
        self.text = title;
        self.coord = coord;
    }
    return self;
}
@end
