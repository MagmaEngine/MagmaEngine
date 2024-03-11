const std = @import("std");
const MessageHandler = @import("../util/message_handler.zig").MessageHandler;

const WindowRequestEnum = enum {
    CREATE,
    CLOSE,
    FULLSCREEN,
    WINDOWED,
    SET_DIMENSIONS,
    SET_TITLE,
    SET_ICON,
};

pub const WindowSystem = struct {
    const WindowMessageHandler = MessageHandler(WindowRequestEnum, void);

    message_handler: WindowMessageHandler,
    allocator: std.mem.Allocator,

    pub fn init() WindowSystem {
        var allocator = std.heap.GeneralPurposeAllocator(.{}){};
        return .{
            .allocator = allocator.allocator(),
            .message_handler = WindowMessageHandler.init(allocator.allocator()),
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
};
