//
//  ABDSettingsController.m
//  Directions
//
//  Created by Alby Barber on 11/03/2014.
//  Copyright (c) 2014 Alby Barber. All rights reserved.
//

#import "ABDSettingsController.h"

@interface ABDSettingsController ()

@end

@implementation ABDSettingsController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doneButtonPressed
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)connectButtonPressed
{
    NSLog(@"Connecting...");
    // create the connection params.
    WFConnectionParams* params = [[WFHardwareConnector sharedConnector].settings connectionParamsForSensorType:WF_SENSORTYPE_DISPLAY];
    params.networkType = WF_NETWORKTYPE_ANY;

    self.sensorConnection = [[WFHardwareConnector sharedConnector] requestSensorConnection:params];
    self.sensorConnection.delegate = self;

}

- (void)connectionDidTimeout:(WFSensorConnection*)connectionInfo;
{
    NSLog(@"connection timed out");
}

- (void)connection:(WFSensorConnection*)connectionInfo stateChanged:(WFSensorConnectionStatus_t)connState;
{
    NSLog(@"connection state changes!!! %d", connState);
}

- (void) connection:(WFSensorConnection*)connectionInfo rejectedByDeviceNamed:(NSString*) deviceName appAlreadyConnected:(NSString*) appName;
{
    NSLog(@"connection rejected");
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
