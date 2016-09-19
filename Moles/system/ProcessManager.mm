//
//  ProcessManager.m
//  Moles
//
//  Created by William Izzo on 30/07/16.
//  Copyright © 2016 wizzo. All rights reserved.
//

#import "ProcessManager.h"
#include <list>

typedef std::list<Process*> PMCProcessList;


@interface ProcessManager() {
    PMCProcessList processList;
}

@end

@implementation ProcessManager

- (void)startUp {}

- (void)addProcess:(Process *)process {
    self->processList.push_back(process);
}

- (void)update:(NSTimeInterval)dt {
    
    auto it = self->processList.begin();
    while (it != self->processList.end()) {
        Process* process = *it;
        
        if([process state] == ProcessState_Uninited) {
            [process onInit];
            [process inited];
        }
        
        
        
        if (![process didEnd]) {
            [process onUpdate:dt];
            ++it;
            continue;
        }
        
        if ([process state] == ProcessState_Succeeded) {
            [process onSuccess];
            Process* child = [process moveChild];
            if (child) {
                self->processList.push_back(child);
            }
        }
        
        it = self->processList.erase(it);
    }
    
}

- (void)pause {}

- (void)shutDown {
    self->processList.clear();
}
@end

@implementation ProcessManager(Shared)

+ (ProcessManager*)defaultProcManager {
    static ProcessManager* defaultProcMan = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultProcMan = [[ProcessManager alloc] init];
        [defaultProcMan startUp];
    });
    
    return defaultProcMan;
}

@end
