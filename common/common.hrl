%%%------------------------------------------------
%%% File    : common.hrl
%%% Author  : hanyan
%%% Created : 2017-11-09
%%% Description: 公共定义
%%%------------------------------------------------

%%tcp_server监听参数
-define(TCP_OPTIONS, [binary, {packet, 0}, {active, false}, {reuseaddr, true}, {nodelay, false}, {delay_send, true}, {send_timeout, 5000}, {keepalive, true}, {exit_on_close, true}]).


% %%打开发送消息客户端进程数量
% -define(SEND_MSG, 3).

% %%数据库连接
% -define(DB, db).
% -define(DB_HOST, "39.106.41.102").
% -define(DB_PORT, 3306).
% -define(DB_USER, "root").
% -define(DB_PASS, "20157411.adj").
% -define(DB_NAME, "db").
% -define(DB_ENCODE, utf8).

%%ETS
-define(ETS_ONLINE, ets_online).
-define(ETS_SCENE, ets_scene).
-define(ETS_ACCOUNT, ets_account).
-define(ETS_ROLE, ets_role).
-define(ETS_FRIEND, ets_friend).




