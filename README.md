# Zig Bitmask Util

A small bitmask util library for the Zig programming language. Allows the user to use bitmask values in a strongly-typed way.

## Example

```zig
const Bitmask = @import("bitmask").Bitmask;

fn main() !void {
    // Generate a bitmask type and apply/create functions.
    const MyBitmask = Bitmask(u4, .{
        .{ "a", 0b0001 },
        .{ "b", 0b0010 },
        .{ "c", 0b0100 },
        .{ "d", 0b1000 }
    });

    // MyBitmask.Result is a new struct type with four boolean fields named 'a', 'b', 'c', and 'd'.

    // Get an instance of MyBitmask.Result from a masked value

    const instance = MyBitmask.applyBitmask(0b1101);

    std.debug.assert(instance.a == true);
    std.debug.assert(instance.b == false);
    std.debug.assert(instance.c == true);
    std.debug.assert(instance.d == true);

    // You can also go from a struct back to a bitmask value
    const mask_values = MyBitmask.Result{
        .a = false,
        .b = true,
        .c = true,
        .d = false
    };

    const result_number: u4 = MyBitmask.createBitmask(mask_values);

    std.debug.assert(result_number == @as(u4, 0b0110));
}
```
