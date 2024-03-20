const std = @import("std");
const log = @import("../../util/logger.zig").log;
const WindowSystem = @import("window_system.zig").WindowSystem;

pub const WaylandState = struct {
    socket: std.net.Stream,

    pub fn init(alloc: std.mem.Allocator) !WaylandState {
        const wayland_socket_path = try getSocketPath(alloc);
        defer alloc.free(wayland_socket_path);
        log(.DEBUG, @typeName(WaylandState), "Socket Path: {s}", .{wayland_socket_path});

        return WaylandState{
            .socket = try std.net.connectUnixSocket(wayland_socket_path),
        };
    }

    pub fn deinit(self: *WaylandState) void {
        self.socket.close();
    }

    fn getSocketPath(alloc: std.mem.Allocator) ![]const u8 {
        return std.process.getEnvVarOwned(alloc, "WAYLAND_SOCKET") catch |err| switch (err) {
            error.EnvironmentVariableNotFound => {
                const xdg_runtime_dir_path = std.process.getEnvVarOwned(alloc, "XDG_RUNTIME_DIR") catch |err_xdg| switch (err_xdg) {
                    error.EnvironmentVariableNotFound => "/tmp",
                    else => return err_xdg,
                };
                const wayland_display_name = std.process.getEnvVarOwned(alloc, "WAYLAND_DISPLAY") catch |err_disp| switch (err_disp) {
                    error.EnvironmentVariableNotFound => "wayland-0",
                    else => return err_disp,
                };
                return try std.fs.path.join(alloc, &.{ xdg_runtime_dir_path, wayland_display_name });
            },
            else => return err,
        };
    }
};

pub fn setup(winsys: *WindowSystem) void {
    winsys.platform_id = WindowSystem.Platform.WAYLAND;
    winsys.init_platform = init;
    winsys.terminate = terminate;
    // monitor
    winsys.free_monitor = free_monitor;
    winsys.get_monitor_pos = get_monitor_pos;
    winsys.get_monitor_content_scale = get_monitor_content_scale;
    winsys.get_monitor_workarea = get_monitor_workarea;
    winsys.get_video_modes = get_video_modes;
    winsys.get_video_mode = get_video_mode;
    winsys.get_gamma_ramp = get_gamma_ramp;
    winsys.set_gamma_ramp = set_gamma_ramp;
    // window
    winsys.create_window = create_window;
    winsys.destroy_window = destroy_window;
    winsys.set_window_title = set_window_title;
    winsys.set_window_icon = set_window_icon;
    winsys.get_window_pos = get_window_pos;
    winsys.set_window_pos = set_window_pos;
    winsys.get_window_size = get_window_size;
    winsys.set_window_size = set_window_size;
    winsys.set_window_size_limits = set_window_size_limits;
    winsys.set_window_aspect_ratio = set_window_aspect_ratio;
    winsys.get_framebuffer_size = get_framebuffer_size;
    winsys.get_window_frame_size = get_window_frame_size;
    winsys.get_window_content_scale = get_window_content_scale;
    winsys.iconify_window = iconify_window;
    winsys.restore_window = restore_window;
    winsys.maximize_window = maximize_window;
    winsys.show_window = show_window;
    winsys.hide_window = hide_window;
    winsys.request_window_attention = request_window_attention;
    winsys.focus_window = focus_window;
    winsys.set_window_monitor = set_window_monitor;
    winsys.window_focused = window_focused;
    winsys.window_iconified = window_iconified;
    winsys.window_visible = window_visible;
    winsys.window_maximized = window_maximized;
    winsys.window_hovered = window_hovered;
    winsys.framebuffer_transparent = framebuffer_transparent;
    winsys.get_window_opacity = get_window_opacity;
    winsys.set_window_resizable = set_window_resizable;
    winsys.set_window_decorated = set_window_decorated;
    winsys.set_window_floating = set_window_floating;
    winsys.set_window_opacity = set_window_opacity;
    winsys.set_window_mouse_passthrough = set_window_mouse_passthrough;
    winsys.poll_events = poll_events;
    winsys.wait_events = wait_events;
    winsys.wait_events_timeout = wait_events_timeout;
    winsys.post_empty_event = post_empty_event;
}

pub fn init(winsys: *WindowSystem) !void {
    _ = winsys;
}

pub fn terminate(winsys: *WindowSystem) void {
    _ = winsys;
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
