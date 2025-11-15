const std = @import("std");

const Connection = std.net.Server.Connection;
pub fn read_request(conn: Connection, buffer: []u8) !void {
    _ = try conn.stream.read(buffer);
}
