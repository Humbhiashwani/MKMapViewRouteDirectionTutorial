//
//  ViewController.h
//  MKMapViewRouteDirectionTutorial
//
//  Created by Maitrayee Ghosh on 14/09/15.
//  Copyright (c) 2015 Maitrayee Ghosh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "CustomAnnotClass.h"

@interface ViewController : UIViewController
{
    CLLocation *sourceCoordinate;
    CLLocation *destinationCoordinate;
}
@property (weak, nonatomic) IBOutlet MKMapView *mMapView;
@end

