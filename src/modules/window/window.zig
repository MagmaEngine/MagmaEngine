const std = @import("std");
const builtin = @import("builtin");
const MessageHandler = @import("../../util/message_handler.zig").MessageHandler;

pub const WindowSystem = struct {
    const DisplayError = error{
        XDGSessionTypeEnvarNotSet,
        DisplayEnvarNotSet,
        UnsupportedDisplayType,
    };
    const RequestEnum = enum {
        CREATE,
        CLOSE,
        FULLSCREEN,
        WINDOWED,
        SET_DIMENSIONS,
        SET_TITLE,
        SET_ICON,
    };
    const DisplayEnum = enum {
        WAYLAND,
        X11,
        WIN32,
    };

    const WindowMessageHandler = MessageHandler(RequestEnum, void);

    allocator: std.mem.Allocator,
    message_handler: WindowMessageHandler,
    display_type: DisplayEnum,

    pub fn init() !WindowSystem {
        var allocator = std.heap.GeneralPurposeAllocator(.{}){};
        return .{
            .allocator = allocator.allocator(),
            .message_handler = WindowMessageHandler.init(allocator.allocator()),
            .display_type = try detectDisplayType(),
        };
    }
    pub fn deinit(self: *WindowSystem) void {
        _ = self;
    }

    pub fn create(self: *WindowSystem) void {
        _ = self;
    }
    pub fn close(self: *WindowSystem) void {
        _ = self;
    }
    pub fn fullscreen(self: *WindowSystem) void {
        _ = self;
    }
    pub fn windowed(self: *WindowSystem) void {
        _ = self;
    }
    pub fn setDimensions(self: *WindowSystem) void {
        _ = self;
    }
    pub fn setTitle(self: *WindowSystem) void {
        _ = self;
    }
    pub fn setIcon(self: *WindowSystem) void {
        _ = self;
    }

    fn detectDisplayType() !DisplayEnum {
        return switch (builtin.os.tag) {
            .linux => {
                if (std.os.getenv("XDG_SESSION_TYPE") == null) {
                    return DisplayError.XDGSessionTypeEnvarNotSet;
                } else if (std.os.getenv("WAYLAND_DISPLAY") != null) {
                    return .WAYLAND;
                } else if (std.os.getenv("DISPLAY") != null) {
                    return .X11;
                } else {
                    return DisplayError.DisplayEnvarNotSet;
                }
            },
            .windows => {
                return .WIN32;
            },
            else => {
                return DisplayError.UnsupportedDisplayType;
            },
        };
    }
};
