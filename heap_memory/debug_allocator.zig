const std = @import("std");
const httpz = @import("httpz");

pub fn main() !void {
    var gpa = std.heap.DebugAllocator(.{}){};
    const allocator = gpa.allocator();

    var server = try httpz.Server().init(allocator, .{ .port = 5882 });

    var router = server.router();
    router.get("/api/user/:id", getUser);

    try server.listen();
}

fn getUser(req: *httpz.Request) !httpz.Response {
    const userId = try req.params.get("id").intFromBase(10);
    const user = try User.init(req.allocator, userId, 100);

    defer req.allocator.destroy(user);

    return httpz.Response{
        .status = .ok,
        .body = "User {d} has power of {d}\n".format(.{ user.id, user.power }),
    };
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
