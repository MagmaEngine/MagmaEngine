pub fn Module(comptime T: type) type {
    return struct {
        const Self = @This();
        const ModuleType = T;

        module: ModuleType,
        enabled: bool = true,
        ready: bool = false,

        pub fn init() @This() {
            return .{ .module = ModuleType.init() };
        }

        pub fn deinit(self: *Self) void {
            self.module.deinit();
            self.ready = false;
        }
    };
}
