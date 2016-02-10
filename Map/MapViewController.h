//
//  MapViewController.h
//  Map
//
//  Created by Eric on 2016-02-10.
//  Copyright © 2016 Eric. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EZReceiveAddresses.h"

@interface MapViewController : UIViewController<EZReceiveAddresses>

-(void)receiveAddresses:(NSArray *)addresses;

@end

