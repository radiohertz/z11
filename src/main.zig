const std = @import("std");

const xlib = @cImport({
    @cInclude("X11/Xlib.h");
});

const XError = error{XOpenDisplayFailed};

/// Container for the XServer
const XServer = struct {
    display: ?*xlib.Display,

    /// Start the connection with the XServer
    pub fn init() XError!XServer {
        var display = xlib.XOpenDisplay(null);
        if (display == null) {
            return XError.XOpenDisplayFailed;
        }

        return XServer{
            .display = display,
        };
    }

    ///
    pub fn is_valid(self: @This()) bool {
        return self.display != null;
    }

    /// Get the XServer vendor
    pub fn vendor(self: @This()) [*:0]const u8 {
        return xlib.ServerVendor(self.display);
    }

    /// Kill the connection with XServer
    pub fn exit(self: @This()) void {
        if (self.display != null) {
            _ = xlib.XCloseDisplay(self.display);
        }
    }
};

test "basic test" {
    _ = try XServer.init();
}
