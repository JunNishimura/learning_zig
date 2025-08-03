const std = @import("std");

pub fn main() !void {
    var gpa = std.heap.DebugAllocator(.{}){};
    const allocator = gpa.allocator();

    var user = try allocator.create(User);
    defer allocator.destroy(user);

    user.id = 1;
    user.power = 100;

    levelUp(user);
    std.debug.print("User {d} has power of {d}\n", .{ user.id, user.power });
}

fn levelUp(user: *User) void {
    user.power += 1;
}

pub const User = struct {
    id: u64,
    power: i32,

    fn init(allocator: std.mem.Allocator, id: u64, power: i32) !*User {
        const user = try allocator.create(User);
        user.* = User{
            .id = id,
            .power = power,
        };
        return user;
    }
};
