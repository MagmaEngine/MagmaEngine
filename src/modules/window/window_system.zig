const std = @import("std");
const builtin = @import("builtin");
const null_platform = @import("null_platform.zig");
const MessageHandler = @import("../../util/message_handler.zig").MessageHandler;

pub const WindowSystem = struct {
    const Self = @This();

    // TODO: fix vulkan stuff here later
    const VoidFunction = fn () void;
    const PFN_VkGetInstanceProcAddr = fn (instance: anytype, procname: ?[]const u8) VoidFunction;

    const DisplayError = error{};
    const RequestEnum = enum {
        CREATE,
        CLOSE,
        FULLSCREEN,
        WINDOWED,
        SET_DIMENSIONS,
        SET_TITLE,
        SET_ICON,
    };

    const PlatformEnum = enum {
        ANY,
        WIN32,
        COCOA,
        WAYLAND,
        X11,
        NULL,
    };
    const Platform = struct {
        id: PlatformEnum,

        // init
        init: fn (Self) void,
        terminate: fn (Self) void,

        // monitor
        free_monitor: fn () void,
        get_monitor_pos: fn () void,
        get_monitor_content_scale: fn () void,
        get_monitor_workarea: fn () void,
        get_video_modes: fn () void,
        get_video_mode: fn () void,
        get_gamma_ramp: fn () void,
        set_gamma_ramp: fn () void,

        // window
        create_window: fn () void,
        destroy_window: fn () void,
        set_window_title: fn () void,
        set_window_icon: fn () void,
        get_window_pos: fn () void,
        set_window_pos: fn () void,
        get_window_size: fn () void,
        set_window_size: fn () void,
        set_window_size_limits: fn () void,
        set_window_aspect_ratio: fn () void,
        get_framebuffer_size: fn () void,
        get_window_frame_size: fn () void,
        get_window_content_scale: fn () void,
        iconify_window: fn () void,
        restore_window: fn () void,
        maximize_window: fn () void,
        show_window: fn () void,
        hide_window: fn () void,
        request_window_attention: fn () void,
        focus_window: fn () void,
        set_window_monitor: fn () void,
        window_focused: fn () void,
        window_iconified: fn () void,
        window_visible: fn () void,
        window_maximized: fn () void,
        window_hovered: fn () void,
        framebuffer_transparent: fn () void,
        get_window_opacity: fn () void,
        set_window_resizable: fn () void,
        set_window_decorated: fn () void,
        set_window_floating: fn () void,
        set_window_opacity: fn () void,
        set_window_mouse_passthrough: fn () void,
        poll_events: fn () void,
        wait_events: fn () void,
        wait_events_timeout: fn () void,
        post_empty_event: fn () void,

        //// EGL
        //get_EGL_platform: fn () void,
        //get_EGL_native_display: fn () void,
        //get_EGL_native_window: fn () void,

        //// vulkan
        //get_required_instance_extensions: fn () void,
        //get_physical_device_present_support: fn () void,
        //create_window_surface: fn () void,
    };
    const PlatformError = error{
        XDGSessionTypeEnvarNotSet,
        DisplayEnvarNotSet,
        UnsupportedPlatform,
        UndesiredPlatform,
    };
    const VideoMode = struct {
        /// The width, in screen coordinates, of the video mode.
        width: u32,
        /// The height, in screen coordinates, of the video mode.
        height: u32,
        /// The bit depth of the red channel of the video mode.
        redBits: u32,
        /// The bit depth of the green channel of the video mode.
        greenBits: u32,
        /// The bit depth of the blue channel of the video mode.
        blueBits: u32,
        /// The refresh rate, in Hz, of the video mode.
        refreshRate: u32,
    };

    const GammaRamp = struct {
        red: [*]u16,
        green: [*]u16,
        blue: [*]u16,
        size: usize,
    };

    const Monitor = struct {
        name: []u8,
        user_pointer: ?*anyopaque,
        widthMM: u32,
        heightMM: u32,
        //window: window.Window, // The window whose video mode is current on this monitor
        modes: []const VideoMode,
        current_mode: usize,
        original_ramp: GammaRamp,
        current_ramp: GammaRamp,
        // TODO: union this as implementation goes on
        //monitor_state: null_monitor.Monitor,
    };

    const WindowSystemHints = struct {
        init: InitHints,
    };
    const InitHints = struct {
        hat_buttons: bool = true,
        platform_id: PlatformEnum = .ANY,
        vulkan_loader: ?PFN_VkGetInstanceProcAddr = null,
        ns: struct {
            menubar: bool = true,
            chdir: bool = true,
        },
        x11: struct {
            xcbVulkanSurface: bool = true,
        },
        wl: struct {
            //libdecorMode: WAYLAND_PREFER_LIBDECOR = .WAYLAND_PREFER_LIBDECOR,
        },
    };

    const WindowMessageHandler = MessageHandler(RequestEnum, void);

    allocator: std.mem.Allocator,
    message_handler: WindowMessageHandler,
    platform: Platform,
    hints: WindowSystemHints,
    monitors: std.ArrayList(Monitor),
    // TODO: Add an array of windows

    // TODO: need to pass in hints and an allocator
    pub fn init() !WindowSystem {
        var allocator = std.heap.GeneralPurposeAllocator(.{}){};
        var window_system = WindowSystem{
            .allocator = allocator.allocator(),
            .message_handler = WindowMessageHandler.init(allocator.allocator()),
            .monitors = std.ArrayList(Monitor).init(allocator.allocator()),
            .hints = .{
                .init = .{
                    .ns = .{},
                    .x11 = .{},
                    .wl = .{},
                },
            },
            .platform = undefined,
        };
        window_system.platform = try setup_platform(window_system.hints.init.platform_id);
        return window_system;
    }

    pub fn deinit(self: *WindowSystem) void {
        _ = self;
    }

    fn setup_platform(desired_platform: PlatformEnum) PlatformError!Platform {
        const target = switch (builtin.os.tag) {
            .linux, .freebsd, .netbsd, .openbsd, .dragonfly, .solaris => {
                if (std.os.getenv("XDG_SESSION_TYPE") == null) {
                    return PlatformError.XDGSessionTypeEnvarNotSet;
                } else if (std.os.getenv("WAYLAND_DISPLAY") != null) {
                    .WAYLAND;
                } else if (std.os.getenv("DISPLAY") != null) {
                    .X11;
                } else {
                    return PlatformError.DisplayEnvarNotSet;
                }
            },
            .windows => .WIN32,
            .macos, .ios => .COCOA,
            else => {
                return PlatformError.UnsupportedPlatform;
            },
        };

        switch (desired_platform) {
            .ANY => {},
            .NULL => target = .NULL,
            else => if (target != desired_platform) PlatformError.UndesiredPlatform,
        }

        return switch (target) {
            .NULL => null_platform.setup(),
            //.WIN32 => win32_platform.setup(),
            //.COCOA => cocoa_platform.setup(),
            //.WAYLAND => wayland_platform.setup(),
            //.X11 => x11_platform.setup(),
            else => PlatformError.UnsupportedPlatform,
        };
    }
};
