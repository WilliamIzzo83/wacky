//
//  MoleGame.h
//  Moles
//
//  Created by William Izzo on 30/07/16.
//  Copyright © 2016 wizzo. All rights reserved.
//

#import "Process.h"
#import <UIKit/UIKit.h>

@interface MoleGame : Process
- (instancetype)initWithHolesViews:(NSArray<UIView*>*)holesViews
                       andTimeView:(UIView*)timeView;
@end
