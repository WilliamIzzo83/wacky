//
//  Process.m
//  Moles
//
//  Created by William Izzo on 30/07/16.
//  Copyright © 2016 wizzo. All rights reserved.
//

#import "Process.h"
@interface Process(){
    ProcessState currentState_;
}
@property (strong, nonatomic) Process* child;
@end

@implementation Process
- (void)onInit {}

- (void)onUpdate:(NSTimeInterval)dt {}

- (void)onSuccess {}

- (void)onFail {}

- (ProcessState)state {
    return self->currentState_;
}

- (void)inited {
    self->currentState_ = ProcessState_Running;
}

- (void)success {
    self->currentState_ = ProcessState_Succeeded;
}

- (void)fail {
    self->currentState_ = ProcessState_Failed;
}

- (BOOL)didEnd {
    return self->currentState_ == ProcessState_Succeeded ||
    self->currentState_ == ProcessState_Failed;
}

- (void)addChild:(Process *)process {
    if(self.child) {
        [self.child addChild:process];
        return;
    }
    
    self.child = process;
}

- (Process*)peekChild {
    return self.child;
}

- (Process*)moveChild {
    Process* movedChild = self.child;
    self.child = nil;
    return movedChild;
}

@end
