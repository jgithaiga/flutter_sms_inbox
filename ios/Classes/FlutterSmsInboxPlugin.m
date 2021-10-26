#import "FlutterSmsInboxPlugin.h"
#if __has_include(<flutter_sms_inbox/flutter_sms_inbox-Swift.h>)
#import <flutter_sms_inbox/flutter_sms_inbox-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "flutter_sms_inbox-Swift.h"
#endif

@implementation FlutterSmsInboxPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterSmsInboxPlugin registerWithRegistrar:registrar];
}
@end
