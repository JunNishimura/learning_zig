const std = @import("std");

pub fn main() void {
    const leto = User{
        .id = 1,
        .power = 100,
        .manager = null,
    };

    const duncan = User{
        .id = 2,
        .power = 50,
        .manager = &leto,
    };

    std.debug.print("{any}\n{any}", .{
        leto,
        duncan,
    });
}

const User = struct {
    id: u64,
    power: i32,
    manager: ?*const User,
};
