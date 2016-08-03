//
//  InputManager.h
//  Moles
//
//  Created by William Izzo on 29/07/16.
//  Copyright © 2016 wizzo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ISystem.h"
#import "IEvent.h"

@interface InputManager : NSObject<ISystem>
- (void)enqueueInputEvent:(id<IEvent>)event;
@end
