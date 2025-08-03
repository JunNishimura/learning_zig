const std = @import("std");
const builtin = @import("builtin");

pub fn main() !void {
    // var gpa = std.heap.DebugAllocator(.{}){};
    // const allocator = if (builtin.mode == .Debug) gpa.allocator() else std.heap.c_allocator;

    // defer if (builtin.mode == .Debug) {
    //     if (gpa.detectLeaks()) {
    //         std.posix.exit(1);
    //     }
    // };

    const name = "Leto";
    var buf: [100]u8 = undefined;
    const greeting = try std.fmt.bufPrint(&buf, "Hello, {s}", .{name});
    std.debug.print("{s}\n", .{greeting});
}
