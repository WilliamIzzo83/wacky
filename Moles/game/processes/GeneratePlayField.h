//
//  GeneratePlayField.h
//  Moles
//
//  Created by William Izzo on 30/07/16.
//  Copyright © 2016 wizzo. All rights reserved.
//

#import "Process.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@interface GeneratePlayField : Process
- (instancetype)initWithGameView:(UIView*)view andHolesViewRef:(NSMutableArray*)holesRef;
@end
NS_ASSUME_NONNULL_END