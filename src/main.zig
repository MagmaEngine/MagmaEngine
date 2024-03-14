const module = @import("modules/module.zig");
const window_system = @import("modules/window/window_system.zig");
const logger = @import("util/logger.zig");

pub fn main() void {

    // Initialize modules
    var module_window = module.Module(window_system.WindowSystem, "WindowSystem").init();

    // Deinitialize modules
    module_window.deinit();
}
