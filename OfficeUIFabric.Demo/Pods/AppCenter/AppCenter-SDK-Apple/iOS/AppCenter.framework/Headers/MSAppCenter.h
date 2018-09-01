#import <Foundation/Foundation.h>

#import "MSConstants.h"

@class MSWrapperSdk;
#if !TARGET_OS_TV
@class MSCustomProperties;
#endif

@interface MSAppCenter : NSObject

/**
 * Returns the singleton instance of MSAppCenter.
 */
+ (instancetype)sharedInstance;

/**
 * Configure the SDK with an application secret.
 *
 * @discussion This may be called only once per application process lifetime.
 * @param appSecret A unique and secret key used to identify the application.
 */
+ (void)configureWithAppSecret:(NSString *)appSecret;

/**
 * Configure the SDK.
 *
 * @discussion This may be called only once per application process lifetime.
 */
+ (void)configure;

/**
 * Configure the SDK with an application secret and an array of services to
 * start.
 *
 * @discussion This may be called only once per application process lifetime.
 * @param appSecret A unique and secret key used to identify the application.
 * @param services  Array of services to start.
 */
+ (void)start:(NSString *)appSecret withServices:(NSArray<Class> *)services;

/**
 * Start the SDK with an array of services.
 *
 * @discussion This may be called only once per application process lifetime.
 * @param services  Array of services to start.
 */
+ (void)startWithServices:(NSArray<Class> *)services;

/**
 * Start a service.
 * @discussion This may be called only once per service per application process
 * lifetime.
 * @param service  A service to start.
 */
+ (void)startService:(Class)service;

/**
 * Configure the SDK with an array of services to start from a library.
 * This will not start the service at application level, it will enable the
 * service only for the library.
 *
 * @param services Array of services to start.
 */
+ (void)startFromLibraryWithServices:(NSArray<Class> *)services;

/**
 * Check whether the SDK has already been configured or not.
 *
 * @return YES if configured, NO otherwise.
 */
+ (BOOL)isConfigured;

/**
 * Change the base URL (schema + authority + port only) used to communicate with
 * the backend.
 *
 * @param logUrl Base URL to use for backend communication.
 */
+ (void)setLogUrl:(NSString *)logUrl;

/**
 * Enable or disable the SDK as a whole. In addition to AppCenter resources, it
 * will also enable or disable all registered services.
 *
 * @param isEnabled YES to enable, NO to disable.
 * @see isEnabled
 */
+ (void)setEnabled:(BOOL)isEnabled;

/**
 * Check whether the SDK is enabled or not as a whole.
 *
 * @return YES if enabled, NO otherwise.
 * @see setEnabled:
 */
+ (BOOL)isEnabled;

/**
 * Get log level.
 *
 * @return Log level.
 */
+ (MSLogLevel)logLevel;

/**
 * Set log level.
 *
 * @param logLevel The log level.
 */
+ (void)setLogLevel:(MSLogLevel)logLevel;

/**
 * Set log level handler.
 *
 * @param logHandler Handler.
 */
+ (void)setLogHandler:(MSLogHandler)logHandler;

/**
 * Set wrapper SDK information to use when building device properties. This is
 * intended in case you are building a SDK that uses the App Center SDK under
 * the hood, e.g. our Xamarin SDK or ReactNative SDk.
 *
 * @param wrapperSdk Wrapper SDK information.
 */
+ (void)setWrapperSdk:(MSWrapperSdk *)wrapperSdk;

#if !TARGET_OS_TV
/**
 * Set the custom properties.
 *
 * @param customProperties Custom properties object.
 */
+ (void)setCustomProperties:(MSCustomProperties *)customProperties;
#endif

/**
 * Check whether the application delegate forwarder is enabled or not.
 *
 * @return YES if enabled, NO otherwise.
 *
 * @discussion The application delegate forwarder forwards messages targetting
 * your application delegate methods via swizzling to the SDK. It simplifies the
 * SDK integration but may not be suitable to any situations. For instance it
 * should be disabled if you or one of your third party SDK is doing message
 * forwarding on the application delegate. Message forwarding usually implies
 * the implementation of @see NSObject#forwardingTargetForSelector: or @see
 * NSObject#forwardInvocation: methods.
 * To disable the application delegate forwarder just add the
 * `AppCenterAppDelegateForwarderEnabled` tag to your Info.plist file and set it
 * to `0`. Then you will have to forward any application delegate needed by the
 * SDK manually.
 */
+ (BOOL)isAppDelegateForwarderEnabled;

/**
 * Get unique installation identifier.
 *
 * @return Unique installation identifier.
 */
+ (NSUUID *)installId;

/**
 * Detect if a debugger is attached to the app process. This is only invoked
 * once on app startup and can not detect if the debugger is being attached
 * during runtime!
 *
 * @return BOOL if the debugger is attached.
 */
+ (BOOL)isDebuggerAttached;

/**
 * Get the current version of AppCenter SDK.
 *
 * @return The current version of AppCenter SDK.
 */
+ (NSString *)sdkVersion;

@end
