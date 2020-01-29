// Inspired by https://github.com/pwmckenna/react-native-motion-manager

#import "DeviceMotion.h"
#import <React/RCTBridge.h>
#import <React/RCTEventDispatcher.h>

@implementation DeviceMotion

@synthesize bridge = _bridge;
RCT_EXPORT_MODULE();

- (id) init {
    self = [super init];
    NSLog(@"DeviceMotion");

    if (self) {
        self->_motionManager = [[CMMotionManager alloc] init];
    }
    return self;
}

- (NSArray<NSString *> *)supportedEvents
{
  return @[@"DeviceMotion"];
}

+ (BOOL)requiresMainQueueSetup
{
    return NO;
}

RCT_REMAP_METHOD(isAvailable,
                 resolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject) {
    return [self isAvailableWithResolver:resolve
                                rejecter:reject];
}

- (void) isAvailableWithResolver:(RCTPromiseResolveBlock) resolve
                        rejecter:(RCTPromiseRejectBlock) reject {
    if([self->_motionManager isDeviceMotionAvailable])
    {
        /* Start the accelerometer if it is not active already */
        if([self->_motionManager isDeviceMotionActive] == NO)
        {
            resolve(@YES);
        } else {
            reject(@"-1", @"Device Motion is not active", nil);
        }
    }
    else
    {
        reject(@"-1", @"Device Motion is not available", nil);
    }
}

RCT_EXPORT_METHOD(setUpdateInterval:(double) interval) {
    NSLog(@"setDeviceMotionUpdateInterval: %f", interval);
    double intervalInSeconds = interval / 1000;

    [self->_motionManager setGyroUpdateInterval:intervalInSeconds];
}

RCT_EXPORT_METHOD(getUpdateInterval:(RCTResponseSenderBlock) cb) {
    double interval = self->_motionManager.devicemotionUpdateInterval;
    NSLog(@"getUpdateInterval: %f", interval);
    cb(@[[NSNull null], [NSNumber numberWithDouble:interval]]);
}

RCT_EXPORT_METHOD(getData:(RCTResponseSenderBlock) cb) {
    double x = self->_motionManager.devicemotion.gravity.x;
    double y = self->_motionManager.devicemotion.gravity.y;
    double z = self->_motionManager.devicemotion.gravity.z;

    NSLog(@"getData: %f, %f, %f, %f", x, y, z, timestamp);

    cb(@[[NSNull null], @{
                 @"x" : [NSNumber numberWithDouble:x],
                 @"y" : [NSNumber numberWithDouble:y],
                 @"z" : [NSNumber numberWithDouble:z],
             }]
       );
}

RCT_EXPORT_METHOD(startUpdates) {
    NSLog(@"startUpdates");
    [self->_motionManager startDeviceMotionUpdates];

    /* Receive the device motion data on this block */
    [self->_motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue mainQueue]
                                      withHandler:^(CMDeviceMotion *motionData, NSError *error)
     {
         double x = motionData.gravity.x;
         double y = motionData.gravity.y;
         double z = motionData.gravity.z;
         NSLog(@"startUpdates: %f, %f, %f", x, y, z);

         [self sendEventWithName:@"DeviceMotion" body:@{
                                                                                     @"x" : [NSNumber numberWithDouble:x],
                                                                                     @"y" : [NSNumber numberWithDouble:y],
                                                                                     @"z" : [NSNumber numberWithDouble:z]
                                                                                 }];
     }];

}

RCT_EXPORT_METHOD(stopUpdates) {
    NSLog(@"stopUpdates");
    [self->_motionManager stopDeviceMotionUpdates];
}

@end
