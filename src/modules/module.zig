const std = @import("std");
const logger = @import("../util/logger.zig");

pub fn Module(comptime T: type) type {
    return struct {
        const Self = @This();
        const ModuleType = T;

        module: ModuleType,
        enabled: bool = true,
        ready: bool = false,

        pub fn init() Self {
            logger.log(.DEBUG, @typeName(T), "Initializing module\n", .{});
            const module = .{
                .module = ModuleType.init() catch |err| {
                    logger.log(.ERROR, @typeName(T), "Unable to initialize module: {s}\n", .{@errorName(err)});
                    return .{
                        .module = undefined,
                        .enabled = false,
                    };
                },
            };
            return module;
        }

        pub fn deinit(self: *Self) void {
            logger.log(.DEBUG, @typeName(T), "Deinitializing module\n", .{});
            self.module.deinit();
            self.ready = false;
        }
    };
}
