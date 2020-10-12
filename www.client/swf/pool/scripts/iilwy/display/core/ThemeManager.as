package iilwy.display.core
{
   import flash.events.EventDispatcher;
   import flash.utils.getTimer;
   import iilwy.ui.events.ThemeEvent;
   import iilwy.ui.themes.BaseTheme;
   import iilwy.ui.themes.Theme;
   import iilwy.ui.themes.Themes;
   import iilwy.utils.logging.Logger;
   
   public class ThemeManager extends EventDispatcher
   {
       
      
      public var applicationTheme:Theme;
      
      public var userTheme:Theme;
      
      public var arcadeTheme:Theme;
      
      protected var logger:Logger;
      
      public function ThemeManager(applicationThemeClass:Class = null, userThemeClass:Class = null, arcadeThemeClass:Class = null)
      {
         super();
         var startTime:int = getTimer();
         var applicationTheme:Theme = Boolean(applicationThemeClass)?new applicationThemeClass():new BaseTheme();
         trace("Application Theme parsed: " + (getTimer() - startTime).toString());
         startTime = getTimer();
         var userTheme:Theme = Boolean(userThemeClass)?new userThemeClass():applicationTheme;
         trace("User Theme parsed: " + (getTimer() - startTime).toString());
         startTime = getTimer();
         var arcadeTheme:Theme = Boolean(arcadeThemeClass)?new arcadeThemeClass():applicationTheme;
         trace("Arcade Theme parsed: " + (getTimer() - startTime).toString());
         this.logger = Logger.getLogger(this);
         this.setTheme(Themes.APPLICATION_THEME,applicationTheme);
         this.setTheme(Themes.USER_THEME,userTheme);
         this.setTheme(Themes.ARCADE_THEME,arcadeTheme);
      }
      
      public function setTheme(which:String, theme:Theme) : void
      {
         this.logger.log("Setting ",which,theme);
         if(which == Themes.USER_THEME)
         {
            this.userTheme = theme;
            dispatchEvent(new ThemeEvent(ThemeEvent.THEME_CHANGED,Themes.USER_THEME));
         }
         else if(which == Themes.APPLICATION_THEME)
         {
            this.applicationTheme = theme;
            dispatchEvent(new ThemeEvent(ThemeEvent.THEME_CHANGED,Themes.APPLICATION_THEME));
         }
         else if(which == Themes.ARCADE_THEME)
         {
            this.arcadeTheme = theme;
            dispatchEvent(new ThemeEvent(ThemeEvent.THEME_CHANGED,Themes.ARCADE_THEME));
         }
      }
      
      public function getTheme(which:String) : Theme
      {
         var t:Theme = null;
         if(which == Themes.USER_THEME)
         {
            t = this.userTheme;
         }
         else if(which == Themes.APPLICATION_THEME)
         {
            t = this.applicationTheme;
         }
         else if(which == Themes.ARCADE_THEME)
         {
            t = this.arcadeTheme;
         }
         return t;
      }
   }
}
