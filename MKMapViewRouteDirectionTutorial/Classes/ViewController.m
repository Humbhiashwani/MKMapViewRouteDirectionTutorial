//
//  ViewController.m
//  MKMapViewRouteDirectionTutorial
//
//  Created by Maitrayee Ghosh on 14/09/15.
//  Copyright (c) 2015 Maitrayee Ghosh. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    sourceCoordinate=[[CLLocation alloc] initWithLatitude:37.615223 longitude:-122.389977];
    destinationCoordinate=[[CLLocation alloc] initWithLatitude:37.6253 longitude:-122.4253];
    _mMapView.delegate=(id)self;
    CLLocationCoordinate2D zoomLocation = sourceCoordinate.coordinate;
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 8.5*1609.344, 8.5*1609.344);
    MKCoordinateRegion adjustedRegion = [_mMapView regionThatFits:viewRegion];
    
    [_mMapView setRegion:adjustedRegion animated:YES];
    
    for (id<MKAnnotation> annotation in _mMapView.annotations) {
        [_mMapView removeAnnotation:annotation];
    }
    
    CustomAnnotClass *annotation1 = [[CustomAnnotClass alloc] initWithCoordinate:sourceCoordinate.coordinate andMarkTitle:@"Source" andMarkSubTitle:@"San Francisco Airport"];
    annotation1.coordinate=sourceCoordinate.coordinate;
    [_mMapView addAnnotation:annotation1];
    CustomAnnotClass *annotation2 = [[CustomAnnotClass alloc] initWithCoordinate:destinationCoordinate.coordinate andMarkTitle:@"Destination" andMarkSubTitle:@"San Bruno Ave"];
    annotation2.coordinate=destinationCoordinate.coordinate;
    [_mMapView addAnnotation:annotation2];
}

#pragma mark - Customize the Annotation View

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    static NSString *identifier = @"CustomAnnotClass";
    if ([annotation isKindOfClass:[CustomAnnotClass class]]) {
        
        MKPinAnnotationView *annotationView = (MKPinAnnotationView *) [_mMapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            
        } else {
            annotationView.annotation = annotation;
        }
        annotationView.enabled = YES;
        annotationView.canShowCallout = YES;
        annotationView.image=[UIImage imageNamed:@"map_pointer.png"];
        return annotationView;
    }
    
    return nil;
}

#pragma mark - Show Route Direction

-(void)viewDidAppear:(BOOL)animated
{
    MKPlacemark *source = [[MKPlacemark alloc]initWithCoordinate:sourceCoordinate.coordinate addressDictionary:[NSDictionary dictionaryWithObjectsAndKeys:@"",@"", nil] ];
    MKMapItem *sourceMapItem = [[MKMapItem alloc]initWithPlacemark:source];
    
    MKPlacemark *destination = [[MKPlacemark alloc]initWithCoordinate:destinationCoordinate.coordinate addressDictionary:[NSDictionary dictionaryWithObjectsAndKeys:@"",@"", nil] ];
    MKMapItem *distMapItem = [[MKMapItem alloc]initWithPlacemark:destination];
    
    
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc]init];
    [request setSource:sourceMapItem];
    [request setDestination:distMapItem];
    [request setTransportType:MKDirectionsTransportTypeAutomobile];
    
    MKDirections *direction = [[MKDirections alloc]initWithRequest:request];
    
    [direction calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
       
        if (!error) {
            for (MKRoute *route in [response routes]) {
                [_mMapView addOverlay:[route polyline] level:MKOverlayLevelAboveRoads];
            }
        }
        
    }];
    
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    
    if ([overlay isKindOfClass:[MKPolyline class]]) {
        MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
        [renderer setStrokeColor:[UIColor redColor]];
        [renderer setLineWidth:3.0];
        return renderer;
    }
    return nil;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
