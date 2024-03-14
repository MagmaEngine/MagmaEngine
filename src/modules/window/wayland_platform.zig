const std = @import("std");
const WindowSystem = @import("window_system.zig").WindowSystem;
const Platform = WindowSystem.Platform;

const MonitorState = struct {
    ramp: WindowSystem.GammaRamp,
};

pub fn setup() Platform {
    return Platform{
        .id = WindowSystem.PlatformEnum.WAYLAND,
        .init = init,
        .terminate = terminate,

        // monitor
        .free_monitor = free_monitor,
        .get_monitor_pos = get_monitor_pos,
        .get_monitor_content_scale = get_monitor_content_scale,
        .get_monitor_workarea = get_monitor_workarea,
        .get_video_modes = get_video_modes,
        .get_video_mode = get_video_mode,
        .get_gamma_ramp = get_gamma_ramp,
        .set_gamma_ramp = set_gamma_ramp,

        // window
        .create_window = create_window,
        .destroy_window = destroy_window,
        .set_window_title = set_window_title,
        .set_window_icon = set_window_icon,
        .get_window_pos = get_window_pos,
        .set_window_pos = set_window_pos,
        .get_window_size = get_window_size,
        .set_window_size = set_window_size,
        .set_window_size_limits = set_window_size_limits,
        .set_window_aspect_ratio = set_window_aspect_ratio,
        .get_framebuffer_size = get_framebuffer_size,
        .get_window_frame_size = get_window_frame_size,
        .get_window_content_scale = get_window_content_scale,
        .iconify_window = iconify_window,
        .restore_window = restore_window,
        .maximize_window = maximize_window,
        .show_window = show_window,
        .hide_window = hide_window,
        .request_window_attention = request_window_attention,
        .focus_window = focus_window,
        .set_window_monitor = set_window_monitor,
        .window_focused = window_focused,
        .window_iconified = window_iconified,
        .window_visible = window_visible,
        .window_maximized = window_maximized,
        .window_hovered = window_hovered,
        .framebuffer_transparent = framebuffer_transparent,
        .get_window_opacity = get_window_opacity,
        .set_window_resizable = set_window_resizable,
        .set_window_decorated = set_window_decorated,
        .set_window_floating = set_window_floating,
        .set_window_opacity = set_window_opacity,
        .set_window_mouse_passthrough = set_window_mouse_passthrough,
        .poll_events = poll_events,
        .wait_events = wait_events,
        .wait_events_timeout = wait_events_timeout,
        .post_empty_event = post_empty_event,
    };
}

pub fn init(winsys: *WindowSystem) std.mem.Allocator.Error!void {
    try poll_monitors(winsys);
}

pub fn terminate(winsys: *WindowSystem) void {
    _ = winsys;
}

fn poll_monitors(winsys: *WindowSystem) std.mem.Allocator.Error!void {
    const dpi: f32 = 141;
    const mode: WindowSystem.VideoMode = winsys.platform.get_video_mode();
    const null_monitor: WindowSystem.Monitor = .{
        .name = "Null SuperNoop 0",
        .widthMM = @as(f32, @floatFromInt(mode.width)) * 25.4 / dpi,
        .heightMM = @as(f32, @floatFromInt(mode.height)) * 25.4 / dpi,
        .modes = &[1]WindowSystem.VideoMode{mode},
        .current_mode = 0,
        .original_ramp = .{
            .red = &[0]u16{},
            .green = &[0]u16{},
            .blue = &[0]u16{},
            .size = 0,
        },
        .current_ramp = .{
            .red = &[0]u16{},
            .green = &[0]u16{},
            .blue = &[0]u16{},
            .size = 0,
        },
    };
    winsys.monitors.clearRetainingCapacity();
    try winsys.monitors.append(null_monitor);
}

pub fn free_monitor() void {
    return;
}

pub fn get_monitor_pos() void {
    return;
}

pub fn get_monitor_content_scale() void {
    return;
}

pub fn get_monitor_workarea() void {
    return;
}

pub fn get_video_modes() void {
    return;
}

pub fn get_video_mode() WindowSystem.VideoMode {
    return WindowSystem.VideoMode{
        .width = 1920,
        .height = 1080,
        .redBits = 8,
        .greenBits = 8,
        .blueBits = 8,
        .refreshRate = 60,
    };
}

pub fn get_gamma_ramp() void {
    return;
}

pub fn set_gamma_ramp() void {
    return;
}

pub fn create_window() void {
    return;
}

pub fn destroy_window() void {
    return;
}

pub fn set_window_title() void {
    return;
}

pub fn set_window_icon() void {
    return;
}

pub fn get_window_pos() void {
    return;
}

pub fn set_window_pos() void {
    return;
}

pub fn get_window_size() void {
    return;
}

pub fn set_window_size() void {
    return;
}

pub fn set_window_size_limits() void {
    return;
}

pub fn set_window_aspect_ratio() void {
    return;
}

pub fn get_framebuffer_size() void {
    return;
}

pub fn get_window_frame_size() void {
    return;
}

pub fn get_window_content_scale() void {
    return;
}

pub fn iconify_window() void {
    return;
}

pub fn restore_window() void {
    return;
}

pub fn maximize_window() void {
    return;
}

pub fn show_window() void {
    return;
}

pub fn hide_window() void {
    return;
}

pub fn request_window_attention() void {
    return;
}

pub fn focus_window() void {
    return;
}

pub fn set_window_monitor() void {
    return;
}

pub fn window_focused() void {
    return;
}

pub fn window_iconified() void {
    return;
}

pub fn window_visible() void {
    return;
}

pub fn window_maximized() void {
    return;
}

pub fn window_hovered() void {
    return;
}

pub fn framebuffer_transparent() void {
    return;
}

pub fn get_window_opacity() void {
    return;
}

pub fn set_window_resizable() void {
    return;
}

pub fn set_window_decorated() void {
    return;
}

pub fn set_window_floating() void {
    return;
}

pub fn set_window_opacity() void {
    return;
}

pub fn set_window_mouse_passthrough() void {
    return;
}

pub fn poll_events() void {
    return;
}

pub fn wait_events() void {
    return;
}

pub fn wait_events_timeout() void {
    return;
}

pub fn post_empty_event() void {
    return;
}
