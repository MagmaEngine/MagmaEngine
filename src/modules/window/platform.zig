const builtin = @import("builtin");
const std = @import("std");
const null_init = @import("null_init.zig");

const PlatformError = error{
    XDGSessionTypeEnvarNotSet,
    DisplayEnvarNotSet,
    UnsupportedPlatform,
    UndesiredPlatform,
};
const PlatformEnum = enum(u32) {
    ANY = 0x00060000,
    WIN32 = 0x00060001,
    COCOA = 0x00060002,
    WAYLAND = 0x00060003,
    X11 = 0x00060004,
    NULL = 0x00060005,
};
const AnglePlatformTypeEnum = enum(u32) {
    ANGLE_PLATFORM_NONE = 0x00037001,
    ANGLE_PLATFORM_OPENGL = 0x00037002,
    ANGLE_PLATFORM_OPENGLES = 0x00037003,
    ANGLE_PLATFORM_D3D9 = 0x00037004,
    ANGLE_PLATFORM_D3D11 = 0x00037005,
    ANGLE_PLATFORM_METAL = 0x00037006,
    ANGLE_PLATFORM_VULKAN = 0x00037007,
};
const WAYLAND_PREFER_LIBDECOR = enum(u32) {
    WAYLAND_PREFER_LIBDECOR = 0x00038001,
    WAYLAND_DISABLE_LIBDECOR = 0x00038002,
};

const Platform = struct {
    id: PlatformEnum,

    // init
    init: fn () void,
    terminate: fn () void,

    // input
    get_cursor_pos: fn () void,
    set_cursor_pos: fn () void,
    set_cursor_mode: fn () void,
    set_raw_mouse_motion: fn () void,
    raw_mouse_motion_supported: fn () void,
    create_cursor: fn () void,
    create_standard_cursor: fn () void,
    destroy_cursor: fn () void,
    set_cursor: fn () void,
    get_scancode_name: fn () void,
    get_key_scancode: fn () void,
    set_clipboard_string: fn () void,
    get_clipboard_string: fn () void,
    init_joysticks: fn () void,
    terminate_joysticks: fn () void,
    poll_joystick: fn () void,
    get_mapping_name: fn () void,
    update_gamepad_guid: fn () void,

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

    // EGL
    get_EGL_platform: fn () void,
    get_EGL_native_display: fn () void,
    get_EGL_native_window: fn () void,

    // vulkan
    get_required_instance_extensions: fn () void,
    get_physical_device_present_support: fn () void,
    create_window_surface: fn () void,
};

pub fn select_platform(desired_platform: PlatformEnum) PlatformError!Platform {
    const platform = switch (builtin.os.tag) {
        .linux | .freebsd | .netbsd | .openbsd | .dragonfly | .solaris => {
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
        .macosx | .ios => .COCOA,
        else => {
            return PlatformError.UnsupportedPlatform;
        },
    };

    switch (desired_platform) {
        .ANY => {},
        .NULL => platform = .NULL,
        else => if (platform != desired_platform) PlatformError.UndesiredPlatform,
    }

    return switch (platform) {
        .NULL => null_init.connect(),
        .WIN32 => win32_init.connect(),
        .COCOA => cocoa_init.connect(),
        .WAYLAND => wayland_init.connect(),
        .X11 => x11_init.connect(),
        else => PlatformError.UnsupportedPlatform,
    };
}
