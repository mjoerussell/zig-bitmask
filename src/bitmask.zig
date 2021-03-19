const std = @import("std");

pub fn Bitmask(comptime BackingType: type, comptime fields: anytype) type {
    const BaseStruct = packed struct {};
    var base_struct_info = @typeInfo(BaseStruct);

    var incoming_fields: [fields.len]std.builtin.TypeInfo.StructField = undefined;
    inline for (fields) |field, i| {
        incoming_fields[i] = .{
            .name = field[0],
            .field_type = bool,
            .default_value = false,
            .is_comptime = false,
            .alignment = @alignOf(bool)
        };
    }

    base_struct_info.Struct.fields = incoming_fields[0..];

    const BitmaskFields = @Type(base_struct_info);

    return struct{
        pub const Result = BitmaskFields;
        pub fn applyBitmask(value: BackingType) Result {
            var result = Result{};
            inline for (fields) |field, i| {
                if (value & field[1] == field[1]) {
                    @field(result, field[0]) = true;
                }
            }

            return result;
        }

        pub fn createBitmask(bitmask_fields: BitmaskFields) BackingType {
            var result: BackingType = 0;

            inline for (fields) |field| {
                if (@field(bitmask_fields, field[0])) {
                    result |= field[1];
                }
            }

            return result;
        } 
    };

}

test "bitmask" {
    const TestType = Bitmask(u4, .{
        .{ "fieldA", 0b0001 }, 
        .{ "fieldB", 0b0010 },
        .{ "fieldC", 0b0100 }
    });

    const test_value = TestType.applyBitmask(0b0110);

    std.testing.expect(!test_value.fieldA);
    std.testing.expect(test_value.fieldB);
    std.testing.expect(test_value.fieldC);

    const test_set: TestType.Result = .{
        .fieldA = true,
        .fieldB = false,
        .fieldC = true
    };

    const test_set_result = TestType.createBitmask(test_set);

    std.testing.expectEqual(@as(u4, 0b0101), test_set_result);
}