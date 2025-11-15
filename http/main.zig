const std = @import("std");
const SocketConf = @import("config.zig");
const Request = @import("request.zig");
const Response = @import("response.zig");
var stdout_buffer: [1024]u8 = undefined;
var stdout_writer = std.fs.File.stdout().writer(&stdout_buffer);
const stdout = &stdout_writer.interface;

pub fn main() !void {
    const socket = try SocketConf.Socket.init();
    try stdout.print("server addr: {any}\n", .{socket._address});
    try stdout.flush();
    var server = try socket._address.listen(.{});
    const connection = try server.accept();
    var buffer: [1000]u8 = undefined;
    for (0..buffer.len) |i| {
        buffer[i] = 0;
    }
    _ = try Request.read_request(connection, buffer[0..buffer.len]);
    const request = Request.parse_request(buffer[0..buffer.len]);
    if (request.method == Request.Method.Get) {
        try Response.send_200(connection);
    } else {
        try Response.send_404(connection);
    }
}
