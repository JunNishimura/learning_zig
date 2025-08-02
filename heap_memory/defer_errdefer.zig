const std = @import("std");
const Allocator = std.mem.Allocator;

pub const Game = struct {
    players: []Player,
    history: []Move,
    allocator: Allocator,

    fn init(allocator: Allocator, player_count: usize) !Game {
        const players = try allocator.alloc(Player, player_count);
        errdefer allocator.free(players);

        const history = try allocator.alloc(Move, player_count * 10);
        errdefer allocator.free(history);

        return .{
            .players = players,
            .history = history,
            .allocator = allocator,
        };
    }

    fn deinit(game: Game) void {
        const allocator = game.allocator;
        allocator.free(game.players);
        allocator.free(game.history);
    }
};

const Player = struct {
    id: u64,
    name: []const u8,
};

const Move = struct {
    player_id: u64,
    action: []const u8,
};
