//
//  MRDRemoteControlServer+SpotifyRCD.m
//  SpotifyRCD
//
//  Created by Ryan Pendleton on 5/15/2020.
//  Copyright (c) 2020 Ryan Pendleton. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

#pragma mark - MRDRemoteControlServer

@interface NSObject (SpotifyRCD_MRDRemoteControlServer_Private)

- (void)_enqueueCommand:(id)command forApplication:(NSString *)application withCompletion:(id)completion;

@end

@interface NSObject (SpotifyRCD_MRDRemoteControlServer_Tweak)

- (void)rkp__enqueueCommand:(id)command forApplication:(NSString *)application withCompletion:(id)completion;

@end

@implementation NSObject (SpotifyRCD_MRDRemoteControlServer_Tweak)

- (void)rkp__enqueueCommand:(id)command forApplication:(NSString *)application withCompletion:(id)completion {
    NSLog(@"command (%@) = %@", [command class], command);
    NSLog(@"application (%@) = %@", [application class], application);
    NSLog(@"completion (%@) = %@", [completion class], completion);

    if ([application isEqualToString:@"com.apple.Music"] && [[NSRunningApplication runningApplicationsWithBundleIdentifier:@"com.apple.Music"] count] == 0) {
        NSLog(@"changing application to Spotify");
        application = @"com.spotify.client";
    }

    [self rkp__enqueueCommand:command forApplication:application withCompletion:completion];
}

@end

#pragma mark -

@interface NSObject (SpotifyRCD_Loader)
@end

@implementation NSObject (SpotifyRCD_Loader)

+ (void)load
{
    unsetenv("DYLD_INSERT_LIBRARIES");
    NSLog(@"SpotifyRCD loaded");

    Class MRDRemoteControlServer = NSClassFromString(@"MRDRemoteControlServer");

    NSError *error = nil;

    [MRDRemoteControlServer jr_swizzleMethod:@selector(_enqueueCommand:forApplication:withCompletion:) withMethod:@selector(rkp__enqueueCommand:forApplication:withCompletion:) error:&error];
    if (error) NSLog(@"Error swizzling enqueue command method: %@", error.localizedDescription);
}

@end
