const std = @import("std");

pub fn main() !void {
    const sum = add(8999, 2);
    std.debug.print("8999 + 2 = {d}\n", .{sum});

    const user = User{ .name = "Alice" };
    std.debug.print("User name: {s}\n", .{user.name});
    user.diagnose();

    var a = [_]i32{ 1, 2, 3, 4, 5 };
    var end: usize = 4;
    end += 1;
    var b = a[1..end];
    std.debug.print("Slice b: {any}\n", .{b});
    b[0] = 10;

    const c = "Goku";
    std.debug.print("String c: {s}\n", .{c});

    const d = [3:false]bool{ false, true, false };
    std.debug.print("{any}\n", .{std.mem.asBytes(&d).*});

    std.debug.print("{}\n", .{.{ .year = 2025, .month = 7, .day = 15 }});

    if (std.mem.eql(u8, c, "Goky")) {
        std.debug.print("c is Goky\n", .{});
    } else {
        std.debug.print("c is not Goky\n", .{});
    }

    const super = if (user.power >= User.SUPER_POWER) "super" else "not super";
    std.debug.print("User is {s}!\n", .{super});

    for (0..10) |i| {
        std.debug.print("{d}\n", .{i});
    }

    var pseudo_uuid: [16]u8 = undefined;
    std.crypto.random.bytes(&pseudo_uuid);

    const save = (try Save.loadLast()) orelse Save.blank();
    std.debug.print("{any}\n", .{save});

    _ = add2(1999, 1);
}

fn add2(a: i64, _: i64) i64 {
    return a + a;
}

fn read(stream: std.net.Stream) ![]const u8 {
    var buf: [512]u8 = undefined;
    const buf_read = try stream.buf_read(&buf);
    if (buf_read == 0) {
        return error.Closed;
    }
    return buf[0..buf_read];
}

const Save = struct {
    lives: u8,
    level: u16,

    pub fn loadLast() !?Save {
        return null;
    }

    pub fn blank() Save {
        return .{
            .lives = 3,
            .level = 1,
        };
    }
};

const OpenError = error{
    AccessDenied,
    NotFound,
};

const TimestampType = enum {
    unix,
    datetime,
};

const Timestamp = union(TimestampType) {
    unix: i32,
    datetime: DateTime,

    const DateTime = struct {
        year: u16,
        month: u8,
        day: u8,
        hour: u8,
        minute: u8,
        second: u8,
    };

    fn seconds(self: Timestamp) u16 {
        switch (self) {
            .datetime => |dt| return dt.second,
            .unix => |ts| {
                const seconds_since_midnight: i32 = @rem(ts, 86400);
                return @intCast(@rem(seconds_since_midnight, 60));
            },
        }
    }
};

const Number = union {
    int: i64,
    float: f64,
    nan: void,
};

const Status = enum {
    ok,
    bad,
    unknown,
};

const Stage = enum {
    validate,
    awaiting_confirmation,
    confirmed,
    err,

    fn isComplete(self: Stage) bool {
        return self == .confirmed or self == .err;
    }
};

fn indexOf(haystack: []const u32, needle: u32) ?usize {
    for (haystack, 0..) |value, index| {
        if (needle == value) {
            return index;
        }
    }
    return null;
}

fn add(a: i64, b: i64) i64 {
    return a + b;
}

fn anniversaryName(years_marries: u16) []const u8 {
    switch (years_marries) {
        1 => return "paper",
        2 => return "cotton",
        3 => return "leather",
        4 => return "fruit",
        5 => return "wood",
        6 => return "iron",
        else => return "unknown",
    }
}

fn contains(haystack: []const u32, needle: u32) bool {
    for (haystack) |value| {
        if (needle == value) {
            return true;
        }
    }
    return false;
}

pub fn eql(comptime T: type, a: []const T, b: []const T) bool {
    if (a.len != b.len) return false;

    for (a, b) |a_elem, b_elem| {
        if (a_elem != b_elem) return false;
    }
    return true;
}

pub const User = struct {
    power: u64 = 0,
    name: []const u8,

    pub const SUPER_POWER = 9000;

    pub fn init(name: []const u8, power: u64) User {
        return .{
            .name = name,
            .power = power,
        };
    }

    pub fn diagnose(user: User) void {
        if (user.power >= SUPER_POWER) {
            std.debug.print("it's over {d}!\n", .{user.power});
        }
    }
};
