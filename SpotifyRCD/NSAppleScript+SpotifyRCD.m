//
//  NSAppleScript+SpotifyRCD.m
//  SpotifyRCD
//
//  Created by Ryan Pendleton on 3/24/14.
//  Copyright (c) 2014 Inline-Studios. All rights reserved.
//

#import "NSAppleScript+SpotifyRCD.h"
#import <objc/runtime.h>

@implementation NSAppleScript (SpotifyRCD)

+ (void)load
{
	NSLog(@"SpotifyRCD loaded");
	
	unsetenv("DYLD_INSERT_LIBRARIES");
	[self jr_swizzleMethod:@selector(initWithSource:) withMethod:@selector(is_initWithSource:) error:nil];
}

- (id)is_initWithSource:(NSString *)source
{
	if([source isEqualToString:@"tell application id \"com.apple.iTunes\" to launch"])
	{
		source = @"tell application id \"com.spotify.client\" to launch";
	}
	
	return [self is_initWithSource:source];
}

@end
