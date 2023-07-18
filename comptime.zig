const std = @import("std");
const assert = std.debug.assert;
const trait = std.meta.trait;

const Point2 = struct {
    const Child = f32;
    const Size = i32;

    x: Child = 0,
    y: Child = 0,

    pub fn at(self: Point2, i: Size) Child {
        return if (i == 0) self.x else self.y;
    }

    pub fn len(_: Point2) Size {
        return 2;
    }
};

fn isFloatVec(comptime T: type) bool {
    if (!comptime trait.isContainer(T)) return false;
    if (!comptime trait.hasFn("at")(T)) return false;
    if (!comptime trait.hasFn("len")(T)) return false;
    if (!comptime @hasDecl(T, "Child")) return false;
    if (!comptime @hasDecl(T, "Size")) return false;
    if (!comptime @typeInfo(T.Child) == .Float) return false;
    if (!comptime @typeInfo(@TypeOf(T.len)).Fn.return_type == T.Size) return false;
    return true;
}

fn norm(vec: anytype) @TypeOf(vec).Child {
    const Vec = @TypeOf(vec);
    assert(isFloatVec(Vec));
    // Check empty first to avoid adding 0 and achieve zero cost.
    if (vec.len() == 0) {
        return 0;
    }
    // Non-empty case.
    var i: Vec.Size = 1;
    var result: Vec.Child = vec.at(0) * vec.at(0);
    while (i < vec.len()) : (i += 1) {
        result += vec.at(i) * vec.at(i);
    }
    return std.math.sqrt(result);
}

export fn norm2(x: f32, y: f32) f32 {
    // return std.math.sqrt(x * x + y * y);
    return norm(Point2{ .x = x, .y = y });
}

pub fn main() void {
    std.debug.print("hey: {} {}\n", .{ isFloatVec(Point2), isFloatVec(i32) });
    std.debug.print("norm: {}\n", .{norm2(3, 4)});
}
