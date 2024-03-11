const std = @import("std");

/// MessageHandler handles messages between modules.
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

        /// Initialize the message handler
        pub fn init(allocator: std.mem.Allocator) Self {
            const self = Self{
                .handlerLists = [_]HandlerList{HandlerList.init(allocator)} ** TopicCount,
            };
            return self;
        }

        /// Send a message
        pub fn send(self: *Self, topic: TopicEnum, message: MessageType) void {
            const handlerList = self.handlerLists[@intFromEnum(topic)];
            for (handlerList.items) |handlerData| {
                handlerData.handler(message);
            }
        }

        /// Register a message handler to one or more topics
        /// Assumes the handler has not been registered
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

        /// Remove a message handler from all topics
        /// Assumes the handler has been registered only once
        pub fn removeMessageHandler(self: *Self, id: usize) Handler {
            var handler: Handler = undefined;
            for (&self.handlerLists) |*handlerList| {
                for (handlerList.items, 0..) |*handlerData, i| {
                    if (handlerData.id == id) {
                        handler = handlerList.swapRemove(i).handler;
                        break;
                    }
                }
            }
            self.handlerCount -= 1;
            return handler;
        }
    };
}

test "message handler" {
    const TestFunctions = struct {
        const Self = @This();
        var val: u32 = 0;

        pub fn handleMessage1(message: u32) void {
            Self.val += message * 1;
        }

        pub fn handleMessage2(message: u32) void {
            Self.val += message * 2;
        }

        pub fn handleMessage3(message: u32) void {
            Self.val += message * 3;
        }
    };
    const Topics = enum(u2) {
        topic1,
        topic2,
        topic3,
    };
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};

    var messageHandler = MessageHandler(Topics, u32).init(gpa.allocator());

    _ = messageHandler.registerMessageHandler(&[1]Topics{Topics.topic1}, TestFunctions.handleMessage1);
    const id2 = messageHandler.registerMessageHandler(&[2]Topics{ Topics.topic2, Topics.topic3 }, TestFunctions.handleMessage2);

    messageHandler.send(Topics.topic1, 1);
    try std.testing.expect(TestFunctions.val == 1);
    messageHandler.send(Topics.topic2, 2);
    try std.testing.expect(TestFunctions.val == 5);

    _ = messageHandler.removeMessageHandler(id2);
    _ = messageHandler.registerMessageHandler(&[1]Topics{Topics.topic3}, TestFunctions.handleMessage3);
    messageHandler.send(Topics.topic2, 3);
    try std.testing.expect(TestFunctions.val == 5);
    messageHandler.send(Topics.topic3, 4);
    try std.testing.expect(TestFunctions.val == 17);
}
