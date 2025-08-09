const std = @import("std");
const builtin = @import("builtin");
const Allocator = std.mem.Allocator;

pub fn main() !void {
    var gpa = std.heap.DebugAllocator(.{}){};
    const allocator = gpa.allocator();

    var arr = std.ArrayList(User).init(allocator);
    defer {
        for (arr.items) |user| {
            user.deinit(allocator);
        }
        arr.deinit();
    }

    const stdin = std.io.getStdIn().reader();
    const stdout = std.io.getStdOut().writer();

    var i: i32 = 0;
    while (true) : (i += 1) {
        var buf: [30]u8 = undefined;
        try stdout.print("Please enter a name: ", .{});
        if (try stdin.readUntilDelimiterOrEof(&buf, '\n')) |line| {
            var name = line;
            if (builtin.os.tag == .windows) {
                name = @constCast(std.mem.trimRight(u8, name, "\r"));
            }
            if (name.len == 0) {
                break;
            }
            const owned_name = try allocator.dupe(u8, name);
            try arr.append(.{ .name = owned_name, .power = i });
        }
    }

    var has_leto = false;
    for (arr.items) |user| {
        if (std.mem.eql(u8, "Leto", user.name)) {
            has_leto = true;
            break;
        }
    }

    std.debug.print("{any}\n", .{has_leto});
}

const User = struct {
    name: []const u8,
    power: i32,

    fn deinit(self: User, allocator: Allocator) void {
        allocator.free(self.name);
    }
};
