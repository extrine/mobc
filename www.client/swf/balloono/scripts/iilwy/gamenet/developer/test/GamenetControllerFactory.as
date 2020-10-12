package iilwy.gamenet.developer.test
{
   import iilwy.gamenet.developer.GamenetController;
   import iilwy.gamenet.developer.GamenetPlayerData;
   import iilwy.gamenet.developer.PlayerRoles;
   import flash.external.ExternalInterface;

   public class GamenetControllerFactory
   {


      public function GamenetControllerFactory()
      {
         super();
      }

      public static function createTest(param1:int = 7, param2:Boolean = false) : GamenetController
      {
        var player_data:GamenetPlayerData = null;
         var game_controller:GamenetController = new GamenetController();
         game_controller.playerList = [];
         game_controller.chatMessageList = [];
         var js_users:* = ExternalInterface.call("swf.players","");
         var js_me:* = ExternalInterface.call("swf.user","");
         var a=0;
         var shh = js_users.length;
         var shhshh = shh
         while(a<shh){
            player_data = new GamenetPlayerData();
            player_data.profileName = js_users[a].username;
            player_data.playerJid = js_users[a].username;
            player_data.profileId = js_users[a].username;
            player_data.profileLocation = "City, ST, USA";
            player_data.profileCatchPhrase = "Lorem ipsum sit olor damet";
            player_data.profilePhoto = js_users[a].image || "https://www.omgmobc.com/img/profile.png?1";
            player_data.profileAge = 25;
            game_controller.playerList.push(player_data);

            if(a==0) {
               game_controller.host = player_data
               // ExternalInterface.call("u.log",js_users[a].username+' is host ' );
            }
            if(js_users[a].username == js_me.username){
               game_controller.playerData = player_data
               game_controller.player = player_data
               if(a==0) {
                  // ExternalInterface.call("u.log",js_users[a].username+' is me the host ' );
                  game_controller.playerRole = PlayerRoles.HOST;
               }else if(a>7) {
                  game_controller.playerRole = PlayerRoles.SPECTATOR;
                  // ExternalInterface.call("u.log",js_users[a].username+' is me the spectator ' );
               } else{
                  // ExternalInterface.call("u.log",js_users[a].username+' is me the player ' );
                  game_controller.playerRole = PlayerRoles.PLAYER;
               }
            }
            a++
         }

         game_controller.hostData = game_controller.host;
         game_controller.playerData = game_controller.player;
         game_controller.setSyncedTime(ExternalInterface.call("swf.room","").round.updated);
         //game_controller.setSyncedTime(new Date().time);
         game_controller.randomSeed = ExternalInterface.call("swf.seed","");
         game_controller.startTime = new Date().time /*+ 2000*/ ;
         return game_controller;
      }
   }
}
