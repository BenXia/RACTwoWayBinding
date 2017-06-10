//
//  NSUserDefaults+CustomRACSupport.h
//  TestTemplateProject
//
//  Created by Ben on 2017/5/23.
//  Copyright © 2017年 iOSStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RACChannelTerminal;

@interface NSUserDefaults (CustomRACSupport)

/// Creates and returns a terminal for binding the user defaults key.
///
/// **Note:** The value in the user defaults is *asynchronously* updated with
/// values sent to the channel.
///
/// key - The user defaults key to create the channel terminal for.
///
/// Returns a channel terminal that sends the value of the user defaults key
/// upon subscription, sends an updated value whenever the default changes, and
/// updates the default asynchronously with values it receives.
- (RACChannelTerminal *)customChannelTerminalForKey:(NSString *)key;

@end
