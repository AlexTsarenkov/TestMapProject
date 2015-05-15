//
//  ViewController.m
//  TestMapProject
//
//  Created by Alexey Tsarenkov on 13.05.15.
//  Copyright (c) 2015 alextsarenkov. All rights reserved.
//

#import "ViewController.h"
#import "MyPlacemarkObject.h"
#import "MyTableViewCell.h"

@interface ViewController (){
    BOOL isCurrentLocation;
    BOOL isClicked;
}
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong,nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) IBOutlet UITableView *tableViewOutlet;
@property (strong, nonatomic) IBOutlet UIButton *showButtonOutlet;
- (IBAction)longPressHandler:(UILongPressGestureRecognizer *)sender;
- (IBAction)showButtonClick:(id)sender;
@end

@implementation ViewController 

- (void)viewDidLoad {
    [super viewDidLoad];
    self.placemarksArray = [[NSMutableArray alloc] init];
    isCurrentLocation = NO;
    isClicked = NO;
    self.mapView.showsUserLocation = YES;
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    
    BOOL isFirstLaunch = [[NSUserDefaults standardUserDefaults] boolForKey:@"FirstLaunch"];
    if (!isFirstLaunch) {
        [self firstLaunch];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - custom methods

-(void) firstLaunch {
    NSString * ver = [[UIDevice currentDevice]systemVersion];
    
    if ([ver intValue] >= 8) {
        [self.locationManager requestAlwaysAuthorization];
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"FirstLaunch"];
    }
}

- (void) setupMapView: (CLLocationCoordinate2D) coord {
    MKCoordinateRegion refion = MKCoordinateRegionMakeWithDistance(coord, 500, 500);

    [self.mapView setRegion:refion animated:YES];
}

#pragma mark - MKMapViewDelegate

-(void) mapViewDidFinishRenderingMap:(MKMapView *)mapView fullyRendered:(BOOL)fullyRendered{
    [self.locationManager startUpdatingLocation];
}
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation{

    if (![annotation isMemberOfClass:MKUserLocation.class]) {
        MKAnnotationView * annView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Annotation"];

        annView.canShowCallout = NO;
        annView.image = [UIImage imageNamed:@"blue-pin.png"];
        
        [annView addSubview:[self getCalloutView:annotation.title]];
        
        return annView;
    }
    return nil;
}

-(UIView *) getCalloutView: (NSString*) title {
    UIView * callView = [[UIView alloc] initWithFrame:CGRectMake(-100, -105, 250, 100)];
    
    callView.backgroundColor = [UIColor whiteColor];
    callView.tag = 1000;
    callView.alpha = 0;
    
    UILabel * lable = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 240, 90)];
    lable.numberOfLines = 0;
    lable.lineBreakMode = NSLineBreakByWordWrapping;
    lable.textAlignment = NSTextAlignmentLeft;
    lable.textColor = [UIColor blackColor];
    lable.text = title;
    
    [callView addSubview:lable];
    
    return callView;
}
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view{
    if (![view.annotation isMemberOfClass:MKUserLocation.class]) {
        for (UIView * subView in view.subviews) {
            if (subView.tag == 1000) {
                subView.alpha = 1;
            }
        }
    }
    
}
- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    if (![view.annotation isMemberOfClass:MKUserLocation.class]) {
        for (UIView * subView in view.subviews) {
            if (subView.tag == 1000) {
               subView.alpha = 0;
            }
        }
    }
    
}
#pragma mark - CLLocationManagerDelegate

-(void) locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    
    if(!isCurrentLocation) {
        isCurrentLocation = YES;
        
        [self setupMapView:newLocation.coordinate];
    }
}
- (IBAction)longPressHandler:(UILongPressGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        
        CLLocationCoordinate2D coordScreenPoint = [self.mapView convertPoint:[sender locationInView:self.mapView] toCoordinateFromView:self.mapView];
        
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        
        CLLocation * tapLocation = [[CLLocation alloc] initWithLatitude:coordScreenPoint.latitude longitude:coordScreenPoint.longitude];
        
        [geocoder reverseGeocodeLocation:tapLocation completionHandler:^(NSArray *placemarks, NSError *error) {
            CLPlacemark *place = [placemarks objectAtIndex:0];
            NSString * addressString = [NSString stringWithFormat:@"Город - %@\nУлица - %@\nИндекс - %@",[place.addressDictionary valueForKey:@"City"],[place.addressDictionary valueForKey:@"Street"],[place.addressDictionary valueForKey:@"ZIP"]];
//            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Tap adress" message:addressString delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//            [alert show];
            MKPointAnnotation * annotation = [[MKPointAnnotation alloc] init];
            annotation.coordinate = coordScreenPoint;
            annotation.title =addressString;
            
            MyPlacemarkObject * obj = [[MyPlacemarkObject alloc] initWithData:addressString Coordinate:coordScreenPoint];
            [self.placemarksArray addObject:obj];
            [self reloadTableView];
            [self.mapView addAnnotation:annotation];

        }];
        
        
    }
}

- (IBAction)showButtonClick:(id)sender {
    
    if (!isClicked) {
        self.tableViewOutlet.alpha = 1;
        [self.showButtonOutlet setTitle:@"Hide pins" forState:UIControlStateNormal];
    }
    else{
        self.tableViewOutlet.alpha = 0;
        [self.showButtonOutlet setTitle:@"Show pins" forState:UIControlStateNormal];
    }
    isClicked = !isClicked;
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.placemarksArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCell"];
    
    MyPlacemarkObject *obj = [self.placemarksArray objectAtIndex:indexPath.row];
    
    cell.image.image = [UIImage imageNamed:@"blue-pin.png"];
    cell.label_text.text = obj.text;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyPlacemarkObject * obj = [self.placemarksArray objectAtIndex:indexPath.row];
    
    [self setupMapView:obj.coord];
     
}

-(void) reloadTableView {
       dispatch_async(dispatch_get_main_queue(), ^{
           [self.tableViewOutlet reloadData];
        });
}
@end
