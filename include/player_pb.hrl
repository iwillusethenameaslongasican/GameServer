-ifndef(C2S_LOGIN_REQUEST_PB_H).
-define(C2S_LOGIN_REQUEST_PB_H, true).
-record(c2s_login_request, {
    username = erlang:error({required, username}),
    password = erlang:error({required, password})
}).
-endif.

-ifndef(S2C_LOGIN_REPLY_PB_H).
-define(S2C_LOGIN_REPLY_PB_H, true).
-record(s2c_login_reply, {
    result_code = erlang:error({required, result_code}),
    id = erlang:error({required, id})
}).
-endif.

-ifndef(C2S_REGISTER_REQUEST_PB_H).
-define(C2S_REGISTER_REQUEST_PB_H, true).
-record(c2s_register_request, {
    username = erlang:error({required, username}),
    password = erlang:error({required, password})
}).
-endif.

-ifndef(S2C_REGISTER_REPLY_PB_H).
-define(S2C_REGISTER_REPLY_PB_H, true).
-record(s2c_register_reply, {
    result_code = erlang:error({required, result_code})
}).
-endif.

-ifndef(C2S_LOGOUT_REQUEST_PB_H).
-define(C2S_LOGOUT_REQUEST_PB_H, true).
-record(c2s_logout_request, {
    id = erlang:error({required, id})
}).
-endif.

-ifndef(S2C_LOGOUT_REPLY_PB_H).
-define(S2C_LOGOUT_REPLY_PB_H, true).
-record(s2c_logout_reply, {
    ret = erlang:error({required, ret})
}).
-endif.

-ifndef(C2S_HEARTBEAT_REQUEST_PB_H).
-define(C2S_HEARTBEAT_REQUEST_PB_H, true).
-record(c2s_heartbeat_request, {
    
}).
-endif.

-ifndef(S2C_HEARTBEAT_REPLY_PB_H).
-define(S2C_HEARTBEAT_REPLY_PB_H, true).
-record(s2c_heartbeat_reply, {
    
}).
-endif.

