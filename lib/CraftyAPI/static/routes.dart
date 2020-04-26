class CraftyAPIRoutes {
  static const String HOST_STATS = '/api/v1/host_stats';
  static const String SERVER_STATS = '/api/v1/server_stats';
  static const String ADD_USER = '/api/v1/crafty/add_user';
  static const String DEL_USER = '/api/v1/crafty/del_user';
  static const String GET_LOGS = '/api/v1/crafty/get_logs';
  static const String SEARCH_LOGS = '/api/v1/crafty/search_logs';
}

class MCAPIRoutes {
  static const String SEND_CMD = '/api/v1/server/send_command';
  static const String GET_LOGS = '/api/v1/server/get_logs';
  static const String SEARCH_LOGS = '/api/v1/server/search_logs';
  static const String FORCE_BACKUP = '/api/v1/server/force_backup';
  static const String START = '/api/v1/server/start';
  static const String STOP = '/api/v1/server/stop';
  static const String RESTART = '/api/v1/server/restart';
  static const String LIST = '/api/v1/list_servers';
}
