//
//  ABDSettingsController.h
//  Directions
//
//  Created by Alby Barber on 11/03/2014.
//  Copyright (c) 2014 Alby Barber. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WFConnector/WFConnector.h>

@interface ABDSettingsController : UIViewController <WFSensorConnectionDelegate>

@property (nonatomic, retain) WFSensorConnection *sensorConnection;

@end
