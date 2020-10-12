package gs
{
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.geom.ColorTransform;
   import flash.media.SoundChannel;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   import flash.utils.getTimer;
   
   public class TweenLite
   {
      
      public static var version:Number = 6.05;
      
      public static var killDelayedCallsTo:Function = killTweensOf;
      
      protected static var _all:Dictionary = new Dictionary();
      
      private static var _sprite:Sprite = new Sprite();
      
      private static var _listening:Boolean;
      
      private static var _timer:Timer = new Timer(2000);
       
      
      public var duration:Number;
      
      public var vars:Object;
      
      public var delay:Number;
      
      public var startTime:uint;
      
      public var initTime:uint;
      
      public var tweens:Object;
      
      public var target:Object;
      
      protected var _active:Boolean;
      
      protected var _subTweens:Array;
      
      protected var _hst:Boolean;
      
      protected var _initted:Boolean;
      
      public function TweenLite($target:Object, $duration:Number, $vars:Object)
      {
         super();
         if($target == null)
         {
            return;
         }
         if($vars.overwrite != false && $target != null || _all[$target] == undefined)
         {
            delete _all[$target];
            _all[$target] = new Dictionary();
         }
         _all[$target][this] = this;
         this.vars = $vars;
         this.duration = Number($duration) || Number(0.001);
         this.delay = Number($vars.delay) || Number(0);
         this.target = $target;
         if(!(this.vars.ease is Function))
         {
            this.vars.ease = defaultEase;
         }
         if(this.vars.easeParams != null)
         {
            this.vars.proxiedEase = this.vars.ease;
            this.vars.ease = this.easeProxy;
         }
         if(this.vars.mcColor != null)
         {
            this.vars.tint = this.vars.mcColor;
         }
         if(!isNaN(Number(this.vars.autoAlpha)))
         {
            this.vars.alpha = Number(this.vars.autoAlpha);
         }
         this.tweens = {};
         this._subTweens = [];
         this._hst = this._initted = false;
         this._active = $duration == 0 && this.delay == 0;
         this.initTime = getTimer();
         if(this.vars.runBackwards == true && this.vars.renderOnStart != true || this._active)
         {
            this.initTweenVals();
            this.startTime = getTimer();
            if(this._active)
            {
               this.render(this.startTime + 1);
            }
            else
            {
               this.render(this.startTime);
            }
         }
         if(!_listening && !this._active)
         {
            _sprite.addEventListener(Event.ENTER_FRAME,executeAll);
            _timer.addEventListener("timer",killGarbage);
            _timer.start();
            _listening = true;
         }
      }
      
      public static function to($target:Object, $duration:Number, $vars:Object) : TweenLite
      {
         return new TweenLite($target,$duration,$vars);
      }
      
      public static function from($target:Object, $duration:Number, $vars:Object) : TweenLite
      {
         $vars.runBackwards = true;
         return new TweenLite($target,$duration,$vars);
      }
      
      public static function delayedCall($delay:Number, $onComplete:Function, $onCompleteParams:Array = null, $onCompleteScope:* = null) : TweenLite
      {
         return new TweenLite($onComplete,0,{
            "delay":$delay,
            "onComplete":$onComplete,
            "onCompleteParams":$onCompleteParams,
            "onCompleteScope":$onCompleteScope,
            "overwrite":false
         });
      }
      
      public static function executeAll($e:Event = null) : void
      {
         var p:* = null;
         var tw:* = null;
         var a:Dictionary = _all;
         var t:uint = getTimer();
         for(p in a)
         {
            for(tw in a[p])
            {
               if(a[p][tw] != undefined && a[p][tw].active)
               {
                  a[p][tw].render(t);
                  if(a[p] == undefined)
                  {
                     break;
                  }
               }
            }
         }
      }
      
      public static function removeTween($t:TweenLite = null) : void
      {
         if($t != null && _all[$t.target] != undefined)
         {
            delete _all[$t.target][$t];
         }
      }
      
      public static function killTweensOf($tg:Object = null, $complete:Boolean = false) : void
      {
         var o:Object = null;
         var tw:* = undefined;
         if($tg != null && _all[$tg] != undefined)
         {
            if($complete)
            {
               o = _all[$tg];
               for(tw in o)
               {
                  o[tw].complete(false);
               }
            }
            delete _all[$tg];
         }
      }
      
      public static function killGarbage($e:TimerEvent) : void
      {
         var found:Boolean = false;
         var p:* = null;
         var twp:* = null;
         var tw:Object = null;
         var tg_cnt:uint = 0;
         for(p in _all)
         {
            found = false;
            for(twp in _all[p])
            {
               found = true;
            }
            if(!found)
            {
               delete _all[p];
            }
            else
            {
               tg_cnt++;
            }
         }
         if(tg_cnt == 0)
         {
            _sprite.removeEventListener(Event.ENTER_FRAME,executeAll);
            _timer.removeEventListener("timer",killGarbage);
            _timer.stop();
            _listening = false;
         }
      }
      
      public static function defaultEase($t:Number, $b:Number, $c:Number, $d:Number) : Number
      {
         return -$c * ($t = $t / $d) * ($t - 2) + $b;
      }
      
      public static function tintProxy($o:Object) : void
      {
         var n:Number = $o.target.progress;
         var r:Number = 1 - n;
         $o.info.target.transform.colorTransform = new ColorTransform($o.info.color.redMultiplier * r + $o.info.endColor.redMultiplier * n,$o.info.color.greenMultiplier * r + $o.info.endColor.greenMultiplier * n,$o.info.color.blueMultiplier * r + $o.info.endColor.blueMultiplier * n,$o.info.color.alphaMultiplier * r + $o.info.endColor.alphaMultiplier * n,$o.info.color.redOffset * r + $o.info.endColor.redOffset * n,$o.info.color.greenOffset * r + $o.info.endColor.greenOffset * n,$o.info.color.blueOffset * r + $o.info.endColor.blueOffset * n,$o.info.color.alphaOffset * r + $o.info.endColor.alphaOffset * n);
      }
      
      public static function frameProxy($o:Object) : void
      {
         $o.info.target.gotoAndStop(Math.round($o.target.frame));
      }
      
      public static function volumeProxy($o:Object) : void
      {
         $o.info.target.soundTransform = $o.target;
      }
      
      public function initTweenVals($hrp:Boolean = false, $reservedProps:String = "") : void
      {
         var p:* = null;
         var endArray:Array = null;
         var i:int = 0;
         var clr:ColorTransform = null;
         var endClr:ColorTransform = null;
         var tp:Object = null;
         var isDO:Boolean = this.target is DisplayObject;
         if(this.target is Array)
         {
            endArray = this.vars.endArray || [];
            for(i = 0; i < endArray.length; i++)
            {
               if(this.target[i] != endArray[i] && this.target[i] != undefined)
               {
                  this.tweens[i.toString()] = {
                     "o":this.target,
                     "p":i.toString(),
                     "s":this.target[i],
                     "c":endArray[i] - this.target[i]
                  };
               }
            }
         }
         else
         {
            for(p in this.vars)
            {
               if(!(p == "ease" || p == "delay" || p == "overwrite" || p == "onComplete" || p == "onCompleteParams" || p == "onCompleteScope" || p == "runBackwards" || p == "onUpdate" || p == "onUpdateParams" || p == "onUpdateScope" || p == "autoAlpha" || p == "onStart" || p == "onStartParams" || p == "onStartScope" || p == "renderOnStart" || p == "easeParams" || p == "mcColor" || p == "type" || $hrp && $reservedProps.indexOf(" " + p + " ") != -1))
               {
                  if(p == "tint" && isDO)
                  {
                     clr = this.target.transform.colorTransform;
                     endClr = new ColorTransform();
                     if(this.vars.alpha != undefined)
                     {
                        endClr.alphaMultiplier = this.vars.alpha;
                        delete this.vars.alpha;
                        delete this.tweens.alpha;
                     }
                     else
                     {
                        endClr.alphaMultiplier = this.target.alpha;
                     }
                     if(this.vars[p] != null && this.vars[p] != "")
                     {
                        endClr.color = this.vars[p];
                     }
                     this.addSubTween(tintProxy,{"progress":0},{"progress":1},{
                        "target":this.target,
                        "color":clr,
                        "endColor":endClr
                     });
                  }
                  else if(p == "frame" && isDO)
                  {
                     this.addSubTween(frameProxy,{"frame":this.target.currentFrame},{"frame":this.vars[p]},{"target":this.target});
                  }
                  else if(p == "volume" && (isDO || this.target is SoundChannel))
                  {
                     this.addSubTween(volumeProxy,this.target.soundTransform,{"volume":this.vars[p]},{"target":this.target});
                  }
                  else if(this.target.hasOwnProperty(p))
                  {
                     if(typeof this.vars[p] == "number")
                     {
                        this.tweens[p] = {
                           "o":this.target,
                           "p":p,
                           "s":this.target[p],
                           "c":this.vars[p] - this.target[p]
                        };
                     }
                     else
                     {
                        this.tweens[p] = {
                           "o":this.target,
                           "p":p,
                           "s":this.target[p],
                           "c":Number(this.vars[p])
                        };
                     }
                  }
               }
            }
         }
         if(this.vars.runBackwards == true)
         {
            for(p in this.tweens)
            {
               tp = this.tweens[p];
               tp.s = tp.s + tp.c;
               tp.c = tp.c * -1;
            }
         }
         if(typeof this.vars.autoAlpha == "number")
         {
            this.target.visible = !(this.vars.runBackwards == true && this.target.alpha == 0);
         }
         this._initted = true;
      }
      
      protected function addSubTween($proxy:Function, $target:Object, $props:Object, $info:Object = null) : void
      {
         var p:* = null;
         this._subTweens.push({
            "proxy":$proxy,
            "target":$target,
            "info":$info
         });
         for(p in $props)
         {
            if($target.hasOwnProperty(p))
            {
               if(typeof $props[p] == "number")
               {
                  this.tweens["st" + this._subTweens.length + "_" + p] = {
                     "o":$target,
                     "p":p,
                     "s":$target[p],
                     "c":$props[p] - $target[p]
                  };
               }
               else
               {
                  this.tweens["st" + this._subTweens.length + "_" + p] = {
                     "o":$target,
                     "p":p,
                     "s":$target[p],
                     "c":Number($props[p])
                  };
               }
            }
         }
         this._hst = true;
      }
      
      public function render($t:uint) : void
      {
         var tp:Object = null;
         var p:* = null;
         var i:uint = 0;
         var time:Number = ($t - this.startTime) / 1000;
         if(time > this.duration)
         {
            time = this.duration;
         }
         var factor:Number = this.vars.ease(time,0,1,this.duration);
         for(p in this.tweens)
         {
            tp = this.tweens[p];
            tp.o[tp.p] = tp.s + factor * tp.c;
         }
         if(this._hst)
         {
            for(i = 0; i < this._subTweens.length; i++)
            {
               this._subTweens[i].proxy(this._subTweens[i]);
            }
         }
         if(this.vars.onUpdate != null)
         {
            this.vars.onUpdate.apply(this.vars.onUpdateScope,this.vars.onUpdateParams);
         }
         if(time == this.duration)
         {
            this.complete(true);
         }
      }
      
      public function complete($skipRender:Boolean = false) : void
      {
         if(!$skipRender)
         {
            if(!this._initted)
            {
               this.initTweenVals();
            }
            this.startTime = 0;
            this.render(this.duration * 1000);
            return;
         }
         if(typeof this.vars.autoAlpha == "number" && this.target.alpha == 0)
         {
            this.target.visible = false;
         }
         if(this.vars.onComplete != null)
         {
            this.vars.onComplete.apply(this.vars.onCompleteScope,this.vars.onCompleteParams);
         }
         removeTween(this);
      }
      
      protected function easeProxy($t:Number, $b:Number, $c:Number, $d:Number) : Number
      {
         return this.vars.proxiedEase.apply(null,arguments.concat(this.vars.easeParams));
      }
      
      public function get active() : Boolean
      {
         if(this._active)
         {
            return true;
         }
         if((getTimer() - this.initTime) / 1000 > this.delay)
         {
            this._active = true;
            this.startTime = this.initTime + this.delay * 1000;
            if(!this._initted)
            {
               this.initTweenVals();
            }
            else if(typeof this.vars.autoAlpha == "number")
            {
               this.target.visible = true;
            }
            if(this.vars.onStart != null)
            {
               this.vars.onStart.apply(this.vars.onStartScope,this.vars.onStartParams);
            }
            if(this.duration == 0.001)
            {
               this.startTime = this.startTime - 1;
            }
            return true;
         }
         return false;
      }
   }
}
