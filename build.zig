const Builder = @import("std").Build;

pub fn build(b: *Builder) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const mod = b.addModule("snappy.zig", Builder.Module.CreateOptions{
        .root_source_file = b.path("snappy.zig"),
        .target = target,
        .optimize = optimize,
    });
    _ = mod;

    const lib = b.addStaticLibrary(.{
        .name = "snappy",
        .root_source_file = .{ .cwd_relative = "snappy.zig" },
        .optimize = optimize,
        .target = target,
    });
    b.installArtifact(lib);

    const tests = b.addTest(.{
        .root_source_file = .{ .cwd_relative = "snappy.zig" },
        .optimize = optimize,
        .target = target,
    });

    const run_tests = b.addRunArtifact(tests);
    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_tests.step);
}
