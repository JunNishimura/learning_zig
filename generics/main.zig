const std = @import("std");
const Allocator = std.mem.Allocator;

pub fn main() !void {
    var gpa = std.heap.DebugAllocator(.{}){};
    const allocator = gpa.allocator();

    var list = try List(u32).init(allocator);
    defer list.deinit();

    for (0..10) |i| {
        try list.add(@intCast(i));
    }

    std.debug.print("List items: {any}\n", .{list.items[0..list.pos]});
}

fn List(comptime T: type) type {
    return struct {
        pos: usize,
        items: []T,
        allocator: std.mem.Allocator,

        const Self = @This();

        fn init(allocator: std.mem.Allocator) !List(T) {
            return .{
                .pos = 0,
                .allocator = allocator,
                .items = try allocator.alloc(T, 4),
            };
        }

        fn deinit(self: List(T)) void {
            self.allocator.free(self.items);
        }

        fn add(self: *List(T), value: T) !void {
            const pos = self.pos;
            const len = self.items.len;

            if (pos == len) {
                var larger = try self.allocator.alloc(T, len * 2);
                @memcpy(larger[0..len], self.items);

                self.allocator.free(self.items);
                self.items = larger;
            }

            self.items[pos] = value;
            self.pos = pos + 1;
        }
    };
}
