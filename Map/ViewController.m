//
//  ViewController.m
//  Map
//
//  Created by Eric on 2016-02-10.
//  Copyright © 2016 Eric. All rights reserved.
//

#import "ViewController.h"
#import "EZReceiveAddresses.h"
#import "Mapkit/Mapkit.h"


@interface ViewController () <CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *startAddressField;
@property (weak, nonatomic) IBOutlet UITextField *destinationAddressField;

@property (strong, nonatomic)CLLocationManager * locationManager;
@property (strong, nonatomic)CLGeocoder *geocoder;

@property (strong, nonatomic)NSString *currentAddress;

@end

@implementation ViewController


/*
 * initilize Location Manger and Geocoder,
 * update location
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager requestWhenInUseAuthorization];
    self.geocoder = [[CLGeocoder alloc]init];
    [self.locationManager startUpdatingLocation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 * updaate location after user returns to this view from map view
 */
-(void)viewWillAppear:(BOOL)animated{
    [self.locationManager startUpdatingLocation];
}

/*
 * get current location
 */
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(nonnull NSArray<CLLocation *> *)locations{
    [self.geocoder reverseGeocodeLocation:[locations lastObject] completionHandler:
        ^(NSArray *placemarks, NSError *error) {
            CLPlacemark *placemark=[placemarks firstObject];

            self.currentAddress = [NSString stringWithFormat:@"%@, %@, %@ %@, %@",
                                 placemark.name,
                                 placemark.locality,
                                 placemark.administrativeArea,
                                 placemark.postalCode,
                                 placemark.country];
            //NSLog(@"%@", self.currentAddress);
        }
     ];
    [self.locationManager stopUpdatingLocation];
}
 // It is 2 am now. Suddenly, I heared a big sound "pong!".
 // It seems my roommate fell out of bed. haha.
 // I hope she is fine.
 
/*
 * set current location as defualt locations of start and destination
 * send start location and destination to map view,
 */
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    id<EZReceiveAddresses> child = (id<EZReceiveAddresses>)[segue destinationViewController];
    
    NSArray *addresses = nil;
    
    if(self.startAddressField.text.length == 0 || self.destinationAddressField.text.length == 0){
        //addresses = @[self.currentAddress, self.currentAddress];
        NSLog(@"empty") ;
    }
    else{
     
        addresses = @[self.startAddressField.text, self.destinationAddressField.text];
    }
    
    [child receiveAddresses:addresses];
}


@end
