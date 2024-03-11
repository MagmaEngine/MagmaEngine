const std = @import("std");

pub fn Module(comptime T: type) type {
    return struct {
        const Self = @This();
        const ModuleType = T;

        module: ModuleType,
        enabled: bool = true,
        ready: bool = false,

        pub fn init() Self {
            const module = .{
                .module = ModuleType.init() catch |err| {
                    std.debug.print("ERROR: {s}, unable to initialize module: {s}\n", .{ @errorName(err), @typeName(T) });
                    return .{
                        .module = undefined,
                        .enabled = false,
                    };
                    // log unable to initialize module
                    // don't enable module
                },
            };
            return module;
        }

        pub fn deinit(self: *Self) void {
            self.module.deinit();
            self.ready = false;
        }
    };
}
