//
//  ProcessManager.h
//  Moles
//
//  Created by William Izzo on 30/07/16.
//  Copyright © 2016 wizzo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ISystem.h"
#import "Process.h"

@interface ProcessManager : NSObject<ISystem>
- (void)addProcess:(Process*)process;
@end

@interface ProcessManager(Shared)
+ (ProcessManager*)defaultProcManager;
@end
