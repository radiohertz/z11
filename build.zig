const std = @import("std");

pub fn build(b: *std.build.Builder) void {
    // Standard release options allow the person running `zig build` to select
    // between Debug, ReleaseSafe, ReleaseFast, and ReleaseSmall.
    const mode = b.standardReleaseOptions();

    const lib = b.addStaticLibrary("z11", "src/main.zig");
    lib.setBuildMode(mode);
    lib.linkLibC();
    lib.linkSystemLibrary("X11");
    lib.install();

    const main_tests = b.addTest("src/main.zig");
    main_tests.setBuildMode(mode);
    main_tests.linkLibC();
    main_tests.linkSystemLibrary("X11");

    const test_step = b.step("test", "Run library tests");
    test_step.dependOn(&main_tests.step);
}
