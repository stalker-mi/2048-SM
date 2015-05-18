package  {
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.TouchEvent;
	import flash.events.MouseEvent;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import flash.ui.Keyboard;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import flash.filesystem.*;
	import flash.desktop.NativeApplication;
	
	
	
	[SWF(width="400", height="500")]
	public class Main extends MovieClip {
		
		private var newFile:File;
		private var restangle:Array;
		private var store:TextField;
		private var max:TextField;
		private var ext:Sprite;
		private var int_store:int;
		private var max_int:int;
		private var stage_x:Number;
		private var stage_y:Number;
		private var i:int;
		private var j:int;
			
		public function Main() {
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			init_var();
			init_store();
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			stage.addEventListener(KeyboardEvent.KEY_DOWN, key_down);
			stage.addEventListener(TouchEvent.TOUCH_BEGIN, touch_begin);
			stage.addEventListener(TouchEvent.TOUCH_END, touch_end);
			stage.addEventListener(KeyboardEvent.KEY_UP, fl_OptionsMenuHandler);
		}
		
		private function init_var():void 
		{
			int_store=0;
			
			store=new TextField();
			var format:TextFormat=new TextFormat("Comic Sans MS",23,0x999999);
			store.defaultTextFormat=format;
			store.x=10;
			store.y=450;
			store.width=175;
			store.text="STORE:100500";
			addChild(store);
			
			max=new TextField();
			max.defaultTextFormat=format;
			max.x=230;
			max.y=450;
			max.width=175;
			max.text="MAX:100500";
			addChild(max);
			
			restangle=new Array();
			for(i=0;i<4;i++)
			restangle[i]=new Array();
			
			var xx:int=0;
			var yy:int=0;
			for(i=0;i<4;i++){
			for(j=0;j<4;j++){
			restangle[i][j]=new qw1();
			out(restangle[i][j],0);
			restangle[i][j].x=xx;
			restangle[i][j].y=yy;
			xx+=100;
			addChild(restangle[i][j]);
			}
			xx=0;
			yy+=100;
			}
			
			var rand:int=Math.round(Math.random()*15);
			var k:int=0;
			for(i=0;i<4;i++)
			{
				for(j=0;j<4;j++)
				{
					if(k==rand) 
					{
						out(restangle[i][j],2);
					}
					k++;
				}
			}
			
			stage_x=0;
			stage_y=0;
			
			ext=new Sprite();
			ext.graphics.beginFill(0x9999ff,0.2);
			ext.graphics.drawRect(0,0,stage.width,stage.height);
			ext.graphics.endFill();
			ext.addEventListener(MouseEvent.MOUSE_DOWN, ext_down);
		}
		
		private function init_store():void 
		{
			newFile= File.applicationStorageDirectory;
  			newFile = newFile.resolvePath("store.txt");
			var stream:FileStream;
			if(!newFile.exists) {
				var outputString:String = "0"
				stream = new FileStream();
       			stream.open(newFile, FileMode.WRITE);
      	    	stream.writeUTFBytes(outputString);
				stream.close();
			}
			stream = new FileStream();
       		stream.open(newFile, FileMode.READ);
			max_int=new int(stream.readUTFBytes(stream.bytesAvailable));
			max.text="MAX:" + max_int.toString();
			stream.close();
		}
		
		
		private function key_down(e:KeyboardEvent):void
		{
			if(e.charCode==100) right();
			if(e.charCode==97) left();
			if(e.charCode==119) top();
			if(e.charCode==115) down();
		}
		
		private function touch_begin(e:TouchEvent):void
		{
			stage_x=e.stageX;
			stage_y=e.stageY;
		}
		
		private function touch_end(e:TouchEvent):void
		{
			if(Math.abs(e.stageX-stage_x)>Math.abs(e.stageY-stage_y))
			if(stage_x<e.stageX) right(); else left();
			else if(stage_y<e.stageY) down(); else top();
		}
		
		private function right():void
		{
			for(i=0;i<4;i++)
			{
				sdvig(restangle[i],false);
				for(j=3;j>0;j--)
				{		
					if(restangle[i][j].txt.text!=0)
					{
						if(restangle[i][j].txt.text==restangle[i][j-1].txt.text) 
						{
							out(restangle[i][j],int(restangle[i][j].txt.text)+int(restangle[i][j-1].txt.text),int(restangle[i][j].txt.text)+int(restangle[i][j-1].txt.text));
							out(restangle[i][j-1],0);
							sdvig(restangle[i],false);
							break;
						}
					}
				}
			}
			generate();
		}
		
		private function left():void
		{
			for(i=0;i<4;i++)
			{
				sdvig(restangle[i],true);
				for(j=0;j<3;j++)
				{
					if(restangle[i][j].txt.text!=0)
					{
						if(restangle[i][j].txt.text==restangle[i][j+1].txt.text) 
						{
							out(restangle[i][j],int(restangle[i][j].txt.text)+int(restangle[i][j+1].txt.text),int(restangle[i][j].txt.text)+int(restangle[i][j+1].txt.text));
							out(restangle[i][j+1],0);
							sdvig(restangle[i],true);
							break;
						}
					}
				}
			}
			generate();
		}
		
		private function top():void
		{
			sdvig_top(restangle,true);
			for(j=0;j<4;j++)
			{
				for(i=0;i<3;i++)
				{
					if(restangle[i][j].txt.text!=0)
					{
						if(restangle[i][j].txt.text==restangle[i+1][j].txt.text) 
						{
							out(restangle[i][j],int(restangle[i][j].txt.text)+int(restangle[i+1][j].txt.text),int(restangle[i][j].txt.text)+int(restangle[i+1][j].txt.text));
							out(restangle[i+1][j],0);
							break;
						}
					}
				}
			}
			sdvig_top(restangle,true);
			generate();
		}
		
		private function down():void
		{
			sdvig_top(restangle,false);
			for(j=0;j<4;j++)
			{
				for(i=3;i>0;i--)
				{
					if(restangle[i][j].txt.text!=0)
					{
						if(restangle[i][j].txt.text==restangle[i-1][j].txt.text) {
							out(restangle[i][j],int(restangle[i][j].txt.text)+int(restangle[i-1][j].txt.text),int(restangle[i][j].txt.text)+int(restangle[i-1][j].txt.text));
							out(restangle[i-1][j],0);
							break;
						}
					}
				}
			}
			sdvig_top(restangle,false);
			generate();
		}
		
		private function sdvig(res:Array,vlevo:Boolean):void
		{
			if(vlevo==false)
			{
				if(res[3].txt.text==0) {out(res[3],res[2].txt.text); out(res[2],0);}
				if(res[2].txt.text==0) {out(res[2],res[1].txt.text); out(res[1],0);}
				if(res[1].txt.text==0) {out(res[1],res[0].txt.text); out(res[0],0);}
				if(res[3].txt.text==0) {out(res[3],res[2].txt.text); out(res[2],0);}
				if(res[2].txt.text==0) {out(res[2],res[1].txt.text); out(res[1],0);}
				if(res[3].txt.text==0) {out(res[3],res[2].txt.text); out(res[2],0);}
			}
			else
			{
				if(res[0].txt.text==0) {out(res[0],res[1].txt.text); out(res[1],0);}
				if(res[1].txt.text==0) {out(res[1],res[2].txt.text); out(res[2],0);}
				if(res[2].txt.text==0) {out(res[2],res[3].txt.text); out(res[3],0);}
				if(res[0].txt.text==0) {out(res[0],res[1].txt.text); out(res[1],0);}
				if(res[1].txt.text==0) {out(res[1],res[2].txt.text); out(res[2],0);}
				if(res[0].txt.text==0) {out(res[0],res[1].txt.text); out(res[1],0);}
			}
		}
		
		private function sdvig_top(res:Array,vlevo:Boolean):void
		{
			for(j=0;j<4;j++)
			{
				if(vlevo==false)
				{
					if(res[3][j].txt.text==0) {out(res[3][j],res[2][j].txt.text); out(res[2][j],0);}
					if(res[2][j].txt.text==0) {out(res[2][j],res[1][j].txt.text); out(res[1][j],0);}
					if(res[1][j].txt.text==0) {out(res[1][j],res[0][j].txt.text); out(res[0][j],0);}
					if(res[3][j].txt.text==0) {out(res[3][j],res[2][j].txt.text); out(res[2][j],0);}
					if(res[2][j].txt.text==0) {out(res[2][j],res[1][j].txt.text); out(res[1][j],0);}
					if(res[3][j].txt.text==0) {out(res[3][j],res[2][j].txt.text); out(res[2][j],0);}
				}
				else
				{
					if(res[0][j].txt.text==0) {out(res[0][j],res[1][j].txt.text); out(res[1][j],0);}
					if(res[1][j].txt.text==0) {out(res[1][j],res[2][j].txt.text); out(res[2][j],0);}
					if(res[2][j].txt.text==0) {out(res[2][j],res[3][j].txt.text); out(res[3][j],0);}
					if(res[0][j].txt.text==0) {out(res[0][j],res[1][j].txt.text); out(res[1][j],0);}
					if(res[1][j].txt.text==0) {out(res[1][j],res[2][j].txt.text); out(res[2][j],0);}
					if(res[0][j].txt.text==0) {out(res[0][j],res[1][j].txt.text); out(res[1][j],0);}
				}
			}
			
		}
		
		private function out(restangle:MovieClip, txt1:Number, txt2:Number=0):void
		{
			var ew:Sprite;
			restangle.txt.text=txt1;
			restangle.txt.visible=true;
			restangle.re.removeChild(restangle.re.getChildAt(1));
			var format:TextFormat=new TextFormat();
			int_store+=txt2;
			store.text="STORE:"+int_store;
			if(txt1==0) {
				restangle.txt.visible=false;
				ew=new Sprite();
				ew.graphics.beginFill(0xcccccc,1);
				ew.graphics.drawRect(5,5,90,90);
				ew.graphics.endFill();
				restangle.re.addChild(ew);
			}
			if(txt1==2) 
			{
				format.size=46;
				restangle.txt.setTextFormat(format);
				restangle.txt.y=16.05;
				ew=new Sprite();
				ew.graphics.beginFill(0xffffff,1);
				ew.graphics.drawRect(5,5,90,90);
				ew.graphics.endFill();
				restangle.re.addChild(ew);
			}
			if(txt1==4) 
			{
				format.size=46;
				restangle.txt.setTextFormat(format);
				restangle.txt.y=16.05;
				ew=new Sprite();
				ew.graphics.beginFill(0xffffcc,1);
				ew.graphics.drawRect(5,5,90,90);
				ew.graphics.endFill();
				restangle.re.addChild(ew);
			}
			if(txt1==8) 
			{
				format.size=46;
				restangle.txt.setTextFormat(format);
				restangle.txt.y=16.05;
				ew=new Sprite();
				ew.graphics.beginFill(0xffff66,1);
				ew.graphics.drawRect(5,5,90,90);
				ew.graphics.endFill();
				restangle.re.addChild(ew);
			}
			if(txt1==16) 
			{
				format.size=46;
				restangle.txt.setTextFormat(format);
				restangle.txt.y=16.05;
				ew=new Sprite();
				ew.graphics.beginFill(0xffcc00,1);
				ew.graphics.drawRect(5,5,90,90);
				ew.graphics.endFill();
				restangle.re.addChild(ew);
			}
			if(txt1==32) 
			{
				format.size=46;
				restangle.txt.setTextFormat(format);
				restangle.txt.y=16.05;
				ew=new Sprite();
				ew.graphics.beginFill(0xff6666,1);
				ew.graphics.drawRect(5,5,90,90);
				ew.graphics.endFill();
				restangle.re.addChild(ew);
			}
			if(txt1==64) 
			{
				format.size=46;
				restangle.txt.setTextFormat(format);
				restangle.txt.y=16.05;
				ew=new Sprite();
				ew.graphics.beginFill(0xff3300,1);
				ew.graphics.drawRect(5,5,90,90);
				ew.graphics.endFill();
				restangle.re.addChild(ew);
			}
			if(txt1==128) 
			{
				format.size=32;
				restangle.txt.setTextFormat(format);
				restangle.txt.y=27;
				ew=new Sprite();
				ew.graphics.beginFill(0x99ff00,1);
				ew.graphics.drawRect(5,5,90,90);
				ew.graphics.endFill();
				restangle.re.addChild(ew);
			}
			if(txt1==256) 
			{
				format.size=30;
				restangle.txt.setTextFormat(format);
				restangle.txt.y=27;
				ew=new Sprite();
				ew.graphics.beginFill(0x99ff66,1);
				ew.graphics.drawRect(5,5,90,90);
				ew.graphics.endFill();
				restangle.re.addChild(ew);
			}
			if(txt1==512) 
			{
				format.size=30;
				restangle.txt.setTextFormat(format);
				restangle.txt.y=27;
				ew=new Sprite();
				ew.graphics.beginFill(0x00ff66,1);
				ew.graphics.drawRect(5,5,90,90);
				ew.graphics.endFill();
				restangle.re.addChild(ew);
			}
			if(txt1==1024) 
			{
				format.size=25;
				restangle.txt.setTextFormat(format);
				restangle.txt.y=33;
				ew=new Sprite();
				ew.graphics.beginFill(0x00ccff,1);
				ew.graphics.drawRect(5,5,90,90);
				ew.graphics.endFill();
				restangle.re.addChild(ew);
			}
			if(txt1==2048) 
			{
				format.size=23;
				restangle.txt.setTextFormat(format);
				restangle.txt.y=36;
				ew=new Sprite();
				ew.graphics.beginFill(0x0000ff,1);
				ew.graphics.drawRect(5,5,90,90);
				ew.graphics.endFill();
				restangle.re.addChild(ew);
			}
			if(txt1==4096) 
			{
				format.size=23;
				restangle.txt.setTextFormat(format);
				restangle.txt.y=36;
				ew=new Sprite();
				ew.graphics.beginFill(0xff00ff,1);
				ew.graphics.drawRect(5,5,90,90);
				ew.graphics.endFill();
				restangle.re.addChild(ew);
			}
			if(txt1==8096) 
			{
				format.size=23;
				restangle.txt.setTextFormat(format);
				restangle.txt.y=36;
				ew=new Sprite();
				ew.graphics.beginFill(0x9900cc,1);
				ew.graphics.drawRect(5,5,90,90);
				ew.graphics.endFill();
				restangle.re.addChild(ew);
			}
	}
		
		private function generate():int
		{
			var k:int=0;
			for(i=0;i<4;i++){
					for(j=0;j<4;j++){
						if(restangle[i][j].txt.text==0) k++;
					}
			}
			
			if(k>0) 
			{
				while(1){
					var rand:int=Math.round(Math.random()*15);
					k=0;
					for(i=0;i<4;i++){
						for(j=0;j<4;j++){
							if(k==rand && restangle[i][j].txt.text==0) 
							{
								out(restangle[i][j],2);
								return 0;
							}
							k++;
						}
					}
				}
			}
			else exit();
			return 0;
		}
		
		
		private function exit():void
		{
			trace("Вы проиграли");
			stage.addChild(ext);
			var txt_field:TextField=new TextField();
			txt_field.text="Вы проиграли. \n Возможно...";
			var format:TextFormat=new TextFormat();
			format.size=46;
			txt_field.setTextFormat(format);
			txt_field.y=stage.height/2;
			txt_field.x=75;
			txt_field.autoSize=TextFieldAutoSize.LEFT;
			ext.addChild(txt_field);
			if(int_store>max_int)
			{
				max.text="MAX:" + int_store.toString();
				var outputString:String = int_store.toString();
				var stream:FileStream = new FileStream();
				stream.open(newFile, FileMode.WRITE);
				stream.writeUTFBytes(outputString);
				stream.close();
			}
		}
		
		private function ext_down(e:MouseEvent):void
		{
			stage.removeChild(ext);
		}

		private function fl_OptionsMenuHandler(event:KeyboardEvent):void
		{
			if(event.keyCode == Keyboard.BACK) NativeApplication.nativeApplication.exit(0);
		}
	
	
	}
	
}
