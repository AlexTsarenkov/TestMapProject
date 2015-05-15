//
//  ViewController.h
//  TestMapProject
//
//  Created by Alexey Tsarenkov on 13.05.15.
//  Copyright (c) 2015 alextsarenkov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource>
@property NSMutableArray  * placemarksArray;


@end

