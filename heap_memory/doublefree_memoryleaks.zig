const std = @import("std");
const Allocator = std.mem.Allocator;

pub fn main() !void {
    var gpa = std.heap.DebugAllocator(.{}){};
    const allocator = gpa.allocator();

    const arr = try allocator.alloc(usize, 4);
    allocator.free(arr);
    allocator.free(arr);

    std.debug.print("This won't get printed\n", .{});
}

fn allocLower(allocator: Allocator, str: []const u8) ![]const u8 {
    var dest = try allocator.alloc(u8, str.len);

    for (str, 0..) |c, i| {
        dest[i] = switch (c) {
            'A'...'Z' => c + 32,
            else => c,
        };
    }

    return dest;
}

fn isSpecial(allocator: Allocator, name: []const u8) !bool {
    const lower = try allocLower(allocator, name);
    return std.mem.eql(u8, lower, "admin");
}
