//
//  NSUserDefaults+CustomRACSupport.m
//  TestTemplateProject
//
//  Created by Ben on 2017/5/23.
//  Copyright © 2017年 iOSStudio. All rights reserved.
//

#import "NSUserDefaults+CustomRACSupport.h"
#import "RACEXTScope.h"
#import "NSNotificationCenter+RACSupport.h"
#import "NSObject+RACDeallocating.h"
#import "RACChannel.h"
#import "RACScheduler.h"
#import "RACSignal+Operations.h"

@implementation NSUserDefaults (CustomRACSupport)

- (RACChannelTerminal *)customChannelTerminalForKey:(NSString *)key {
	RACChannel *channel = [RACChannel new];
	
	RACScheduler *scheduler = [RACScheduler scheduler];
	
	@weakify(self);
	[[[[[[NSNotificationCenter.defaultCenter
		rac_addObserverForName:NSUserDefaultsDidChangeNotification object:self]
		map:^(id _) {
			@strongify(self);
			return [self objectForKey:key];
		}]
		startWith:[self objectForKey:key]]
		distinctUntilChanged]
		takeUntil:self.rac_willDeallocSignal]
		subscribe:channel.leadingTerminal];
    
//    __block id lastValue = nil;
//    
//    RACSignal *signal = [[[[NSNotificationCenter.defaultCenter
//                            rac_addObserverForName:NSUserDefaultsDidChangeNotification object:self]
//                           map:^(id _) {
//                               @strongify(self);
//                               NSLog (@"user defaults: NSUserDefaultsDidChangeNotification");
//                               
//                               return [self objectForKey:key];
//                           }]
//                          startWith:[self objectForKey:key]]
//                         // Don't send values that were set on the other side of the terminal.
//                         filter:^ BOOL (id value) {
//                             NSLog (@"user defaults: filter with shedule same: %d ignoareNextValue: %d", (RACScheduler.currentScheduler == scheduler), ignoreNextValue);
//                             
//                             if (RACScheduler.currentScheduler == scheduler && ignoreNextValue) {
//                                 lastValue = value;
//                                 
//                                 ignoreNextValue = NO;
//                                 return NO;
//                             }
//                             
//                             return YES;
//                         }];
//    
//    Class class = signal.class;
//    RACSignal *afterSignal = [[signal bind:^{
//        __block BOOL initial = YES;
//        
//        return ^(id x, BOOL *stop) {
//            if (!initial && (lastValue == x || [x isEqual:lastValue])) {
//                NSLog (@"ignore same value: %@", x);
//                return [class empty];
//            }
//            
//            initial = NO;
//            lastValue = x;
//            
//            NSLog (@"save lastValue: %@", x);
//            
//            return [class return:x];
//        };
//    }] setNameWithFormat:@"[%@] -distinctUntilChanged", signal.name];
//    
//    [[afterSignal takeUntil:self.rac_willDeallocSignal]
//     subscribe:channel.leadingTerminal];

	
	[[channel.leadingTerminal
		deliverOn:scheduler]
		subscribeNext:^(id value) {
			@strongify(self);
			[self setObject:value forKey:key];
		}];
	
	return channel.followingTerminal;
}

@end
