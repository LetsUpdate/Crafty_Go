import 'craftyAPI.dart';

class PlayerManager{
  final int _serverId;
  final CraftyClient _client;

  PlayerManager(this._serverId, this._client);

  Future<bool> runPlayerAction(PlayerActions playerAction,
      [String option = '']) async {
    String command ='';
    switch (playerAction){
      case PlayerActions.kill:
        command='kill';
        break;
      case PlayerActions.op:
        command='op';
        break;
      case PlayerActions.deOp:
        command='deop';
        break;
      case PlayerActions.kick:
        command='kick';
        break;
      case PlayerActions.ban:
        command='ban';
        break;
      case PlayerActions.tp:
        command='tp';
        break;
    }
    command += ' ' + option;
    return await _client.runCommand(_serverId, command.trim());
  }
}
enum PlayerActions {
  kill,
  op,
  deOp,
  kick,
  ban,
  tp,
}
