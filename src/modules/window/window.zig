const std = @import("std");
const platform = @import("platform.zig");
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
    const WindowSystemHints = struct {
        init: InitHints,
    };
    const InitHints = struct {
        hat_buttons: bool = true,
        angle_type: platform.AnglePlatformTypeEnum = .ANGLE_PLATFORM_NONE,
        platform_id: platform.PlatformEnum = .ANY,
        vulkan_loader: ?PFN_VkGetInstanceProcAddr = null,
        ns: struct {
            menubar: bool = true,
            chdir: bool = true,
        },
        x11: struct {
            xcbVulkanSurface: bool = true,
        },
        wl: struct {
            libdecorMode: platform.WAYLAND_PREFER_LIBDECOR = .WAYLAND_PREFER_LIBDECOR,
        },
    };

    const WindowMessageHandler = MessageHandler(RequestEnum, void);

    allocator: std.mem.Allocator,
    message_handler: WindowMessageHandler,
    hints: WindowSystemHints,
    platform: platform.PlatformEnum,
    // TODO: Add an array of windows

    // TODO: need to pass in hints and an allocator
    pub fn init() !WindowSystem {
        var allocator = std.heap.GeneralPurposeAllocator(.{}){};
        var window_system = WindowSystem{
            .allocator = allocator.allocator(),
            .message_handler = WindowMessageHandler.init(allocator.allocator()),
            .hints = .{},
            .platform = undefined,
        };
        window_system.platform = platform.selectPlatform(window_system.hints.init.platform_id);
        return window_system;
    }
    pub fn deinit(self: *WindowSystem) void {
        _ = self;
    }
};
