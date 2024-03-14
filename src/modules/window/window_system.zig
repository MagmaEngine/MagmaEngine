const std = @import("std");
const builtin = @import("builtin");
const null_platform = @import("null_platform.zig");
//const x11_platform = @import("x11_platform.zig");
const MessageHandler = @import("../../util/message_handler.zig").MessageHandler;

pub const WindowSystem = struct {
    const Self = @This();

    // TODO: fix vulkan stuff here later
    //const VoidFunction = fn () void;
    //const PFN_VkGetInstanceProcAddr = fn (instance: anytype, procname: ?[]const u8) VoidFunction;

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

    pub const PlatformEnum = enum {
        WIN32,
        COCOA,
        WAYLAND,
        X11,
        NULL,
    };
    pub const Platform = struct {
        id: PlatformEnum,

        // init
        init: *const fn (*Self) std.mem.Allocator.Error!void,
        terminate: *const fn (*Self) void,

        // monitor
        free_monitor: *const fn () void,
        get_monitor_pos: *const fn () void,
        get_monitor_content_scale: *const fn () void,
        get_monitor_workarea: *const fn () void,
        get_video_modes: *const fn () void,
        get_video_mode: *const fn () VideoMode,
        get_gamma_ramp: *const fn () void,
        set_gamma_ramp: *const fn () void,

        // window
        create_window: *const fn () void,
        destroy_window: *const fn () void,
        set_window_title: *const fn () void,
        set_window_icon: *const fn () void,
        get_window_pos: *const fn () void,
        set_window_pos: *const fn () void,
        get_window_size: *const fn () void,
        set_window_size: *const fn () void,
        set_window_size_limits: *const fn () void,
        set_window_aspect_ratio: *const fn () void,
        get_framebuffer_size: *const fn () void,
        get_window_frame_size: *const fn () void,
        get_window_content_scale: *const fn () void,
        iconify_window: *const fn () void,
        restore_window: *const fn () void,
        maximize_window: *const fn () void,
        show_window: *const fn () void,
        hide_window: *const fn () void,
        request_window_attention: *const fn () void,
        focus_window: *const fn () void,
        set_window_monitor: *const fn () void,
        window_focused: *const fn () void,
        window_iconified: *const fn () void,
        window_visible: *const fn () void,
        window_maximized: *const fn () void,
        window_hovered: *const fn () void,
        framebuffer_transparent: *const fn () void,
        get_window_opacity: *const fn () void,
        set_window_resizable: *const fn () void,
        set_window_decorated: *const fn () void,
        set_window_floating: *const fn () void,
        set_window_opacity: *const fn () void,
        set_window_mouse_passthrough: *const fn () void,
        poll_events: *const fn () void,
        wait_events: *const fn () void,
        wait_events_timeout: *const fn () void,
        post_empty_event: *const fn () void,

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
    pub const VideoMode = struct {
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

    pub const Monitor = struct {
        name: []const u8,
        //user_pointer: ?*anyopaque,
        widthMM: f32,
        heightMM: f32,
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
        //vulkan_loader: ?PFN_VkGetInstanceProcAddr = null,
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
        window_system.platform = try setup_platform();
        return window_system;
    }

    pub fn deinit(self: *WindowSystem) void {
        _ = self;
    }

    fn setup_platform() PlatformError!Platform {
        return switch (builtin.os.tag) {
            .linux, .freebsd, .netbsd, .openbsd, .dragonfly, .solaris => if (std.os.getenv("XDG_SESSION_TYPE") == null)
                return PlatformError.XDGSessionTypeEnvarNotSet
            else if (std.os.getenv("WAYLAND_DISPLAY") != null)
                //wayland_platform.setup()
                null_platform.setup()
            else if (std.os.getenv("DISPLAY") != null)
                //x11_platform.setup()
                null_platform.setup()
            else
                PlatformError.DisplayEnvarNotSet,
            //.windows => win32_platform.setup(),
            //.macos, .ios => cocoa_platform.setup(),
            .windows => null_platform.setup(),
            .macos, .ios => null_platform.setup(),
            else => {
                return PlatformError.UnsupportedPlatform;
            },
        };
    }
};
