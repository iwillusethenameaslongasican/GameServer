-ifndef(C2S_CHAT_REQUEST_PB_H).
-define(C2S_CHAT_REQUEST_PB_H, true).
-record(c2s_chat_request, {
    id = erlang:error({required, id}),
    content = erlang:error({required, content})
}).
-endif.

-ifndef(S2C_CHAT_REPLY_PB_H).
-define(S2C_CHAT_REPLY_PB_H, true).
-record(s2c_chat_reply, {
    id = erlang:error({required, id}),
    content = erlang:error({required, content}),
    time = erlang:error({required, time})
}).
-endif.

-ifndef(C2S_GROUP_CHAT_REQUEST_PB_H).
-define(C2S_GROUP_CHAT_REQUEST_PB_H, true).
-record(c2s_group_chat_request, {
    content = erlang:error({required, content})
}).
-endif.

-ifndef(S2C_GROUP_CHAT_REPLY_PB_H).
-define(S2C_GROUP_CHAT_REPLY_PB_H, true).
-record(s2c_group_chat_reply, {
    id = erlang:error({required, id}),
    content = erlang:error({required, content}),
    time = erlang:error({required, time})
}).
-endif.

-ifndef(TIME_SECTION_PB_H).
-define(TIME_SECTION_PB_H, true).
-record(time_section, {
    year = erlang:error({required, year}),
    month = erlang:error({required, month}),
    day = erlang:error({required, day}),
    hour = erlang:error({required, hour}),
    minu = erlang:error({required, minu}),
    sec = erlang:error({required, sec})
}).
-endif.

