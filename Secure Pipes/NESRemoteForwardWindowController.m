//
//  NESRemoteForwardWindowController.m
//  Secure Pipes
//
//  Created by Timothy Stonis on 2/16/14.
//  Copyright (c) 2014 Timothy Stonis. All rights reserved.
//

#import "NESRemoteForwardWindowController.h"
#import "NESUser.h"

@interface NESRemoteForwardWindowController ()

@end

@implementation NESRemoteForwardWindowController

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
        [super setType:NESConnectionRemoteForward];
    }
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

- (void) awakeFromNib {
    
    [super awakeFromNib];
    
    if (allFields == nil ) {
        allFields = [[NSArray alloc] initWithObjects:[ super nameField], [super sshUsernameField], [super sshServerField],  [super localAddressField],  [super remoteHostField],  [super sshPortField], [super localPortField],  [super remoteHostPortField], [super sshIdentityField], [super httpProxyAddressField ], [super httpProxyPortField], [super scriptField], nil];
    }
    
    if (requiredFields == nil) {
        requiredFields = [[NSArray alloc] initWithObjects: [super nameField], [super sshUsernameField],  [super sshServerField], [super localAddressField], nil];
    }
    
    
}

- (void) validateNameField:(NESPopoverTextField *) field {
    
    NSString *error = nil;
    NSString *name = [field stringValue];
    
    if ((name == nil) || ([name isEqualToString:@""]))
        error = @"A name must be supplied for the connection. Please enter a descriptive label to identify the connection such as \"Mail Edge Service\", \"Web Edge Service\", etc.";
    else if (![self checkConnectionName:name]) {
        error = [NSString stringWithFormat:@"A remote forward connection with the name \"%@\" already exists. Please select another name.",name];
    }
    
    if (error != nil) {
        if ([field isButtonHidden]) {
            NSBeep();
        }
        [field setButtonPopoverMessage:error withType:NESErrorPopover];
    } else {
        if (![field isButtonHidden]) {
            [field setButtonHidden:YES];
        }
    }
    
}

- (void) validateLocalAddressField:(NESPopoverTextField *)field {
    
    NSString *error = nil;
    NSString *name = [field stringValue];
    
    if ((name == nil) || ([name isEqualToString:@""]))
        error = @"The local host host name or IP address to forward the connection to is required. Please enter a valid host name or IP address. In some cases this may be this computer, in which case \"localhost\" can be specified. In other cases it may be a server only accessible by one of this computer's accessible networks.";
    else if (!([NESConnection isValidHost:name]||[NESConnection isValidIP:name])) {
        error = [NSString stringWithFormat:@"\"%@\" does not appear to be a valid IP or hostname. Please check your entry to make sure it is well-formed and does not contain any illegal characters.",name];
    }
    
    if (error != nil) {
        [field setButtonPopoverMessage:error withType:NESErrorPopover];
    } else {
        if (![field isButtonHidden]) {
            [field setButtonHidden:YES];
        }
    }
}

- (void) validateGeneralPortField:(NESPopoverTextField *)field {
    
    NSString *error = nil;
    NSString *name = [field stringValue];
    
    if ((name == nil) || ([name isEqualToString:@""])) {
        error = @"The default port for this field has been chosen randomly. Please confirm it is the desired port and modify if necessary.";
        if (field != [self sshPortField])
            [field setButtonPopoverMessage:error withType:NESWarningPopover];
        return;
    } else if (![NESConnection isValidPort:name]) {
        error = [NSString stringWithFormat:@"\"%@\" is not a valid port number. Please enter a number between 1 and 65535.",name];
        [field setButtonPopoverMessage:error withType:NESErrorPopover];
        return;
    } else if (([name integerValue]<1024)&&(field == [self remoteHostPortField])) {
            error = [NSString stringWithFormat:@"Please note binding to ports less than 1024 typically requires administrative (root) privileges. If the SSH account does not have privileges to bind to this port, the connection will fail."];
            [field setButtonPopoverMessage:error withType:NESWarningPopover];
        return;
    }
    
    [field setButtonHidden:YES];
    
}



- (void) validateRemoteHostField:(NESPopoverTextField *) field {
    NSString *error = nil;
    NSString *name = [field stringValue];
    
    if ((name == nil) || ([name isEqualToString:@""])) {
        error = @"If this field is left blank, \"localhost\" will be used for the default value. In this configuration, only programs local to the SSH server will have access to the forward via the loopback interface. If you would like to make the forward available to all hosts on the server's network, enter \"*\" to bind to all interfaces. Or, if you would like to bind to just one of the server's specific IP addresses, you can enter it (or it's associated hostname).";
        [field setButtonPopoverMessage:error withType:NESWarningPopover];
        return;
    } else if ((!([NESConnection isValidHost:name]||[NESConnection isValidIP:name]))&&(![name isEqualToString:@"*"])) {
        error = [NSString stringWithFormat:@"\"%@\" does not appear to be a valid IP or hostname. This value should be the hostname or IP address of an interface on the SSH server. If you want only programs local to the SSH server have access to the forward via the loopback interface, use \"localhost\" or 127.0.0.1 for the address (or leave the field blank). If you want all hosts on the server's network to have access to the forward, use \"*\".",name];
        [field setButtonPopoverMessage:error withType:NESErrorPopover];
        return;
    }
    
    [field setButtonHidden:YES];
    
}



@end
