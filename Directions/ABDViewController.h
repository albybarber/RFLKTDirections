//
//  ABDViewController.h
//  Directions
//
//  Created by Alby Barber on 25/02/2014.
//  Copyright (c) 2014 Alby Barber. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface ABDViewController : UIViewController

@property (nonatomic, strong) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) IBOutlet UITextField *textField;

- (IBAction)textChanged:(id)sender;


@end
