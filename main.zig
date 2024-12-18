const std = @import("std");
const Allocator = std.mem.Allocator;
const fs = std.fs;
const file = fs.File;

const snappy = @import("snappy.zig");

fn readFile(allocator: Allocator, path: []const u8) ![]u8 {
    var f = try fs.cwd().openFile(path, file.OpenFlags{ .mode = file.OpenMode.read_only });
    const fMetadata = try f.stat();

    const output = try allocator.alloc(u8, fMetadata.size);
    errdefer allocator.free(output);

    _ = try f.readAll(output);

    return output;
}

// A small sample application demonstrating how to decode a snappy block-formatted input.
pub fn main() !void {
    const allocator = std.heap.page_allocator;
    const stdout = std.io.getStdOut().writer();

    // const input = try readFile(allocator, "input");
    // defer allocator.free(input);

    // const decoded = try snappy.decode(allocator, input);
    // defer allocator.free(decoded);

    // try stdout.print("{}", .{decoded});

    const encInput = try readFile(allocator, "encode");
    defer allocator.free(encInput);

    const encoded = try snappy.encode(allocator, encInput);
    defer allocator.free(encoded);
    try stdout.print("{s}", .{encoded});
}
