const std = @import("std");
const module = @import("modules/module.zig");
const window = @import("modules/window/window.zig");

pub fn main() void {
    var module_window = module.Module(window.WindowSystem).init();
    module_window.deinit();
}
