const std = @import("std");

const Connection = std.net.Server.Connection;
pub fn send_200(conn: Connection) !void {
    const message = ("HTTP/1.1 200 OK\r\n" ++
        "Content-Length: 13\r\n" ++
        "Content-Type: text/plain\r\n" ++
        "\r\n" ++
        "Hello, world!");
    _ = try conn.stream.writeAll(message);
}

pub fn send_404(conn: Connection) !void {
    const message = ("HTTP/1.1 404 Not Found\r\n" ++
        "Content-Length: 9\r\n" ++
        "Content-Type: text/plain\r\n" ++
        "\r\n" ++
        "Not Found");
    _ = try conn.stream.writeAll(message);
}
