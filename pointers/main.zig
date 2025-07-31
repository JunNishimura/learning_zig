const std = @import("std");

pub fn main() void {
    // var user = User{
    //     .id = 1,
    //     .power = 100,
    // };

    // user.levelUp();
    // std.debug.print("User {d} has power {d}\n", .{ user.id, user.power });

    var name = [4]u8{ 'G', 'o', 'k', 'u' };
    const user = User{
        .id = 1,
        .power = 100,
        .name = name[0..],
    };
    levelUp(user);
    std.debug.print("{s}\n", .{user.name});
}

fn levelUp(user: User) void {
    user.name[2] = '!';
}

pub const User = struct {
    id: u64,
    power: i32,
    name: []u8,

    fn levelUp(user: *User) void {
        std.debug.print("{*}\n{*}\n", .{ &user, user });
        user.power += 1;
    }
};
