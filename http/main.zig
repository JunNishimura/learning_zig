const std = @import("std");
const SocketConf = @import("config.zig");
const Request = @import("request.zig");
var stdout_buffer: [1024]u8 = undefined;
var stdout_writer = std.fs.File.stdout().writer(&stdout_buffer);
const stdout = &stdout_writer.interface;

pub fn main() !void {
    const socket = try SocketConf.Socket.init();
    try stdout.print("server addr: {any}\n", .{socket._address});
    var server = try socket._address.listen(.{});
    const connection = try server.accept();
    var buffer: [1000]u8 = undefined;
    for (0..buffer.len) |i| {
        buffer[i] = 0;
    }
    _ = try Request.read_request(connection, buffer[0..buffer.len]);
    try stdout.print("{s}\n", .{buffer});
    try stdout.flush();
}
