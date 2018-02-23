-ifndef(C2S_FRIEND_LIST_REQUEST_PB_H).
-define(C2S_FRIEND_LIST_REQUEST_PB_H, true).
-record(c2s_friend_list_request, {
    
}).
-endif.

-ifndef(S2C_FRIEND_LIST_REPLY_PB_H).
-define(S2C_FRIEND_LIST_REPLY_PB_H, true).
-record(s2c_friend_list_reply, {
    num = erlang:error({required, num}),
    infos = []
}).
-endif.

-ifndef(C2S_ADD_FRIEND_REQUEST_PB_H).
-define(C2S_ADD_FRIEND_REQUEST_PB_H, true).
-record(c2s_add_friend_request, {
    id = erlang:error({required, id})
}).
-endif.

-ifndef(S2C_ADD_FRIEND_REPLY_PB_H).
-define(S2C_ADD_FRIEND_REPLY_PB_H, true).
-record(s2c_add_friend_reply, {
    result = erlang:error({required, result})
}).
-endif.

-ifndef(C2S_DEL_FRIEND_REQUEST_PB_H).
-define(C2S_DEL_FRIEND_REQUEST_PB_H, true).
-record(c2s_del_friend_request, {
    id = erlang:error({required, id})
}).
-endif.

-ifndef(S2C_DEL_FRIEND_REPLY_PB_H).
-define(S2C_DEL_FRIEND_REPLY_PB_H, true).
-record(s2c_del_friend_reply, {
    result = erlang:error({required, result})
}).
-endif.

-ifndef(C2S_FRIEND_INFO_REQUEST_PB_H).
-define(C2S_FRIEND_INFO_REQUEST_PB_H, true).
-record(c2s_friend_info_request, {
    id = erlang:error({required, id})
}).
-endif.

-ifndef(S2C_FRIEND_INFO_REPLY_PB_H).
-define(S2C_FRIEND_INFO_REPLY_PB_H, true).
-record(s2c_friend_info_reply, {
    info = erlang:error({required, info})
}).
-endif.

-ifndef(FRIEND_INFO_PB_H).
-define(FRIEND_INFO_PB_H, true).
-record(friend_info, {
    id = erlang:error({required, id}),
    username = erlang:error({required, username}),
    image = erlang:error({required, image}),
    status = erlang:error({required, status}),
    win = erlang:error({required, win}),
    fail = erlang:error({required, fail})
}).
-endif.

