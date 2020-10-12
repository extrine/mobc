package org.igniterealtime.xiff.vcard
{
   import flash.events.EventDispatcher;
   import flash.events.TimerEvent;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   import flash.xml.XMLDocument;
   import org.igniterealtime.xiff.core.EscapedJID;
   import org.igniterealtime.xiff.core.UnescapedJID;
   import org.igniterealtime.xiff.core.XMPPConnection;
   import org.igniterealtime.xiff.data.IQ;
   import org.igniterealtime.xiff.data.XMPPStanza;
   import org.igniterealtime.xiff.data.vcard.VCardExtension;
   import org.igniterealtime.xiff.events.VCardEvent;
   import org.igniterealtime.xiff.util.DateTimeParser;
   
   [Event(name="saveError",type="org.igniterealtime.xiff.events.VCardEvent")]
   [Event(name="saved",type="org.igniterealtime.xiff.events.VCardEvent")]
   [Event(name="loaded",type="org.igniterealtime.xiff.events.VCardEvent")]
   public class VCard extends EventDispatcher
   {
      
      public static var cacheFlushInterval:Number = 6 * 60 * 60 * 1000;
      
      private static var cache:Dictionary = new Dictionary();
      
      private static var cacheFlushTimer:Timer = new Timer(cacheFlushInterval,0);
      
      private static var requestQueue:Array = [];
      
      private static var requestTimer:Timer;
       
      
      public var birthday:Date;
      
      public var description:String;
      
      public var email:String;
      
      public var formattedName:String;
      
      public var geographicalPosition:VCardGeographicalPosition;
      
      public var homeAddress:VCardAddress;
      
      public var homeAddressLabel:String;
      
      public var homeTelephone:VCardTelephone;
      
      public var jid:UnescapedJID;
      
      public var logo:VCardPhoto;
      
      public var mailer:String;
      
      public var name:VCardName;
      
      public var nickname:String;
      
      public var note:String;
      
      public var organization:VCardOrganization;
      
      public var photo:VCardPhoto;
      
      public var privacyClass:String;
      
      public var productID:String;
      
      public var revision:Date;
      
      public var role:String;
      
      public var sortString:String;
      
      public var sound:VCardSound;
      
      public var timezone:Date;
      
      public var title:String;
      
      public var uid:String;
      
      public var url:String;
      
      public var version:String;
      
      public var workAddress:VCardAddress;
      
      public var workAddressLabel:String;
      
      public var workTelephone:VCardTelephone;
      
      private var extensionNames:Array;
      
      private var _loaded:Boolean;
      
      private var _extensions:Dictionary;
      
      public function VCard()
      {
         this.extensionNames = [];
         this._extensions = new Dictionary();
         super();
      }
      
      public static function getVCard(connection:XMPPConnection, jid:UnescapedJID) : VCard
      {
         if(!cacheFlushTimer.running)
         {
            cacheFlushTimer.reset();
            cacheFlushTimer.delay = cacheFlushInterval;
            cacheFlushTimer.start();
            cacheFlushTimer.addEventListener(TimerEvent.TIMER,function(event:TimerEvent):void
            {
               var card:VCard = null;
               for each(card in cache)
               {
                  pushRequest(connection,card);
               }
               clearCache();
            });
         }
         var cachedCard:VCard = cache[jid.bareJID] as VCard;
         if(cachedCard)
         {
            return cachedCard;
         }
         var vCard:VCard = new VCard();
         vCard.jid = jid;
         cache[jid.bareJID] = vCard;
         pushRequest(connection,vCard);
         return vCard;
      }
      
      public static function expireCache() : void
      {
         if(cacheFlushTimer.running)
         {
            cacheFlushTimer.stop();
         }
      }
      
      public static function clearCache() : void
      {
         cache = new Dictionary();
      }
      
      private static function pushRequest(connection:XMPPConnection, vCard:VCard) : void
      {
         if(!requestTimer)
         {
            requestTimer = new Timer(1,1);
            requestTimer.addEventListener(TimerEvent.TIMER_COMPLETE,sendRequest);
         }
         requestQueue.push({
            "connection":connection,
            "card":vCard
         });
         requestTimer.reset();
         requestTimer.start();
      }
      
      private static function sendRequest(event:TimerEvent) : void
      {
         if(requestQueue.length == 0)
         {
            return;
         }
         var req:Object = requestQueue.pop();
         var connection:XMPPConnection = req.connection;
         var vCard:VCard = req.card;
         var jid:UnescapedJID = vCard.jid;
         var recipient:EscapedJID = !!jid.equals(connection.jid,true)?null:jid.escaped;
         var iq:IQ = new IQ(recipient,IQ.TYPE_GET);
         iq.callback = vCard.handleVCard;
         iq.addExtension(new VCardExtension());
         connection.send(iq);
         requestTimer.reset();
         requestTimer.start();
      }
      
      public function handleVCard(iq:IQ) : void
      {
         var child:XML = null;
         var bday:String = null;
         var jabberid:String = null;
         var tz:String = null;
         var rev:String = null;
         var photoData:XML = null;
         var photoValue:String = null;
         var emailChild:XML = null;
         var logoData:XML = null;
         var logoValue:String = null;
         var node:XML = XML(iq.getNode());
         var vCardNode:XML = node.children()[0];
         if(!vCardNode)
         {
            return;
         }
         this.version = vCardNode.@version;
         var nodes:XMLList = vCardNode.children();
         for each(child in nodes)
         {
            switch(child.localName())
            {
               case "VERSION":
                  this.version = child.text();
                  continue;
               case "FN":
                  this.formattedName = child.text();
                  continue;
               case "N":
                  this.name = new VCardName(child.GIVEN,child.MIDDLE,child.FAMILY,child.PREFIX,child.SUFFIX);
                  continue;
               case "NICKNAME":
                  this.nickname = child.text();
                  continue;
               case "PHOTO":
                  this.photo = new VCardPhoto();
                  for each(photoData in child.children())
                  {
                     photoValue = photoData.text();
                     if(photoData.localName() == "TYPE" && photoValue.length > 0)
                     {
                        this.photo.type = photoValue;
                     }
                     else if(photoData.localName() == "BINVAL" && photoValue.length > 0)
                     {
                        this.photo.binaryValue = photoValue;
                     }
                     else if(photoData.localName() == "EXTVAL" && photoValue.length > 0)
                     {
                        this.photo.externalValue = photoValue;
                     }
                  }
                  continue;
               case "BDAY":
                  bday = child.children()[0];
                  if(bday != null && bday.length > 8)
                  {
                     this.birthday = DateTimeParser.string2date(bday);
                  }
                  continue;
               case "ADR":
                  if(child.WORK.length() == 1)
                  {
                     this.workAddress = new VCardAddress(child.STREET,child.LOCALITY,child.REGION,child.PCODE,child.CTRY,child.EXTADD,child.POBOX);
                  }
                  else if(child.HOME.length() == 1)
                  {
                     this.homeAddress = new VCardAddress(child.STREET,child.LOCALITY,child.REGION,child.PCODE,child.CTRY,child.EXTADD,child.POBOX);
                  }
                  continue;
               case "LABEL":
                  if(child.WORK.length() == 1)
                  {
                     this.workAddressLabel = child.LINE;
                  }
                  else if(child.HOME.length() == 1)
                  {
                     this.homeAddressLabel = child.LINE;
                  }
                  continue;
               case "TEL":
                  if(child.WORK.length() == 1)
                  {
                     this.workTelephone = new VCardTelephone();
                     if(child.VOICE.length() == 1)
                     {
                        this.workTelephone.voice = child.NUMBER;
                     }
                     else if(child.FAX.length() == 1)
                     {
                        this.workTelephone.fax = child.NUMBER;
                     }
                     else if(child.PAGER.length() == 1)
                     {
                        this.workTelephone.pager = child.NUMBER;
                     }
                     else if(child.MSG.length() == 1)
                     {
                        this.workTelephone.msg = child.NUMBER;
                     }
                     else if(child.CELL.length() == 1)
                     {
                        this.workTelephone.cell = child.NUMBER;
                     }
                     else if(child.VIDEO.length() == 1)
                     {
                        this.workTelephone.video = child.NUMBER;
                     }
                  }
                  else if(child.HOME.length() == 1)
                  {
                     this.homeTelephone = new VCardTelephone();
                     if(child.VOICE.length() == 1)
                     {
                        this.homeTelephone.voice = child.NUMBER;
                     }
                     else if(child.FAX.length() == 1)
                     {
                        this.homeTelephone.fax = child.NUMBER;
                     }
                     else if(child.PAGER.length() == 1)
                     {
                        this.homeTelephone.pager = child.NUMBER;
                     }
                     else if(child.MSG.length() == 1)
                     {
                        this.homeTelephone.msg = child.NUMBER;
                     }
                     else if(child.CELL.length() == 1)
                     {
                        this.homeTelephone.cell = child.NUMBER;
                     }
                     else if(child.VIDEO.length() == 1)
                     {
                        this.homeTelephone.video = child.NUMBER;
                     }
                  }
                  continue;
               case "EMAIL":
                  for each(emailChild in child.children())
                  {
                     if(emailChild.localName() == "USERID")
                     {
                        this.email = emailChild.children()[0];
                     }
                  }
                  continue;
               case "JABBERID":
                  jabberid = child.text();
                  if(jabberid != null && jabberid.length > 0)
                  {
                     this.jid = new UnescapedJID(jabberid);
                  }
                  continue;
               case "MAILER":
                  this.mailer = child.text();
                  continue;
               case "TZ":
                  tz = child.children()[0];
                  if(tz != null && tz.length > 8)
                  {
                     this.timezone = DateTimeParser.string2date(tz);
                  }
                  continue;
               case "GEO":
                  this.geographicalPosition = new VCardGeographicalPosition(child.LAT,child.LON);
                  continue;
               case "TITLE":
                  this.title = child.text();
                  continue;
               case "ROLE":
                  this.role = child.text();
                  continue;
               case "LOGO":
                  this.logo = new VCardPhoto();
                  for each(logoData in child.children())
                  {
                     logoValue = logoData.text();
                     if(logoData.localName() == "TYPE" && logoValue.length > 0)
                     {
                        this.logo.type = logoValue;
                     }
                     else if(logoData.localName() == "BINVAL" && logoValue.length > 0)
                     {
                        this.logo.binaryValue = logoValue;
                     }
                     else if(logoData.localName() == "EXTVAL" && logoValue.length > 0)
                     {
                        this.logo.externalValue = logoValue;
                     }
                  }
                  continue;
               case "AGENT":
                  continue;
               case "ORG":
                  this.organization = new VCardOrganization(child.ORGNAME,child.ORGUNIT);
                  continue;
               case "CATEGORIES":
                  continue;
               case "NOTE":
                  this.note = child.text();
                  continue;
               case "PRODID":
                  this.productID = child.text();
                  continue;
               case "REV":
                  rev = child.children()[0];
                  if(rev != null && rev.length > 8)
                  {
                     this.revision = DateTimeParser.string2date(rev);
                  }
                  continue;
               case "SORT-STRING":
                  this.sortString = child.text();
                  continue;
               case "SOUND":
                  this.sound = new VCardSound();
                  if(child.PHONETIC.length() == 1)
                  {
                     this.sound.phonetic = child.PHONETIC;
                  }
                  else if(child.BINVAL.length() == 1)
                  {
                     this.sound.binaryValue = child.BINVAL;
                  }
                  else if(child.EXTVAL.length() == 1)
                  {
                     this.sound.externalValue = child.EXTVAL;
                  }
                  continue;
               case "UID":
                  this.uid = child.text();
                  continue;
               case "URL":
                  this.url = child.text();
                  continue;
               case "CLASS":
                  if(child.PUBLIC.length() == 1)
                  {
                     this.privacyClass = "public";
                  }
                  else if(child.PRIVATE.length() == 1)
                  {
                     this.privacyClass = "private";
                  }
                  else if(child.CONFIDENTIAL.length() == 1)
                  {
                     this.privacyClass = "confidential";
                  }
                  continue;
               case "KEY":
                  continue;
               case "DESC":
                  this.description = child.text();
                  continue;
               default:
                  trace("handleVCard. Private extension: " + child.name());
                  this.extensionNames.push(child.localName());
                  this.extensions[child.localName()] = child.text().toString();
                  continue;
            }
         }
         this._loaded = true;
         dispatchEvent(new VCardEvent(VCardEvent.LOADED,this,true,false));
      }
      
      public function saveVCard(connection:XMPPConnection) : void
      {
         var nameNode:XML = null;
         var photoNode:XML = null;
         var photoTypeNode:XML = null;
         var photoBinaryNode:XML = null;
         var photoExtNode:XML = null;
         var workAddressNode:XML = null;
         var homeAddressNode:XML = null;
         var workAddressLabelNode:XML = null;
         var homeAddressLabelNode:XML = null;
         var workVoiceNode:XML = null;
         var workFaxNode:XML = null;
         var workPagerNode:XML = null;
         var workMsgNode:XML = null;
         var workCellNode:XML = null;
         var workVideoNode:XML = null;
         var homeVoiceNode:XML = null;
         var homeFaxNode:XML = null;
         var homePagerNode:XML = null;
         var homeMsgNode:XML = null;
         var homeCellNode:XML = null;
         var homeVideoNode:XML = null;
         var emailNode:XML = null;
         var geoNode:XML = null;
         var logoNode:XML = null;
         var logoTypeNode:XML = null;
         var logoBinaryNode:XML = null;
         var logoExtNode:XML = null;
         var organizationNode:XML = null;
         var sortStringNode:XML = null;
         var soundNode:XML = null;
         var phoneticNode:XML = null;
         var soundBinaryNode:XML = null;
         var soundExtNode:XML = null;
         var classNode:XML = null;
         var confidentialNode:XML = null;
         var publicNode:XML = null;
         var privateNode:XML = null;
         var xName:String = null;
         var id:String = XMPPStanza.generateID("save_vcard_");
         var iq:IQ = new IQ(null,IQ.TYPE_SET,id,this.saveVCard_result);
         var vcardExt:VCardExtension = new VCardExtension();
         var vcardExtNode:XML = new XML(vcardExt.getNode().toString());
         if(this.formattedName)
         {
            vcardExtNode.FN = this.formattedName;
         }
         if(this.name)
         {
            nameNode = <N/>;
            if(this.name.family)
            {
               nameNode.FAMILY = this.name.family;
            }
            if(this.name.given)
            {
               nameNode.GIVEN = this.name.given;
            }
            if(this.name.middle)
            {
               nameNode.MIDDLE = this.name.middle;
            }
            if(this.name.prefix)
            {
               nameNode.PREFIX = this.name.prefix;
            }
            if(this.name.suffix)
            {
               nameNode.SUFFIX = this.name.suffix;
            }
            vcardExtNode.appendChild(nameNode);
         }
         if(this.nickname)
         {
            vcardExtNode.NICKNAME = this.nickname;
         }
         if(this.photo && (this.photo.type && this.photo.binaryValue || this.photo.externalValue))
         {
            photoNode = <PHOTO/>;
            if(this.photo.binaryValue)
            {
               try
               {
                  photoBinaryNode = <BINVAL/>;
                  photoBinaryNode.appendChild(this.photo.binaryValue);
                  photoNode.appendChild(photoBinaryNode);
               }
               catch(error:Error)
               {
                  throw new Error("VCard:saveVCard Error converting bytes to string " + error.message);
               }
               photoTypeNode = <TYPE/>;
               photoTypeNode.appendChild(this.photo.type);
               photoNode.appendChild(photoTypeNode);
            }
            else
            {
               photoExtNode = <EXTVAL/>;
               photoExtNode.appendChild(this.photo.externalValue);
               photoNode.appendChild(photoExtNode);
            }
            vcardExtNode.appendChild(photoNode);
         }
         if(this.birthday)
         {
            vcardExtNode.BDAY = DateTimeParser.date2string(this.birthday);
         }
         if(this.workAddress)
         {
            workAddressNode = <ADR/>;
            workAddressNode.appendChild(<WORK/>);
            if(this.workAddress.poBox)
            {
               workAddressNode.POBOX = this.workAddress.poBox;
            }
            if(this.workAddress.extendedAddress)
            {
               workAddressNode.EXTADD = this.workAddress.extendedAddress;
            }
            if(this.workAddress.street)
            {
               workAddressNode.STREET = this.workAddress.street;
            }
            if(this.workAddress.locality)
            {
               workAddressNode.LOCALITY = this.workAddress.locality;
            }
            if(this.workAddress.region)
            {
               workAddressNode.REGION = this.workAddress.region;
            }
            if(this.workAddress.postalCode)
            {
               workAddressNode.PCODE = this.workAddress.postalCode;
            }
            if(this.workAddress.country)
            {
               workAddressNode.CTRY = this.workAddress.country;
            }
            vcardExtNode.appendChild(workAddressNode);
         }
         if(this.homeAddress)
         {
            homeAddressNode = <ADR/>;
            homeAddressNode.appendChild(<HOME/>);
            if(this.homeAddress.poBox)
            {
               homeAddressNode.POBOX = this.homeAddress.poBox;
            }
            if(this.homeAddress.extendedAddress)
            {
               homeAddressNode.EXTADD = this.homeAddress.extendedAddress;
            }
            if(this.homeAddress.street)
            {
               homeAddressNode.STREET = this.homeAddress.street;
            }
            if(this.homeAddress.locality)
            {
               homeAddressNode.LOCALITY = this.homeAddress.locality;
            }
            if(this.homeAddress.region)
            {
               homeAddressNode.REGION = this.homeAddress.region;
            }
            if(this.homeAddress.postalCode)
            {
               homeAddressNode.PCODE = this.homeAddress.postalCode;
            }
            if(this.homeAddress.country)
            {
               homeAddressNode.CTRY = this.homeAddress.country;
            }
            vcardExtNode.appendChild(homeAddressNode);
         }
         if(this.workAddressLabel)
         {
            workAddressLabelNode = <LABEL/>;
            workAddressLabelNode.appendChild(<WORK/>);
            workAddressLabelNode.LINE = this.workAddressLabel;
            vcardExtNode.appendChild(workAddressLabelNode);
         }
         if(this.homeAddressLabel)
         {
            homeAddressLabelNode = <LABEL/>;
            homeAddressLabelNode.appendChild(<HOME/>);
            homeAddressLabelNode.LINE = this.homeAddressLabel;
            vcardExtNode.appendChild(homeAddressLabelNode);
         }
         var phoneNode:XML = <TEL/>;
         if(this.workTelephone)
         {
            phoneNode.setChildren(<WORK/>);
            if(this.workTelephone.voice)
            {
               workVoiceNode = phoneNode.copy();
               workVoiceNode.appendChild(<VOICE/>);
               workVoiceNode.NUMBER = this.workTelephone.voice;
               vcardExtNode.appendChild(workVoiceNode);
            }
            if(this.workTelephone.fax)
            {
               workFaxNode = phoneNode.copy();
               workFaxNode.appendChild(<FAX/>);
               workFaxNode.NUMBER = this.workTelephone.fax;
               vcardExtNode.appendChild(workFaxNode);
            }
            if(this.workTelephone.pager)
            {
               workPagerNode = phoneNode.copy();
               workPagerNode.appendChild(<PAGER/>);
               workPagerNode.NUMBER = this.workTelephone.pager;
               vcardExtNode.appendChild(workPagerNode);
            }
            if(this.workTelephone.msg)
            {
               workMsgNode = phoneNode.copy();
               workMsgNode.appendChild(<MSG/>);
               workMsgNode.NUMBER = this.workTelephone.msg;
               vcardExtNode.appendChild(workMsgNode);
            }
            if(this.workTelephone.cell)
            {
               workCellNode = phoneNode.copy();
               workCellNode.appendChild(<CELL/>);
               workCellNode.NUMBER = this.workTelephone.cell;
               vcardExtNode.appendChild(workCellNode);
            }
            if(this.workTelephone.video)
            {
               workVideoNode = phoneNode.copy();
               workVideoNode.appendChild(<VIDEO/>);
               workVideoNode.NUMBER = this.workTelephone.video;
               vcardExtNode.appendChild(workVideoNode);
            }
         }
         if(this.homeTelephone)
         {
            phoneNode.setChildren(<HOME/>);
            if(this.homeTelephone.voice)
            {
               homeVoiceNode = phoneNode.copy();
               homeVoiceNode.appendChild(<VOICE/>);
               homeVoiceNode.NUMBER = this.homeTelephone.voice;
               vcardExtNode.appendChild(homeVoiceNode);
            }
            if(this.homeTelephone.fax)
            {
               homeFaxNode = phoneNode.copy();
               homeFaxNode.appendChild(<FAX/>);
               homeFaxNode.NUMBER = this.homeTelephone.fax;
               vcardExtNode.appendChild(homeFaxNode);
            }
            if(this.homeTelephone.pager)
            {
               homePagerNode = phoneNode.copy();
               homePagerNode.appendChild(<PAGER/>);
               homePagerNode.NUMBER = this.homeTelephone.pager;
               vcardExtNode.appendChild(homePagerNode);
            }
            if(this.homeTelephone.msg)
            {
               homeMsgNode = phoneNode.copy();
               homeMsgNode.appendChild(<MSG/>);
               homeMsgNode.NUMBER = this.homeTelephone.msg;
               vcardExtNode.appendChild(homeMsgNode);
            }
            if(this.homeTelephone.cell)
            {
               homeCellNode = phoneNode.copy();
               homeCellNode.appendChild(<CELL/>);
               homeCellNode.NUMBER = this.homeTelephone.cell;
               vcardExtNode.appendChild(homeCellNode);
            }
            if(this.homeTelephone.video)
            {
               homeVideoNode = phoneNode.copy();
               homeVideoNode.appendChild(<VIDEO/>);
               homeVideoNode.NUMBER = this.homeTelephone.video;
               vcardExtNode.appendChild(homeVideoNode);
            }
         }
         if(this.email)
         {
            emailNode = <EMAIL/>;
            emailNode.appendChild(<INTERNET/>);
            emailNode.appendChild(<PREF/>);
            emailNode.USERID = this.email;
            vcardExtNode.appendChild(emailNode);
         }
         if(this.jid)
         {
            vcardExtNode.JABBERID = this.jid.toString();
         }
         if(this.mailer)
         {
            vcardExtNode.MAILER = this.mailer;
         }
         if(this.timezone)
         {
            vcardExtNode.TZ = DateTimeParser.date2string(this.timezone);
         }
         if(this.geographicalPosition)
         {
            geoNode = <GEO/>;
            if(this.geographicalPosition.latitude)
            {
               geoNode.LAT = this.geographicalPosition.latitude;
            }
            if(this.geographicalPosition.longitude)
            {
               geoNode.LON = this.geographicalPosition.longitude;
            }
            vcardExtNode.appendChild(geoNode);
         }
         if(this.title)
         {
            vcardExtNode.TITLE = this.title;
         }
         if(this.role)
         {
            vcardExtNode.ROLE = this.role;
         }
         if(this.logo && (this.logo.type && this.logo.binaryValue || this.logo.externalValue))
         {
            logoNode = <LOGO/>;
            if(this.logo.binaryValue)
            {
               try
               {
                  logoBinaryNode = <BINVAL/>;
                  logoBinaryNode.appendChild(this.logo.binaryValue);
                  logoNode.appendChild(logoBinaryNode);
               }
               catch(error:Error)
               {
                  throw new Error("VCard:saveVCard Error converting bytes to string " + error.message);
               }
               logoTypeNode = <TYPE/>;
               logoTypeNode.appendChild(this.logo.type);
               logoNode.appendChild(logoTypeNode);
            }
            else
            {
               logoExtNode = <EXTVAL/>;
               logoExtNode.appendChild(this.logo.externalValue);
               logoNode.appendChild(logoExtNode);
            }
            vcardExtNode.appendChild(logoNode);
         }
         if(this.organization)
         {
            organizationNode = <ORG/>;
            if(this.organization.name)
            {
               organizationNode.ORGNAME = this.organization.name;
            }
            if(this.organization.unit)
            {
               organizationNode.ORGUNIT = this.organization.unit;
            }
            vcardExtNode.appendChild(organizationNode);
         }
         if(this.note)
         {
            vcardExtNode.NOTE = this.note;
         }
         if(this.productID)
         {
            vcardExtNode.PRODID = this.productID;
         }
         if(this.revision)
         {
            vcardExtNode.REV = DateTimeParser.date2string(this.revision);
         }
         if(this.sortString)
         {
            sortStringNode = <SORT-STRING/>;
            sortStringNode.appendChild(this.sortString);
            vcardExtNode.appendChild(sortStringNode);
         }
         if(this.sound && (this.sound.phonetic || this.sound.binaryValue || this.sound.externalValue))
         {
            soundNode = <SOUND/>;
            if(this.sound.phonetic)
            {
               phoneticNode = <PHONETIC/>;
               phoneticNode.appendChild(this.sound.phonetic);
               soundNode.appendChild(phoneticNode);
            }
            else if(this.sound.binaryValue)
            {
               try
               {
                  soundBinaryNode = <BINVAL/>;
                  soundBinaryNode.appendChild(this.sound.binaryValue);
                  soundNode.appendChild(soundBinaryNode);
               }
               catch(error:Error)
               {
                  throw new Error("VCard:saveVCard Error converting bytes to string " + error.message);
               }
            }
            else
            {
               soundExtNode = <EXTVAL/>;
               soundExtNode.appendChild(this.sound.externalValue);
               soundNode.appendChild(soundExtNode);
            }
            vcardExtNode.appendChild(soundNode);
         }
         if(this.uid)
         {
            vcardExtNode.UID = this.uid;
         }
         if(this.url)
         {
            vcardExtNode.URL = this.url;
         }
         if(this.privacyClass && (this.privacyClass == "public" || this.privacyClass == "private" || this.privacyClass == "confidential"))
         {
            classNode = <CLASS/>;
            if(this.privacyClass == "public")
            {
               publicNode = <PUBLIC/>;
               classNode.appendChild(publicNode);
            }
            else if(this.privacyClass == "private")
            {
               privateNode = <PRIVATE/>;
               classNode.appendChild(privateNode);
            }
            else
            {
               this.privacyClass == "confidential";
            }
            confidentialNode = <CONFIDENTIAL/>;
            classNode.appendChild(confidentialNode);
            vcardExtNode.appendChild(classNode);
         }
         if(this.description)
         {
            vcardExtNode.DESC = this.description;
         }
         if(this.extensionNames.length > 0)
         {
            for each(xName in this.extensionNames)
            {
               vcardExtNode[xName] = this._extensions[xName];
            }
         }
         var xmlDoc:XMLDocument = new XMLDocument(vcardExtNode.toString());
         vcardExt.setNode(xmlDoc.firstChild);
         iq.addExtension(vcardExt);
         connection.send(iq);
      }
      
      public function saveVCard_result(resultIQ:IQ) : void
      {
         var bareJID:String = resultIQ.to.unescaped.bareJID;
         if(resultIQ.type == IQ.TYPE_ERROR)
         {
            dispatchEvent(new VCardEvent(VCardEvent.SAVE_ERROR,cache[bareJID],true,true));
         }
         else
         {
            delete cache[bareJID];
            dispatchEvent(new VCardEvent(VCardEvent.SAVED,this,true,false));
         }
      }
      
      public function get loaded() : Boolean
      {
         return this._loaded;
      }
      
      public function get extensions() : Dictionary
      {
         return this._extensions;
      }
   }
}
