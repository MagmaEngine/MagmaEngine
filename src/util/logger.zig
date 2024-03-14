const std = @import("std");

const LogLevelEnum = enum {
    DEBUG,
    INFO,
    WARN,
    ERROR,
};

pub fn log(level: LogLevelEnum, channel: []const u8, comptime fmt: []const u8, args: anytype) void {
    const color = switch (level) {
        .DEBUG => "\x1b[34m",
        .INFO => "\x1b[32m",
        .WARN => "\x1b[33m",
        .ERROR => "\x1b[31m",
    };
    const log_message = color ++ @tagName(level) ++ ": " ++ channel ++ ": " ++ fmt ++ "\x1b[0m";
    switch (level) {
        .ERROR => {
            const stderr_file = std.io.getStdErr().writer();
            var err_bw = std.io.bufferedWriter(stderr_file);
            const stderr = err_bw.writer();
            stderr.print(log_message, args) catch return;
            err_bw.flush() catch return;
        },
        else => {
            const stdout_file = std.io.getStdOut().writer();
            var out_bw = std.io.bufferedWriter(stdout_file);
            const stdout = out_bw.writer();
            stdout.print(log_message, args) catch return;
            out_bw.flush() catch return;
        },
    }
}
