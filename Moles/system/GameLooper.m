//
//  GameLooper.m
//  Moles
//
//  Created by William Izzo on 29/07/16.
//  Copyright © 2016 wizzo. All rights reserved.
//

#import "GameLooper.h"
#import <QuartzCore/QuartzCore.h>
#import "EventBus.h"
#import "GameTickEvent.h"
#import "ProcessManager.h"

@interface GameLooper() {
    NSTimeInterval lastTimestamp;
}

- (void)displayLinkDelegate;

@property (strong, nonatomic) CADisplayLink* dlink;
@property (weak, nonatomic) EventBus* stdBus;
@property (weak, nonatomic) ProcessManager* stdProcMan;

@end

@implementation GameLooper

- (void)startUp {

    self.stdBus = [EventBus defaultBus];
    self.stdProcMan = [ProcessManager defaultProcManager];
    
    SEL dlgSelector = @selector(displayLinkDelegate);
    self.dlink = [CADisplayLink displayLinkWithTarget:self
                                             selector:dlgSelector];
    
    [self.dlink addToRunLoop:[NSRunLoop mainRunLoop]
                     forMode:NSRunLoopCommonModes];
    
    self->lastTimestamp = self.dlink.timestamp;
}

- (void)update:(NSTimeInterval)dt {}

- (void)pause {
    BOOL isPaused = self.dlink.paused;
    [self.dlink setPaused:!isPaused];
}

- (void)shutDown {
    [self.dlink invalidate];
}

- (void)displayLinkDelegate {
    GameTickEvent* tickEvt = [[GameTickEvent alloc] init];
    tickEvt.timestamp = self.dlink.timestamp;
    const NSTimeInterval dt = self.dlink.duration;
    tickEvt.dt = dt;
    [self.stdBus fireEvent:tickEvt];
    [self.stdBus update:dt];
    [self.stdProcMan update:dt];
}

@end
