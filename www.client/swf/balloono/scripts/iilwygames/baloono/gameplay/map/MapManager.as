package iilwygames.baloono.gameplay.map
{
   import com.partlyhuman.debug.Console;
   import com.partlyhuman.util.EmbedUtilities;
   import de.polygonal.ds.Array2;
   import de.polygonal.ds.Iterator;
   import de.polygonal.math.PM_PRNG;
   import iilwy.gamenet.utils.PlayerRoles;
   import iilwygames.baloono.BaloonoGame;
   import iilwygames.baloono.commands.AbstractCommand;
   import iilwygames.baloono.commands.BlockDamageCommand;
   import iilwygames.baloono.commands.ICommandResponder;
   import iilwygames.baloono.commands.PickupRemoveCommand;
   import iilwygames.baloono.commands.SuddenDeathCommand;
   import iilwygames.baloono.embedded.Maps;
   import iilwygames.baloono.embedded.SoundAssets;
   import iilwygames.baloono.gameplay.ITileItem;
   import iilwygames.baloono.gameplay.player.Player;
   import iilwygames.baloono.gameplay.player.PlayerManager;
   import iilwygames.baloono.gameplay.tiles.BlockTile;
   import iilwygames.baloono.gameplay.tiles.GroundTile;
   import iilwygames.baloono.gameplay.tiles.NullTile;
   import iilwygames.baloono.gameplay.tiles.PowerupTile;
   import iilwygames.baloono.gameplay.tiles.TileState;
   import iilwygames.baloono.graphics.AssetEvent;
   import iilwygames.baloono.graphics.AssetManager;
   
   public class MapManager implements ICommandResponder
   {
       
      
      private var _timerBetweenBlocks:int;
      
      public var mapNum:int;
      
      private var _minHeight:int = 5;
      
      private var _widthCount:int;
      
      public var currentMap:MapModel;
      
      public var spiralCW:Boolean = true;
      
      public var _suddenDeathMode:Boolean;
      
      public var _suddenDeathStartInitTime:uint;
      
      public var breakableBlockCount:int;
      
      public var filterMap:Array;
      
      private var _dirX:int;
      
      private var _dirY:int;
      
      private var _blockHeight:int;
      
      private var _blockWidth:int;
      
      public var _droppedBlockCount:int;
      
      private var _currX:int;
      
      private var _currY:int;
      
      protected var loadedMapNodes:XML;
      
      private var _initBlockDrop:int;
      
      private var suddenDeathVersion:int = 1;
      
      private var _heightCount:int;
      
      private var _minWidth:int = 0;
      
      private var _suddenDeathEnabled:Boolean = true;
      
      public function MapManager()
      {
         super();
         this.initialize();
         this.breakableBlockCount = 0;
         this._timerBetweenBlocks = 0;
         this._blockHeight = 0;
         this._blockWidth = 0;
         this._currX = 0;
         this._currY = 0;
         this._dirX = 0;
         this._dirY = 0;
         this._droppedBlockCount = 0;
         this._initBlockDrop = 0;
      }
      
      public function initSuddenDeath(param1:uint = 4.294967295E9) : void
      {
         this._suddenDeathMode = true;
         this._suddenDeathStartInitTime = BaloonoGame.time;
         this._timerBetweenBlocks = 500;
         this._blockHeight = this.currentMap.height;
         this._blockWidth = this.currentMap.width;
         this._droppedBlockCount = 0;
         this._widthCount = 0;
         this._heightCount = 0;
         this.chooseStartPoint();
         this._minWidth = this.currentMap.width - this.currentMap.height + this._minHeight;
      }
      
      private function stringToCharArray(param1:String) : Array2
      {
         var _loc5_:String = null;
         var _loc2_:Array2 = null;
         var _loc3_:Array = param1.replace(/[\t ]/g,"").split(/[\r\n]+/s);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_.length)
         {
            _loc5_ = _loc3_[_loc4_];
            if(_loc5_.length != 0)
            {
               if(_loc2_ == null)
               {
                  _loc2_ = new Array2(_loc5_.length,0);
               }
               _loc2_.appendRow(_loc5_.split(""));
            }
            _loc4_++;
         }
         return _loc2_;
      }
      
      protected function initialize() : void
      {
         this.loadedMapNodes = <maps/>;
         this.loadMapPackEmbedded(Maps.MapsBinary);
         this._suddenDeathMode = false;
         this._suddenDeathStartInitTime = 0;
         this._droppedBlockCount = 0;
         this._initBlockDrop = 0;
      }
      
      private function createCharacterToNodeLookup(param1:XMLList) : Object
      {
         var _loc3_:XML = null;
         var _loc2_:Object = new Object();
         for each(_loc3_ in param1)
         {
            _loc2_[_loc3_.@chr] = _loc3_;
         }
         return _loc2_;
      }
      
      private function dropNextBlock() : void
      {
         while(!(this.currentMap.blocks.get(this._currX,this._currY) is NullTile))
         {
            if(this._widthCount >= this.currentMap.width || this._heightCount >= this.currentMap.height)
            {
               this._suddenDeathMode = false;
               return;
            }
            if(this._dirX == 1)
            {
               if(this._blockWidth <= 1)
               {
                  this._dirX = 0;
                  this._dirY = 1;
                  if(!this.spiralCW)
                  {
                     this._dirY = -1;
                  }
                  this._heightCount++;
                  this._blockHeight = this.currentMap.height - this._heightCount;
               }
               else
               {
                  this._blockWidth--;
               }
            }
            else if(this._dirX == -1)
            {
               if(this._blockWidth <= 1)
               {
                  this._dirX = 0;
                  this._dirY = -1;
                  if(!this.spiralCW)
                  {
                     this._dirY = 1;
                  }
                  this._heightCount++;
                  this._blockHeight = this.currentMap.height - this._heightCount;
               }
               else
               {
                  this._blockWidth--;
               }
            }
            else if(this._dirY == 1)
            {
               if(this._blockHeight <= 1)
               {
                  this._dirX = -1;
                  this._dirY = 0;
                  if(!this.spiralCW)
                  {
                     this._dirX = 1;
                  }
                  this._widthCount++;
                  this._blockWidth = this.currentMap.width - this._widthCount;
               }
               else
               {
                  this._blockHeight--;
               }
            }
            else if(this._dirY == -1)
            {
               if(this._blockHeight <= 1)
               {
                  this._dirX = 1;
                  this._dirY = 0;
                  if(!this.spiralCW)
                  {
                     this._dirX = -1;
                  }
                  this._widthCount++;
                  this._blockWidth = this.currentMap.width - this._widthCount;
               }
               else
               {
                  this._blockHeight--;
               }
            }
            this._currX = this._currX + this._dirX;
            this._currY = this._currY + this._dirY;
         }
         if(this._widthCount + this._minWidth >= this.currentMap.width && this._heightCount + this._minHeight >= this.currentMap.height)
         {
            this._suddenDeathMode = false;
            return;
         }
         var _loc1_:BlockTile = new BlockTile();
         _loc1_.breakable = false;
         _loc1_.strength = Number.POSITIVE_INFINITY;
         _loc1_.setPosition(this._currX,this._currY);
         _loc1_.setArt(BaloonoGame.instance.assetManager.getGraphicSet("blocker"));
         _loc1_.graphicEntity.playAnimation("suddendeath",BaloonoGame.time);
         _loc1_.state = TileState.INACTIVE_ANIMATING;
         _loc1_.graphicEntity.addEventListener(AssetEvent.SEQUENCE_COMPLETE,_loc1_.onDropBlockAnimationComplete);
         this.currentMap.blocks.set(this._currX,this._currY,_loc1_);
         _loc1_.graphicEntity.redraw(BaloonoGame.time);
         BaloonoGame.instance.mapView.grid2.setTileAsDirty(_loc1_);
         this._droppedBlockCount++;
      }
      
      protected function initializeMap(param1:XML) : MapModel
      {
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc11_:String = null;
         var _loc12_:ITileItem = null;
         var _loc13_:GroundTile = null;
         var _loc14_:BlockTile = null;
         var _loc15_:Array2 = null;
         var _loc16_:Object = null;
         var _loc27_:Object = null;
         var _loc31_:Number = NaN;
         var _loc32_:XML = null;
         var _loc33_:String = null;
         var _loc35_:Number = NaN;
         var _loc36_:Number = NaN;
         var _loc37_:Object = null;
         var _loc38_:int = 0;
         var _loc39_:int = 0;
         var _loc40_:Object = null;
         var _loc41_:Array = null;
         var _loc42_:Array = null;
         var _loc43_:int = 0;
         var _loc44_:Array = null;
         var _loc45_:Player = null;
         var _loc4_:MapModel = new MapModel();
         var _loc17_:AssetManager = BaloonoGame.instance.assetManager;
         _loc4_.clearMap();
         this._suddenDeathMode = false;
         this._suddenDeathStartInitTime = 0;
         this._droppedBlockCount = 0;
         _loc15_ = this.stringToCharArray(param1.blockStrength.text());
         _loc8_ = _loc15_.width;
         _loc9_ = _loc15_.height;
         _loc4_.resizeArrays(_loc8_,_loc9_);
         var _loc18_:PM_PRNG = new PM_PRNG();
         _loc18_.seed = BaloonoGame.instance.gamenetController.randomSeed;
         _loc7_ = 0;
         while(_loc7_ < _loc9_)
         {
            _loc6_ = 0;
            while(_loc6_ < _loc8_)
            {
               _loc11_ = _loc15_.get(_loc6_,_loc7_);
               _loc12_ = null;
               switch(_loc11_)
               {
                  case "-":
                     _loc12_ = NullTile.NULL_TILE;
                     break;
                  case "*":
                     _loc14_ = new BlockTile();
                     _loc14_.breakable = false;
                     _loc14_.strength = Number.POSITIVE_INFINITY;
                     _loc12_ = _loc14_;
                     break;
                  default:
                     _loc31_ = parseInt(_loc11_,36);
                     if(isNaN(_loc31_))
                     {
                        if(BaloonoGame.instance.DEBUG_LOGGING)
                        {
                           Console.error("Invalid Strength");
                           break;
                        }
                        break;
                     }
                     if(_loc18_.nextDoubleRange(0,1) < BaloonoGame.instance.blockThresh)
                     {
                        _loc14_ = new BlockTile();
                        _loc14_.breakable = true;
                        _loc14_.strength = _loc31_;
                        _loc12_ = _loc14_;
                        break;
                     }
                     _loc12_ = NullTile.NULL_TILE;
                     break;
               }
               _loc4_.blocks.set(_loc6_,_loc7_,_loc12_);
               _loc12_.setPosition(_loc6_,_loc7_);
               _loc6_++;
            }
            _loc7_++;
         }
         _loc15_ = this.stringToCharArray(param1.ground.text());
         _loc16_ = this.createCharacterToEntityLookup(param1.groundArt.art);
         _loc7_ = 0;
         while(_loc7_ < _loc9_)
         {
            _loc6_ = 0;
            while(_loc6_ < _loc8_)
            {
               _loc11_ = _loc15_.get(_loc6_,_loc7_);
               if(_loc11_ in _loc16_)
               {
                  _loc13_ = new GroundTile();
                  _loc13_.setArt(_loc16_[_loc11_]);
                  _loc13_.setPosition(_loc6_,_loc7_);
                  _loc4_.ground.set(_loc6_,_loc7_,_loc13_);
               }
               else if(BaloonoGame.instance.DEBUG_LOGGING)
               {
                  Console.error("Character used in map diagram not specified");
               }
               _loc6_++;
            }
            _loc7_++;
         }
         _loc15_ = this.stringToCharArray(param1.block.text());
         _loc16_ = this.createCharacterToEntityLookup(param1.blockArt.art);
         _loc7_ = 0;
         while(_loc7_ < _loc9_)
         {
            _loc6_ = 0;
            while(_loc6_ < _loc8_)
            {
               if(_loc4_.blocks.get(_loc6_,_loc7_) is BlockTile)
               {
                  _loc11_ = _loc15_.get(_loc6_,_loc7_);
                  if(_loc11_ != "-")
                  {
                     if(_loc11_ in _loc16_)
                     {
                        ITileItem(_loc4_.blocks.get(_loc6_,_loc7_)).setArt(_loc16_[_loc11_]);
                     }
                     else if(BaloonoGame.instance.DEBUG_LOGGING)
                     {
                        Console.error("Art not found for tile");
                     }
                  }
               }
               _loc6_++;
            }
            _loc7_++;
         }
         _loc15_ = this.stringToCharArray(param1.powerup.text());
         _loc16_ = this.createCharacterToNodeLookup(param1.powerups.powerup);
         _loc7_ = 0;
         while(_loc7_ < _loc9_)
         {
            _loc6_ = 0;
            while(_loc6_ < _loc8_)
            {
               if(_loc4_.blocks.get(_loc6_,_loc7_) is BlockTile)
               {
                  _loc11_ = _loc15_.get(_loc6_,_loc7_);
                  if(_loc11_ != "-")
                  {
                     if(_loc11_ in _loc16_)
                     {
                        _loc32_ = _loc16_[_loc11_];
                        _loc14_ = _loc4_.blocks.get(_loc6_,_loc7_);
                        if(_loc14_ is BlockTile && BaloonoGame.instance.itemExistRand.nextDouble() < parseFloat(_loc32_.@probability))
                        {
                           _loc33_ = _loc32_.@type;
                           if(_loc33_ == "*")
                           {
                              _loc33_ = null;
                           }
                           _loc14_.contents = BaloonoGame.instance.powerupFactory.createPowerup(_loc33_);
                        }
                     }
                  }
               }
               _loc6_++;
            }
            _loc7_++;
         }
         _loc15_ = this.stringToCharArray(param1.playerStartPositions.text());
         var _loc19_:Array = new Array();
         var _loc20_:Number = (_loc8_ + 1) / 2 - 1;
         var _loc21_:Number = (_loc9_ + 1) / 2 - 1;
         _loc7_ = 0;
         while(_loc7_ < _loc9_)
         {
            _loc6_ = 0;
            while(_loc6_ < _loc8_)
            {
               _loc11_ = _loc15_.get(_loc6_,_loc7_);
               if(_loc11_ != "-")
               {
                  _loc35_ = parseInt(_loc11_,36);
                  if(isNaN(_loc35_))
                  {
                     if(BaloonoGame.instance.DEBUG_LOGGING)
                     {
                        Console.error("Invalid player marker in map: " + _loc11_);
                     }
                  }
                  else
                  {
                     _loc36_ = Math.sqrt((_loc6_ - _loc20_) * (_loc6_ - _loc20_) + (_loc7_ - _loc21_) * (_loc7_ - _loc21_));
                     _loc37_ = {
                        "x":_loc6_,
                        "y":_loc7_,
                        "centerDist":_loc36_
                     };
                     _loc19_.push(_loc37_);
                  }
               }
               _loc6_++;
            }
            _loc7_++;
         }
         var _loc22_:Array = this.groupByDistance(_loc19_);
         var _loc23_:PM_PRNG = new PM_PRNG();
         _loc23_.seed = BaloonoGame.instance.gamenetController.randomSeed;
         var _loc24_:PlayerManager = BaloonoGame.instance.playerManager;
         var _loc25_:Number = -1;
         var _loc26_:Number = -1;
         var _loc28_:Array = new Array();
         var _loc29_:int = 0;
         while(_loc29_ < _loc24_.playerCount)
         {
            _loc38_ = 0;
            while(_loc38_ < _loc22_.length)
            {
               if(_loc25_ == -1 && _loc26_ == -1)
               {
                  if(_loc22_[_loc38_].choice.length > 0)
                  {
                     _loc39_ = Math.floor(_loc22_[_loc38_].choice.length * _loc23_.nextDoubleRange(0,1));
                     _loc27_ = _loc22_[_loc38_].choice[_loc39_];
                     _loc25_ = _loc27_.x;
                     _loc26_ = _loc27_.y;
                     _loc28_.push(_loc27_);
                     _loc22_[_loc38_].choice.splice(_loc39_,1);
                     _loc38_--;
                  }
               }
               else if(_loc22_[_loc38_].choice.length > 0)
               {
                  _loc40_ = this.findSelectionCenter(_loc28_);
                  _loc25_ = _loc40_.x;
                  _loc26_ = _loc40_.y;
                  _loc41_ = _loc22_[_loc38_].choice;
                  _loc42_ = new Array();
                  _loc43_ = 0;
                  while(_loc43_ < _loc41_.length)
                  {
                     _loc36_ = Math.sqrt((_loc41_[_loc43_].x - _loc25_) * (_loc41_[_loc43_].x - _loc25_) + (_loc41_[_loc43_].y - _loc26_) * (_loc41_[_loc43_].y - _loc26_));
                     _loc37_ = {
                        "x":_loc41_[_loc43_].x,
                        "y":_loc41_[_loc43_].y,
                        "centerDist":_loc36_,
                        "originalPos":_loc43_
                     };
                     _loc42_.push(_loc37_);
                     _loc43_++;
                  }
                  _loc44_ = this.groupByDistance(_loc42_);
                  _loc39_ = Math.floor(_loc44_[0].choice.length * _loc23_.nextDoubleRange(0,1));
                  _loc27_ = _loc44_[0].choice[_loc39_];
                  _loc22_[_loc38_].choice.splice(_loc27_.originalPos,1);
                  _loc28_.push(_loc27_);
                  _loc38_--;
               }
               _loc38_++;
            }
            _loc29_++;
         }
         var _loc30_:Array = new Array();
         _loc29_ = 0;
         while(_loc29_ < _loc24_.playerCount)
         {
            _loc39_ = Math.floor(_loc28_.length * _loc23_.nextDoubleRange(0,1));
            _loc30_.push(_loc28_[_loc39_]);
            _loc28_.splice(_loc39_,1);
            _loc29_++;
         }
         _loc29_ = 0;
         while(_loc29_ < _loc24_.playerCount)
         {
            _loc45_ = _loc24_.getPlayerByIndex(_loc29_);
            if(_loc45_)
            {
               _loc45_.setPosition(_loc30_[_loc29_].x,_loc30_[_loc29_].y);
            }
            _loc29_++;
         }
         if(this.filterMap && BaloonoGame.instance.gamenetController.playerRole == PlayerRoles.SPECTATOR)
         {
            _loc7_ = 0;
            while(_loc7_ < _loc9_)
            {
               _loc6_ = 0;
               while(_loc6_ < _loc8_)
               {
                  if(this.filterMap[_loc7_ * _loc8_ + _loc6_] == false)
                  {
                     _loc4_.blocks.set(_loc6_,_loc7_,NullTile.NULL_TILE);
                  }
                  _loc6_++;
               }
               _loc7_++;
            }
         }
         _loc4_.bombs.fill(NullTile.NULL_TILE);
         _loc4_.explosions.fill(NullTile.NULL_TILE);
         this.filterMap = null;
         BaloonoGame.instance.assetManager.getGraphicSet("bomb");
         BaloonoGame.instance.assetManager.getGraphicSet("explosion");
         return _loc4_;
      }
      
      public function setMapByName(param1:String) : void
      {
         var results:XMLList = null;
         var mapName:String = param1;
         results = this.loadedMapNodes.map.(@name == mapName);
         if(results && results.length() == 1)
         {
            this.currentMap = this.initializeMap(results[0]);
         }
         else if(BaloonoGame.instance.DEBUG_LOGGING)
         {
            Console.error("Problem loading map in setMapByName()");
         }
      }
      
      private function findSelectionCenter(param1:Array) : Object
      {
         var _loc2_:Number = 0;
         var _loc3_:Number = 0;
         var _loc4_:int = 0;
         while(_loc4_ < param1.length)
         {
            _loc2_ = _loc2_ + param1[_loc4_].x;
            _loc3_ = _loc3_ + param1[_loc4_].y;
            _loc4_++;
         }
         _loc2_ = _loc2_ / param1.length;
         _loc3_ = _loc3_ / param1.length;
         return {
            "x":_loc2_,
            "y":_loc3_
         };
      }
      
      private function createCharacterToEntityLookup(param1:XMLList) : Object
      {
         var _loc4_:XML = null;
         var _loc2_:Object = new Object();
         var _loc3_:AssetManager = BaloonoGame.instance.assetManager;
         for each(_loc4_ in param1)
         {
            _loc2_[_loc4_.@chr] = _loc3_.getGraphicSet(_loc4_.@entity);
         }
         return _loc2_;
      }
      
      public function update(param1:uint) : void
      {
         if(this._suddenDeathMode && BaloonoGame.time - this._suddenDeathStartInitTime >= 30000)
         {
            if(this._timerBetweenBlocks > 0)
            {
               this._timerBetweenBlocks = this._timerBetweenBlocks - param1;
               if(this._timerBetweenBlocks <= 0)
               {
                  this._timerBetweenBlocks = 0;
               }
            }
            if(this._timerBetweenBlocks == 0)
            {
               if(this._initBlockDrop > 0)
               {
                  while(this._droppedBlockCount < this._initBlockDrop)
                  {
                     this.dropNextBlock();
                  }
                  this._initBlockDrop = 0;
               }
               else
               {
                  this.dropNextBlock();
               }
               this._timerBetweenBlocks = 500;
            }
         }
      }
      
      protected function chooseStartPoint() : void
      {
         this.spiralCW = true;
         this._currX = 0;
         this._currY = 0;
         if(this.spiralCW)
         {
            this._dirX = 1;
            this._dirY = 0;
         }
         else
         {
            this._dirX = 0;
            this._dirY = 1;
         }
      }
      
      public function loadMapPack(param1:XML) : void
      {
         var _loc2_:XML = null;
         for each(_loc2_ in param1.map)
         {
            this.loadedMapNodes.appendChild(_loc2_);
         }
      }
      
      public function respondToCommand(param1:AbstractCommand) : Boolean
      {
         var _loc2_:BlockDamageCommand = null;
         var _loc3_:BlockTile = null;
         var _loc4_:PickupRemoveCommand = null;
         var _loc5_:PowerupTile = null;
         if(param1 is BlockDamageCommand)
         {
            _loc2_ = BlockDamageCommand(param1);
            _loc3_ = this.currentMap.blocks.get(_loc2_.x,_loc2_.y) as BlockTile;
            if(!_loc3_)
            {
               if(BaloonoGame.instance.DEBUG_LOGGING)
               {
                  Console.error("MapManager responding to block damage command referring to block which no longer exists");
               }
            }
            else if(_loc3_.state.active)
            {
               this.breakableBlockCount--;
               _loc3_.respondToCommand(_loc2_);
               if(this.breakableBlockCount == 0 && this._suddenDeathEnabled)
               {
                  if(this.currentMap.getNumberOfBreakableBlocks() == 0)
                  {
                     if(this.suddenDeathVersion == 0)
                     {
                        BaloonoGame.instance.bombManager.initSuddenDeath();
                     }
                     else
                     {
                        this.initSuddenDeath();
                     }
                  }
               }
            }
         }
         else if(param1 is PickupRemoveCommand)
         {
            _loc4_ = PickupRemoveCommand(param1);
            _loc5_ = this.currentMap.powerups.get(_loc4_.x,_loc4_.y) as PowerupTile;
            if(!_loc5_)
            {
               if(BaloonoGame.instance.DEBUG_LOGGING)
               {
                  Console.error("MapManager responding to powerup pickup command referring to pickup which no longer exists");
               }
               return false;
            }
            BaloonoGame.instance.soundAssets.playSound(SoundAssets.POWERUP);
            this.currentMap.powerups.set(_loc4_.x,_loc4_.y,null);
            BaloonoGame.instance.mapView.removeTile(_loc5_);
         }
         return true;
      }
      
      public function setRandomMap(param1:int = -1) : void
      {
         if(this.loadedMapNodes.length() > 0)
         {
            if(param1 == -1)
            {
               if(BaloonoGame.instance.gamenetController.playerList.length <= 4)
               {
                  this.mapNum = 0;
               }
               else
               {
                  this.mapNum = 1;
               }
            }
            else
            {
               this.mapNum = param1;
            }
            this.currentMap = this.initializeMap(this.loadedMapNodes.map[this.mapNum]);
            this.breakableBlockCount = this.currentMap.getNumberOfBreakableBlocks();
            if(BaloonoGame.instance.DEBUG_LOGGING)
            {
               Console.log("Map initialized.");
            }
         }
         else if(BaloonoGame.instance.DEBUG_LOGGING)
         {
            Console.error("No maps loaded when trying to setRandomMap()");
         }
      }
      
      public function initSpectatorSuddenDeath(param1:uint, param2:int) : void
      {
         var _loc4_:BlockTile = null;
         this._suddenDeathMode = true;
         this._suddenDeathStartInitTime = param1;
         this._timerBetweenBlocks = 0;
         this._blockHeight = this.currentMap.height;
         this._blockWidth = this.currentMap.width;
         this._minWidth = this.currentMap.width - this.currentMap.height + this._minHeight;
         this.chooseStartPoint();
         this._droppedBlockCount = 0;
         this._widthCount = 0;
         this._heightCount = 0;
         var _loc3_:Array = this.currentMap.blocks.getArray();
         var _loc5_:int = 0;
         while(_loc5_ < _loc3_.length)
         {
            _loc4_ = _loc3_[_loc5_] as BlockTile;
            if(_loc4_ && _loc4_.breakable)
            {
               _loc3_[_loc5_] = NullTile.NULL_TILE;
            }
            _loc5_++;
         }
         this._initBlockDrop = param2;
      }
      
      private function groupByDistance(param1:Array) : Array
      {
         var _loc5_:* = null;
         var _loc6_:Array = null;
         var _loc7_:Object = null;
         var _loc2_:Object = new Object();
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            if(!_loc2_[param1[_loc3_].centerDist])
            {
               _loc6_ = new Array();
               _loc6_.push(param1[_loc3_]);
               _loc2_[param1[_loc3_].centerDist] = _loc6_;
            }
            else
            {
               _loc2_[param1[_loc3_].centerDist].push(param1[_loc3_]);
            }
            _loc3_++;
         }
         var _loc4_:Array = new Array();
         for(_loc5_ in _loc2_)
         {
            _loc7_ = {
               "distance":_loc2_[_loc5_][0].centerDist,
               "choice":_loc2_[_loc5_]
            };
            _loc4_.push(_loc7_);
         }
         _loc4_ = _loc4_.sortOn("distance",Array.NUMERIC | Array.DESCENDING);
         return _loc4_;
      }
      
      public function loadMapPackEmbedded(param1:Class) : void
      {
         this.loadMapPack(EmbedUtilities.classToXML(param1));
      }
      
      public function endSuddenDeath() : void
      {
         this._suddenDeathMode = false;
         this._currX = 0;
         this._currY = 0;
         this._dirX = 0;
         this._dirY = 0;
         this._droppedBlockCount = 0;
         this._initBlockDrop = 0;
      }
      
      public function checkMapStatus() : void
      {
         var _loc1_:SuddenDeathCommand = null;
         this.breakableBlockCount--;
         if(this.breakableBlockCount == 0 && this._suddenDeathEnabled)
         {
            if(this.currentMap.getNumberOfBreakableBlocks() == 0)
            {
               if(this.suddenDeathVersion == 0)
               {
                  BaloonoGame.instance.bombManager.initSuddenDeath();
               }
               else
               {
                  this.initSuddenDeath();
               }
               if(BaloonoGame.instance.gamenetController.playerRole == PlayerRoles.HOST)
               {
                  _loc1_ = new SuddenDeathCommand(BaloonoGame.time);
                  _loc1_.suddenDeathInitTime = this._suddenDeathStartInitTime;
                  BaloonoGame.instance.commandDispatcher.enqueueCommand(_loc1_,false,true);
               }
            }
         }
      }
   }
}
