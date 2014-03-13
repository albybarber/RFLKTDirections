//
//  ABDViewController.m
//  Directions
//
//  Created by Alby Barber on 25/02/2014.
//  Copyright (c) 2014 Alby Barber. All rights reserved.
//

#import "ABDViewController.h"

@interface ABDViewController ()

@end

@implementation ABDViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self.mapView setShowsUserLocation:YES];
    [self.mapView setUserTrackingMode:YES animated:YES];
    
}

// UITextField delegate method
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [self textChanged:textField];
    return NO;
}

- (IBAction)textChanged:(id)sender;
{
    NSLog(@"text changed! sent a message from %@", sender);
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];

    [geocoder geocodeAddressString:self.textField.text
                 completionHandler:^(NSArray *placemarks, NSError *error) {
                     NSLog(@"placemarks are %@" , placemarks);
                     if (placemarks.count > 0) {
                         CLPlacemark *place = placemarks[0];
                         NSLog(@"place dict is %@", place.addressDictionary);
                         [self.mapView removeAnnotations:self.mapView.annotations];

                         // put a pin on the map
                         MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
                         annotation.coordinate = CLLocationCoordinate2DMake(place.location.coordinate.latitude, place.location.coordinate.longitude);
                         annotation.title = [place.addressDictionary objectForKey:@"Street"];
                         annotation.subtitle = [place.addressDictionary objectForKey:@"City"];
                         [self.mapView addAnnotation:annotation];
                         
                         // get directions
                         MKPlacemark *placeMark = [[MKPlacemark alloc] initWithCoordinate:place.location.coordinate addressDictionary:place.addressDictionary];
                         MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placeMark];
                         [self getDirectionsTo:mapItem];
                     }
    }];
    
}

- (void)getDirectionsTo:(MKMapItem *)destination;
{
    NSLog(@"getting directions to %@", destination);
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
    request.source = [MKMapItem mapItemForCurrentLocation];
    request.destination = destination;
    request.transportType = MKDirectionsTransportTypeAutomobile;
    
    MKDirections *directions = [[MKDirections alloc] initWithRequest:request];
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
        if (error) {
            NSLog(@"error %@", error);
            UIAlertView *alert = [[UIAlertView alloc]
                                   initWithTitle:@"Error"
                                   message:error.localizedDescription
                                   delegate:nil
                                   cancelButtonTitle:nil
                                   otherButtonTitles:@"OK", nil
                                   ];
            [alert show];
            return;
        }

        MKRoute *routeDetails = response.routes.lastObject;
        NSLog(@"it will take %f seconds", routeDetails.expectedTravelTime);
        NSLog(@"got directions %@", routeDetails);
        [self.mapView addOverlay:routeDetails.polyline];

        for (int i = 0; i < routeDetails.steps.count; i++) {
            MKRouteStep *step = [routeDetails.steps objectAtIndex:i];
            NSString *newStep = step.instructions;
            NSLog(@"step is %@", newStep);

            // pin on every point
            for (int i=0; i<step.polyline.pointCount; i++) {
                MKMapPoint thisPoint = step.polyline.points[i];
                MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
                annotation.coordinate = MKCoordinateForMapPoint(thisPoint);
                annotation.title = newStep;
//                [self.mapView addAnnotation:annotation];
            }
        }
        
        [self.mapView setVisibleMapRect:routeDetails.polyline.boundingMapRect edgePadding:UIEdgeInsetsMake(20, 20, 20, 20) animated:YES];
        
    }];
    
    
}


// UIMapView delegate method
- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id < MKOverlay >)overlay
{
    MKPolylineRenderer  * routeLineRenderer = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
    routeLineRenderer.strokeColor = [UIColor redColor];
    routeLineRenderer.lineWidth = 2;
    return routeLineRenderer;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
