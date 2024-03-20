const std = @import("std");
const log = @import("../util/logger.zig").log;

pub fn Module(comptime T: type, comptime name: []const u8) type {
    return struct {
        const Self = @This();
        const ModuleType = T;

        module: ModuleType,
        initialized: bool = false,

        pub fn init() Self {
            log(.INFO, name, "Initializing module", .{});
            const module = .{
                .module = ModuleType.init() catch |err| {
                    log(.ERROR, name, "Unable to initialize module: {s}", .{@errorName(err)});
                    return .{
                        .module = undefined,
                    };
                },
                .initialized = true,
            };
            return module;
        }

        pub fn deinit(self: *Self) void {
            if (!self.initialized) {
                log(.WARN, name, "Cannot deinitialize module: not initialized", .{});
                return;
            }
            log(.INFO, name, "Deinitializing module", .{});
            self.module.deinit();
            self.initialized = false;
        }
    };
}
