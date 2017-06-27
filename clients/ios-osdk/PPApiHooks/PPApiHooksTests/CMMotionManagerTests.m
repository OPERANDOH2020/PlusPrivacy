//
//  CMMotionManagerTests.m
//  PPApiHooks
//
//  Created by Costin Andronache on 5/8/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CMMotionManager+PPHOOK.h"
#import "TestDispatcher.h"
#import "CommonBaseTest.h"
#import <objc/runtime.h>

@interface CMMotionManagerTests : CommonBaseTest
@property (strong, nonatomic) CMMotionManager *motionManager;
@end

@implementation CMMotionManagerTests

- (void)setUp {
    [super setUp];
    
    Method *methodListIterator = class_copyMethodList([PPEventDispatcher class], NULL);
    while (*methodListIterator != NULL) {
        NSLog(@"%s", sel_getName(method_getName(*methodListIterator)));
        methodListIterator += 1;
    }
    
    if (!self.motionManager) {
        self.motionManager = [[CMMotionManager alloc] init];
        id motionManagerClass = [CMMotionManager class];
        CALL_PREFIXED(motionManagerClass, setEventsDispatcher:self.testDispatcher);
    }
}


-(void)testSetAccelerometerUpdateInterval_keepsCorrectValueAndIdentifiers {
    
    void(^execution)(NSTimeInterval) = ^void(NSTimeInterval updateInterval){
        XCTestExpectation *expectation = [self expectationWithDescription:@"Expected values to be present on the event"];
        
        __Weak(self);
        
        self.testDispatcher.testEventHandler = ^void(PPEvent *event){
            
            [weakself assertDictionary:event.eventData containsValuesForKeys:@[kPPConfirmationCallbackBlock, kPPMotionManagerAccelerometerUpdateIntervalValue]];
            
            [weakself assertIdentifier:event.eventIdentifier equals:PPEventIdentifierMake(PPMotionManagerEvent, EventMotionManagerSetAccelerometerUpdateInterval)];
            
            weak_XCTAssert(doublesApproximatelyEqual(updateInterval, [event.eventData[kPPMotionManagerAccelerometerUpdateIntervalValue] doubleValue]), @"Expected update value from event data to be the same as updateInterval!");
            
            
            [expectation fulfill];
        };
        
        self.motionManager.accelerometerUpdateInterval = updateInterval;
        [self waitForExpectationsWithTimeout:5.0 handler:nil];
    };
    execution(1);
    execution(8);
    execution(1003);
}

-(void)testSetAccelerometerUpdateInterval_setsModifiedValue {    
    void(^execution)(NSTimeInterval, NSTimeInterval) = ^void(NSTimeInterval firstUpdateInterval, NSTimeInterval modifiedValue){
        
        XCTAssert(!doublesApproximatelyEqual(firstUpdateInterval, modifiedValue));
        self.testDispatcher.testEventHandler = ^void(PPEvent *event){
            event.eventData[kPPMotionManagerAccelerometerUpdateIntervalValue] = @(modifiedValue);
            void(^confirmation)()  = event.eventData[kPPConfirmationCallbackBlock];
            confirmation();
        };
        
        self.motionManager.accelerometerUpdateInterval = firstUpdateInterval;
        XCTAssert(doublesApproximatelyEqual(modifiedValue, self.motionManager.accelerometerUpdateInterval), @"Expected to set modified value!");
    };
    
    execution(1, 5);
    execution(14, 10);
    execution(5, 100);
}


-(void)testSetGyroUpdateInterval_keepsCorrectValuesAndIdentifier{
    
    void(^execution)(NSTimeInterval) = ^void(NSTimeInterval updateInterval){
        __Weak(self);
        XCTestExpectation *expectation = [self expectationWithDescription:@""];
        
        
        self.testDispatcher.testEventHandler = ^void(PPEvent *event){
            [weakself assertIdentifier:event.eventIdentifier equals:PPEventIdentifierMake(PPMotionManagerEvent, EventMotionManagerSetGyroUpdateInterval)];
            [weakself assertDictionary:event.eventData containsValuesForKeys:@[kPPConfirmationCallbackBlock, kPPMotionManagerGyroUpdateIntervalValue]];
            
            weak_XCTAssert(doublesApproximatelyEqual(updateInterval, [event.eventData[kPPMotionManagerGyroUpdateIntervalValue] doubleValue]));
            [expectation fulfill];
        };
        
        self.motionManager.gyroUpdateInterval = updateInterval;
        [self waitForExpectationsWithTimeout:5.0 handler:nil];
    };
    
    execution(10);
    execution(7);
    execution(10024);
}


-(void)testSetGyroUpdateInterval_setsModifiedValue{
    
    void (^execution)(NSTimeInterval initialInterval, NSTimeInterval modifiedInterval) = ^void(NSTimeInterval initialInterval, NSTimeInterval modifiedInterval){
        
        XCTAssert(!doublesApproximatelyEqual(initialInterval, modifiedInterval));
        self.testDispatcher.testEventHandler = ^void(PPEvent *event){
            event.eventData[kPPMotionManagerGyroUpdateIntervalValue] = @(modifiedInterval);
            void (^confirmation)() = event.eventData[kPPConfirmationCallbackBlock];
            confirmation();
        };
        
        self.motionManager.gyroUpdateInterval = initialInterval;
        XCTAssert(doublesApproximatelyEqual(self.motionManager.gyroUpdateInterval, modifiedInterval));
    };
    
    execution(10, 3);
    execution(3, 10);
    execution(18, 29);
}


-(void)testSetMagnetometerDeviceUpdateInterval_keepsCorrectValueAndIdentifier {
    
    void(^execution)(NSTimeInterval) = ^void(NSTimeInterval updateInterval){
        __Weak(self);
        
        XCTestExpectation *expectation = [self expectationWithDescription:@""];
        self.testDispatcher.testEventHandler = ^void(PPEvent *event){
            [weakself assertIdentifier:event.eventIdentifier equals:PPEventIdentifierMake(PPMotionManagerEvent, EventMotionManagerSetMagnetometerUpdateInterval)];
            [weakself assertDictionary:event.eventData containsValuesForKeys:@[kPPConfirmationCallbackBlock, kPPMotionManagerMagnetometerUpdateIntervalValue]];
            
            weak_XCTAssert(doublesApproximatelyEqual(updateInterval, [event.eventData[kPPMotionManagerMagnetometerUpdateIntervalValue] doubleValue]));
            
            [expectation fulfill];
        };
        
        self.motionManager.magnetometerUpdateInterval = updateInterval;
        [self waitForExpectationsWithTimeout:4.0 handler:nil];
    };
    
    execution(4);
    execution(1003);
    execution(20);
}

-(void)testSetMagnetometerDeviceUpdateInterval_setsModifiedValue{
    
    void(^execution)(NSTimeInterval, NSTimeInterval) = ^void(NSTimeInterval initialValue, NSTimeInterval modifiedValue) {
        XCTAssert(!doublesApproximatelyEqual(initialValue, modifiedValue));
        
        self.testDispatcher.testEventHandler = ^void(PPEvent *event){
            event.eventData[kPPMotionManagerMagnetometerUpdateIntervalValue] = @(modifiedValue);
            void(^confBlock)() = event.eventData[kPPConfirmationCallbackBlock];
            confBlock();
        };
        
        self.motionManager.magnetometerUpdateInterval = initialValue;
        XCTAssert(doublesApproximatelyEqual(modifiedValue, self.motionManager.magnetometerUpdateInterval));
    };
    
    execution(1, 5);
    execution(100, 3);
    execution(77, 5445);
}


-(void)testSetDeviceMotionUpdateInterval_keepsCorrectValueAndIdentifier{
    void(^execution)(NSTimeInterval) = ^void(NSTimeInterval updateInterval){
        __Weak(self);
        XCTestExpectation *expectaction = [self expectationWithDescription:@""];
        self.testDispatcher.testEventHandler = ^void(PPEvent *event){
            [weakself assertIdentifier:event.eventIdentifier equals:PPEventIdentifierMake(PPMotionManagerEvent, EventMotionManagerSetDeviceMotionUpdateInterval)];
            [weakself assertDictionary:event.eventData containsValuesForKeys:@[kPPConfirmationCallbackBlock,
                                                                               kPPMotionManagerDeviceMotionUpdateIntervalValue]];
            
            weak_XCTAssert(doublesApproximatelyEqual(updateInterval, [event.eventData[kPPMotionManagerDeviceMotionUpdateIntervalValue] doubleValue]));
            
            [expectaction fulfill];
        };
        
        self.motionManager.deviceMotionUpdateInterval = updateInterval;
        [self waitForExpectationsWithTimeout:1.0 handler:nil];
    };
    
    execution(5);
    execution(20);
    execution(14);
}

-(void)testSetDeviceMotionInterval_setsModifiedValue{
    void(^execution)(NSTimeInterval, NSTimeInterval) = ^void(NSTimeInterval initialValue, NSTimeInterval modifiedValue){
        XCTAssert(!doublesApproximatelyEqual(initialValue, modifiedValue));
        self.testDispatcher.testEventHandler = ^void(PPEvent *event){
            event.eventData[kPPMotionManagerDeviceMotionUpdateIntervalValue] = @(modifiedValue);
            void(^confBlock)() = event.eventData[kPPConfirmationCallbackBlock];
            confBlock();
        };
        
        self.motionManager.deviceMotionUpdateInterval = initialValue;
        XCTAssert(doublesApproximatelyEqual(self.motionManager.deviceMotionUpdateInterval, modifiedValue));
    };
    
    execution(10, 44);
    execution(54, 71);
    execution(1.3, 5.5);
}

-(void)testStartMagnetometerUpdates_keepsCorrectIdentifier{
    __Weak(self);
    
    XCTestExpectation *expectation = [self expectationWithDescription:@""];
    self.testDispatcher.testEventHandler = ^void(PPEvent *event){
        [weakself assertIdentifier:event.eventIdentifier equals:PPEventIdentifierMake(PPMotionManagerEvent, EventMotionManagerStartMagnetometerUpdates)];
        [weakself assertDictionary:event.eventData containsValuesForKeys:@[kPPConfirmationCallbackBlock]];
        [expectation fulfill];
    };
    
    [self.motionManager startMagnetometerUpdates];
    [self waitForExpectationsWithTimeout:1.0 handler:nil];
}

-(void)testStartMagnetometerUpdatesToQueue_keepsCorrectValuesAndIdentifier {
    __Weak(self);
    XCTestExpectation *expectaction = [self expectationWithDescription:@""];
    
    NSOperationQueue *opQueue = [[NSOperationQueue alloc] init];
    void(^handler)(CMMagnetometerData*, NSError*) = ^void(CMMagnetometerData* data, NSError* error){
        
    };
    
    self.testDispatcher.testEventHandler = ^void(PPEvent *event){
        [weakself assertIdentifier:event.eventIdentifier equals:PPEventIdentifierMake(PPMotionManagerEvent, EventMotionManagerStartMagnetometerUpdatesToQueueUsingHandler)];
        
        [weakself assertDictionary:event.eventData containsValuesForKeys:@[kPPMotionManagerMagnetometerHandler,
                                                                           kPPMotionManagerUpdatesQueue,
                                                                           kPPConfirmationCallbackBlock]];
        void(^evHandler)(CMMagnetometerData*, NSError*) = event.eventData[kPPMotionManagerMagnetometerHandler];
        NSOperationQueue *evQueue = event.eventData[kPPMotionManagerUpdatesQueue];
        weak_XCTAssert(evHandler == handler);
        weak_XCTAssert(evQueue == opQueue);
        [expectaction fulfill];
    };
    
    [self.motionManager startMagnetometerUpdatesToQueue:opQueue withHandler:handler];
    [self waitForExpectationsWithTimeout:1.0 handler:nil];
}


-(void)testStartAccelerometerUpdates_keepsCorrectIdentifier {
    __Weak(self);
    XCTestExpectation *expectation = [self expectationWithDescription:@""];
    
    self.testDispatcher.testEventHandler = ^void(PPEvent *event){
        [weakself assertIdentifier:PPEventIdentifierMake(PPMotionManagerEvent, EventMotionManagerStartAccelerometerUpdates) equals:event.eventIdentifier];
        
        [weakself assertDictionary:event.eventData containsValuesForKeys:@[kPPConfirmationCallbackBlock]];
        [expectation fulfill];
    };
    
    [self.motionManager startAccelerometerUpdates];
    [self waitForExpectationsWithTimeout:1.0 handler:nil];
}


-(void)testStartAccelerometerUpdatesToQueue_keepsCorrectValuesAndIdentifier {
    __Weak(self);
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    CMAccelerometerHandler handler = ^void(CMAccelerometerData* data, NSError *error){
        
    };
    
    XCTestExpectation *expectation = [self expectationWithDescription:@""];
    self.testDispatcher.testEventHandler = ^void(PPEvent *event){
        [weakself assertIdentifier:event.eventIdentifier equals:PPEventIdentifierMake(PPMotionManagerEvent, EventMotionManagerStartAccelerometerUpdatesToQueueUsingHandler)];
        
        CMAccelerometerHandler evHandler = event.eventData[kPPMotionManagerAccelerometerHandler];
        NSOperationQueue *evQueue = event.eventData[kPPMotionManagerUpdatesQueue];
        weak_XCTAssert(evHandler == handler);
        weak_XCTAssert(queue == evQueue);
        [weakself assertDictionary:event.eventData containsValuesForKeys:@[kPPConfirmationCallbackBlock]];
        [expectation fulfill];
    };
    
    [self.motionManager startAccelerometerUpdatesToQueue:queue withHandler:handler];
    [self waitForExpectationsWithTimeout:1.0 handler:nil];
}


-(void)testStartGyroUpdates_keepsCorrectIdentifierAndValues{
    __Weak(self);
    XCTestExpectation *expectation = [self expectationWithDescription:@""];
    self.testDispatcher.testEventHandler = ^void(PPEvent *event){
        [weakself assertDictionary:event.eventData containsValuesForKeys:@[kPPConfirmationCallbackBlock]];
        [weakself assertIdentifier:event.eventIdentifier equals:PPEventIdentifierMake(PPMotionManagerEvent, EventMotionManagerStartGyroUpdates)];
        [expectation fulfill];
    };
    
    [self.motionManager startGyroUpdates];
    [self waitForExpectationsWithTimeout:1.0 handler:nil];
}


-(void)testStartGyroUpdatesToQueue_keepsCorrectIdentifierAndValues{
    __Weak(self);
    XCTestExpectation *expectation = [self expectationWithDescription:@""];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    CMGyroHandler handler = ^void(CMGyroData *data, NSError *error){
        
    };
    
    self.testDispatcher.testEventHandler = ^void(PPEvent *event){
        [weakself assertIdentifier:event.eventIdentifier equals:PPEventIdentifierMake(PPMotionManagerEvent, EventMotionManagerStartGyroUpdatesToQueueUsingHandler)];
        
        [weakself assertDictionary:event.eventData containsValuesForKeys:@[kPPConfirmationCallbackBlock,
                                                                           kPPMotionManagerUpdatesQueue,
                                                                           kPPMotionManagerGyroHandler]];
        NSOperationQueue *evQueue = event.eventData[kPPMotionManagerUpdatesQueue];
        CMGyroHandler evHandler = event.eventData[kPPMotionManagerGyroHandler];
        weak_XCTAssert(evQueue == queue);
        weak_XCTAssert(handler == evHandler);
        [expectation fulfill];
    };
    
    [self.motionManager startGyroUpdatesToQueue:queue withHandler:handler];
    [self waitForExpectationsWithTimeout:1.0 handler:nil];
}


-(void)testStartDeviceMotionUpdates_keepsCorrectIdentifierAndValues{
    __Weak(self);
    XCTestExpectation *expectation = [self expectationWithDescription:@""];
    self.testDispatcher.testEventHandler = ^void(PPEvent *event){
        [weakself assertIdentifier:event.eventIdentifier equals:PPEventIdentifierMake(PPMotionManagerEvent, EventMotionManagerStartDeviceMotionUpdates)];
        [weakself assertDictionary:event.eventData containsValuesForKeys:@[kPPConfirmationCallbackBlock]];
        [expectation fulfill];
    };
    
    [self.motionManager startDeviceMotionUpdates];
    [self waitForExpectationsWithTimeout:1.0 handler:nil];
}

-(void)testStartDeviceMotionUpdatesWithReferenceFrame_keepsCorrectIdentifierAndValues{
    __Weak(self);
    void(^execution)(CMAttitudeReferenceFrame) = ^void(CMAttitudeReferenceFrame frame){
        XCTestExpectation *expectation = [self expectationWithDescription:@""];
        self.testDispatcher.testEventHandler = ^void(PPEvent *e){
            [weakself assertIdentifier:e.eventIdentifier equals:PPEventIdentifierMake(PPMotionManagerEvent, EventMotionManagerStartDeviceMotionUpdatesUsingReferenceFrame)];
            [weakself assertDictionary:e.eventData containsValuesForKeys:@[kPPConfirmationCallbackBlock,
                                                                           kPPDeviceMotionReferenceFrameValue]];
            CMAttitudeReferenceFrame evFrame = [e.eventData[kPPDeviceMotionReferenceFrameValue] integerValue];
            weak_XCTAssert(evFrame == frame);
            [expectation fulfill];
        };
        [self.motionManager startDeviceMotionUpdatesUsingReferenceFrame:frame];
        [self waitForExpectationsWithTimeout:1.0 handler:nil];
    };
    
    execution(CMAttitudeReferenceFrameXMagneticNorthZVertical);
    execution(CMAttitudeReferenceFrameXArbitraryZVertical);
}

-(void)testStartDeviceMotionUpdatesToQueue_keepsCorrectIdentifierAndValues{
    __Weak(self);
    
    void(^execution)(CMAttitudeReferenceFrame) = ^void(CMAttitudeReferenceFrame frame){
        XCTestExpectation *expectation = [self expectationWithDescription:@""];
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        CMDeviceMotionHandler handler = ^void(CMDeviceMotion *dm, NSError *error){
            
        };
        
        self.testDispatcher.testEventHandler = ^void(PPEvent *event){
            [weakself assertIdentifier:event.eventIdentifier equals:PPEventIdentifierMake(PPMotionManagerEvent, EventMotionManagerStartDeviceMotionUpdatesUsingReferenceFrameToQueueUsingHandler)];
            
            [weakself assertDictionary:event.eventData containsValuesForKeys:@[kPPConfirmationCallbackBlock,
                                                                               kPPMotionManagerUpdatesQueue,
                                                                               kPPMotionManagerDeviceMotionHandler,
                                                                               kPPDeviceMotionReferenceFrameValue]];
            CMDeviceMotionHandler evHandler = event.eventData[kPPMotionManagerDeviceMotionHandler];
            NSOperationQueue *evQueue = event.eventData[kPPMotionManagerUpdatesQueue];
            CMAttitudeReferenceFrame evFrame = [event.eventData[kPPDeviceMotionReferenceFrameValue] integerValue];
            
            weak_XCTAssert(evFrame == frame);
            weak_XCTAssert(evQueue == queue);
            weak_XCTAssert(evHandler == handler);
            
            [expectation fulfill];
        };
        
        [self.motionManager startDeviceMotionUpdatesUsingReferenceFrame:frame toQueue:queue withHandler:handler];
        [self waitForExpectationsWithTimeout:1.0 handler:nil];
    };
    
    execution(CMAttitudeReferenceFrameXArbitraryZVertical);
    execution(CMAttitudeReferenceFrameXArbitraryCorrectedZVertical);
    execution(CMAttitudeReferenceFrameXMagneticNorthZVertical);
}


@end
