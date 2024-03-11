const std = @import("std");
const module = @import("modules/module.zig");
const window = @import("modules/window/window.zig");

pub fn main() void {

    // Initialize modules
    var module_window = module.Module(window.WindowSystem).init();

    // Deinitialize modules
    module_window.deinit();
}
