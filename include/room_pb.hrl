-ifndef(C2S_GET_ACHIEVE_REQUEST_PB_H).
-define(C2S_GET_ACHIEVE_REQUEST_PB_H, true).
-record(c2s_get_achieve_request, {
    id = erlang:error({required, id})
}).
-endif.

-ifndef(S2C_GET_ACHIEVE_REPLY_PB_H).
-define(S2C_GET_ACHIEVE_REPLY_PB_H, true).
-record(s2c_get_achieve_reply, {
    id = erlang:error({required, id}),
    win = erlang:error({required, win}),
    fail = erlang:error({required, fail})
}).
-endif.

-ifndef(C2S_GET_ROOM_LIST_REQUEST_PB_H).
-define(C2S_GET_ROOM_LIST_REQUEST_PB_H, true).
-record(c2s_get_room_list_request, {
    
}).
-endif.

-ifndef(S2C_GET_ROOM_LIST_REPLY_PB_H).
-define(S2C_GET_ROOM_LIST_REPLY_PB_H, true).
-record(s2c_get_room_list_reply, {
    num = erlang:error({required, num}),
    rooms = []
}).
-endif.

-ifndef(C2S_CREATE_ROOM_REQUEST_PB_H).
-define(C2S_CREATE_ROOM_REQUEST_PB_H, true).
-record(c2s_create_room_request, {
    
}).
-endif.

-ifndef(S2C_CREATE_ROOM_REPLY_PB_H).
-define(S2C_CREATE_ROOM_REPLY_PB_H, true).
-record(s2c_create_room_reply, {
    ret = erlang:error({required, ret}),
    room_id = erlang:error({required, room_id})
}).
-endif.

-ifndef(C2S_ENTER_ROOM_REQUEST_PB_H).
-define(C2S_ENTER_ROOM_REQUEST_PB_H, true).
-record(c2s_enter_room_request, {
    room_id = erlang:error({required, room_id})
}).
-endif.

-ifndef(S2C_ENTER_ROOM_REPLY_PB_H).
-define(S2C_ENTER_ROOM_REPLY_PB_H, true).
-record(s2c_enter_room_reply, {
    ret = erlang:error({required, ret}),
    room_id = erlang:error({required, room_id})
}).
-endif.

-ifndef(C2S_GET_ROOM_INFO_REQUEST_PB_H).
-define(C2S_GET_ROOM_INFO_REQUEST_PB_H, true).
-record(c2s_get_room_info_request, {
    room_id = erlang:error({required, room_id})
}).
-endif.

-ifndef(S2C_GET_ROOM_INFO_REPLY_PB_H).
-define(S2C_GET_ROOM_INFO_REPLY_PB_H, true).
-record(s2c_get_room_info_reply, {
    num = erlang:error({required, num}),
    roles = []
}).
-endif.

-ifndef(C2S_LEAVE_ROOM_REQUEST_PB_H).
-define(C2S_LEAVE_ROOM_REQUEST_PB_H, true).
-record(c2s_leave_room_request, {
    room_id = erlang:error({required, room_id})
}).
-endif.

-ifndef(S2C_LEAVE_ROOM_REPLY_PB_H).
-define(S2C_LEAVE_ROOM_REPLY_PB_H, true).
-record(s2c_leave_room_reply, {
    ret = erlang:error({required, ret})
}).
-endif.

-ifndef(ROOM_INFO_PB_H).
-define(ROOM_INFO_PB_H, true).
-record(room_info, {
    room_id = erlang:error({required, room_id}),
    num = erlang:error({required, num}),
    status = erlang:error({required, status})
}).
-endif.

-ifndef(ROLE_INFO_PB_H).
-define(ROLE_INFO_PB_H, true).
-record(role_info, {
    id = erlang:error({required, id}),
    team = erlang:error({required, team}),
    win = erlang:error({required, win}),
    fail = erlang:error({required, fail}),
    is_owner = erlang:error({required, is_owner})
}).
-endif.

