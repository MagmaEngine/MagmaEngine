const std = @import("std");

pub fn MessageHandler(comptime TopicEnum: type, comptime MessageType: type) type {
    std.debug.assert(@typeInfo(TopicEnum) == .Enum);
    return struct {
        const Self = @This();
        const Handler = *const fn (MessageType) void;
        const HandlerData = struct {
            handler: Handler,
            id: usize,
        };
        const HandlerList = std.ArrayList(HandlerData);
        const TopicCount = @typeInfo(TopicEnum).Enum.fields.len;

        handlerLists: [TopicCount]HandlerList,
        handlerCount: usize = 0,
        ready: bool = false,

        pub fn init(allocator: std.mem.Allocator) Self {
            const self = Self{
                .handlerLists = [_]HandlerList{HandlerList.init(allocator)} ** TopicCount,
            };
            return self;
        }

        // Define a function to send a message
        pub fn send(self: *Self, topic: TopicEnum, message: MessageType) void {
            const handlerList = self.handlerLists[@intFromEnum(topic)];
            for (handlerList.items) |handlerData| {
                handlerData.handler(message);
            }
        }

        pub fn registerMessageHandler(self: *Self, topics: []const TopicEnum, handler: Handler) usize {
            for (topics) |topic| {
                const handlerData = HandlerData{
                    .handler = handler,
                    .id = self.handlerCount,
                };
                self.handlerLists[@intFromEnum(topic)].append(handlerData) catch unreachable;
            }
            self.handlerCount += 1;
            return self.handlerCount - 1;
        }

        pub fn removeMessageHandler(self: *Self, id: usize) Handler {
            var handler: Handler = undefined;
            for (&self.handlerLists) |*handlerList| {
                for (handlerList.items, 0..) |*handlerData, i| {
                    if (handlerData.id == id) {
                        handler = handlerList.swapRemove(i).handler;
                    }
                }
            }
            self.handlerCount -= 1;
            return handler;
        }
    };
}

// tests the message handler
test "message handler" {
    // Additional message handlers
    const TestFunctions = struct {
        const Self = @This();
        var val: i32 = 0;

        pub fn handleMessage1(message: i32) void {
            Self.val = message * 1;
        }

        pub fn handleMessage2(message: i32) void {
            Self.val = message * 2;
        }

        pub fn handleMessage3(message: i32) void {
            Self.val = message * 3;
        }
    };
    const Topics = enum(u2) {
        topic1,
        topic2,
        topic3,
    };
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};

    var messageHandler = MessageHandler(Topics, i32).init(gpa.allocator());

    // Register multiple message handlers
    _ = messageHandler.registerMessageHandler(&[1]Topics{Topics.topic1}, TestFunctions.handleMessage1);
    const id2 = messageHandler.registerMessageHandler(&[2]Topics{ Topics.topic2, Topics.topic3 }, TestFunctions.handleMessage2);

    // Send the message
    messageHandler.send(Topics.topic1, 1);
    try std.testing.expect(TestFunctions.val == 1);
    messageHandler.send(Topics.topic2, 2);
    try std.testing.expect(TestFunctions.val == 4);

    _ = messageHandler.removeMessageHandler(id2);
    _ = messageHandler.registerMessageHandler(&[1]Topics{Topics.topic3}, TestFunctions.handleMessage3);
    messageHandler.send(Topics.topic2, 3);
    try std.testing.expect(TestFunctions.val == 4);
    messageHandler.send(Topics.topic3, 4);
    try std.testing.expect(TestFunctions.val == 12);
}
