//
//  IProcess.h
//  Moles
//
//  Created by William Izzo on 30/07/16.
//  Copyright © 2016 wizzo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    ProcessState_Uninited,
    ProcessState_Running,
    ProcessState_Succeeded,
    ProcessState_Failed
} ProcessState;

@protocol IProcess <NSObject>
@required
- (void)onInit;
- (void)onUpdate:(NSTimeInterval)dt;
- (void)onSuccess;
- (void)onFail;
- (ProcessState)state;
@end

NS_ASSUME_NONNULL_END