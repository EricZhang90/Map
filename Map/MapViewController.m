//
//  MapViewController.m
//  Map
//
//  Created by Eric on 2016-02-10.
//  Copyright © 2016 Eric. All rights reserved.
//

#import "MapViewController.h"
#import "Mapkit/Mapkit.h"

@interface MapViewController ()<CLLocationManagerDelegate, MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (strong, nonatomic) MKPointAnnotation *startAnno;
@property (strong, nonatomic) MKPointAnnotation *destinationAnno;
@property (strong, nonatomic) MKPointAnnotation *currentAnno;

@property (assign, nonatomic) CLLocationCoordinate2D startCoor;
@property (assign, nonatomic) CLLocationCoordinate2D destinationCoor;

@property (strong, nonatomic) CLLocationManager* locationManager;

@property (weak, nonatomic) IBOutlet UIButton *distanceButton;

@property (assign, nonatomic) BOOL mapIsMoving;
@property (weak, nonatomic) IBOutlet UISwitch *switcher;

@end

@implementation MapViewController

/*
 * initilize Location Manager and set up current location point annoation
 */
-(void)viewDidLoad{
    //self.startAddress.title = [self.addresses objectAtIndex:0];
    //self.destinationAddress.title = [self.addresses objectAtIndex:1];
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.delegate = self;
    self.currentAnno = [[MKPointAnnotation alloc]init];
    self.currentAnno.coordinate = CLLocationCoordinate2DMake(0.0, 0.0);
    self.currentAnno.title = @"Current Location";
    self.mapIsMoving = NO;
}

/*
 * receive two string style addresses,
 * convert them to Coordinate2D
 */
- (void) receiveAddresses:(NSArray *)addresses{
    //NSLog(@"receviedAddress");
    NSLog(@"%@, \n %@", [addresses objectAtIndex:0], [addresses objectAtIndex:1]);
    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
    
    [geocoder geocodeAddressString:[addresses objectAtIndex:0] completionHandler:
     ^(NSArray *placemarks, NSError *err){
         CLPlacemark *placemark = [placemarks firstObject];
         self.startCoor = placemark.location.coordinate;
         //NSLog(@"start: %f", self.startCoor.longitude);
         //NSLog(@"start: %f", self.startCoor.latitude);
         
         [geocoder geocodeAddressString:[addresses objectAtIndex:1] completionHandler:
          ^(NSArray *placemarks, NSError *err){
              CLPlacemark *placemark = [placemarks firstObject];
              self.destinationCoor = placemark.location.coordinate;
              //NSLog(@"destination: %f", self.destinationCoor.longitude);
          }];
     }];
    
}

/*
 * put a point annnotation on start location
 */
- (IBAction)pointToStartLocation:(id)sender {
    self.startAnno = [[MKPointAnnotation alloc]init];
    self.startAnno.coordinate = self.startCoor;
    self.startAnno.title = @"Start";
    [self.mapView addAnnotation:self.startAnno];
    [self centerMap:self.startAnno];
    [self cenerRegion:self.startAnno];
}

/*
 * put a point annotation on destination
 */
- (IBAction)pointToDestination:(id)sender {
    self.destinationAnno = [[MKPointAnnotation alloc]init];
    self.destinationAnno.coordinate = self.destinationCoor;
    self.destinationAnno.title = @"Destination";
    [self.mapView addAnnotation:self.destinationAnno];
    [self centerMap:self.destinationAnno];
    [self cenerRegion:self.destinationAnno];
}

- (void) centerMap: (MKPointAnnotation *)anno{
    [self.mapView setCenterCoordinate:anno.coordinate];
}

- (void) cenerRegion:(MKPointAnnotation *)anno{
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(anno.coordinate, 6000, 6000);
    [self.mapView setRegion:[self.mapView regionThatFits:region]];
}

- (IBAction)caculateDistance:(id)sender {
    CLLocation *start = [[CLLocation alloc]initWithLatitude:self.startCoor.latitude longitude:self.startCoor.longitude];
    CLLocation *end = [[CLLocation alloc]initWithLatitude:self.destinationCoor.latitude longitude:self.destinationCoor.longitude];
    [self.distanceButton setTitle:[NSString stringWithFormat:@"%.2fm",[start distanceFromLocation:end]] forState:UIControlStateNormal];
}

/*
 * track user's current location if switcher is on
 */
- (IBAction)switchChanged:(id)sender {
    if(self.switcher.isOn){
        self.mapView.showsUserLocation = YES;
        [self.locationManager startUpdatingLocation];
    }
    else{
        self.mapView.showsUserLocation = NO;
        [self.locationManager stopUpdatingLocation];
    }
}

/*
 * center user's current location if user doesn't move map
 */
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    self.currentAnno.coordinate = locations.lastObject.coordinate;
    if (self.mapIsMoving == NO) {
        [self centerMap:self.currentAnno];
    }
}

-(void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated{
    self.mapIsMoving = YES;
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    self.mapIsMoving = NO;
}

@end

