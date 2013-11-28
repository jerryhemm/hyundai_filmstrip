//************************************************************************************** 
// This ActionScript code is part of the Filmstrip block 
// ALL RIGHTS RESERVED TO MediaMind. INC. (C) 
//**************************************************************************************
package  com.mediamind.filmstrip
{
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.SharedObject;
	import flash.net.URLRequest;
	import flash.utils.getDefinitionByName;
	import flash.media.SoundMixer;
	
	import com.greensock.TweenNano;
	import com.greensock.easing.EaseLookup;
	
	import com.mediamind.filmstrip.Config;
	import eyeblaster.data.SmartVersioning;
	import eyeblaster.events.EBSmartVersioningEvent;
	

	public class MMBlock_Filmstrip_AS3_DocumentClass extends MovieClip{
		private var direction:String;
		private var stateNumber:int = getSharedObject();
		private var contentArray:Array = new Array();
		private var mySharedObject:SharedObject;
		private var scrollUpFlag:Boolean = false;
		private var scrollDownFlag:Boolean = false;
		
		public function MMBlock_Filmstrip_AS3_DocumentClass(){
			// leave cunstructor empty
		};
		
		
		public function init():void {
			trace("MediaMind Block | Filmstrip AS3 - V1 - 172");
			stage.addEventListener(MouseEvent.MOUSE_WHEEL, userScrolled);
			addNavigationButtonsListener();
			setupContainer();
			setupSmartV();
		};
		
		private function userScrolled(e:MouseEvent):void 
		{
			switch(e.delta) {
				case -3:
					trace("down");
					if(scrollDownFlag){
						scrollDown(e);
					}
				break;
				case 3:
					trace("up");
					if(scrollUpFlag){
						scrollUp(e);
					}
				break
				
			}
		}
		
		
		private function getSharedObject():int{
			mySharedObject = SharedObject.getLocal("thisAdId" , "/");
			mySharedObject.flush();
			stateNumber = (!mySharedObject.data.stateNumber)?0:mySharedObject.data.stateNumber;
			setSharedObject(stateNumber);
			return Number(stateNumber);
		};
		
		
		private function setSharedObject(stateNumber:int):void{
			mySharedObject.data.stateNumber = stateNumber;
			mySharedObject.flush();
		};
		
		
		private function setupSmartV():void{
			SVComp.addEventListener(EBSmartVersioningEvent.XML_LOADED,populateFirstTime);
		};


		public function createFilmstipArray():void{
			for (var h:int = 1; h <= 5; h++) {
				var curentItem:String = h.toString();
				if (SVComp.getValue("filmstrip_label" + curentItem) != null && SVComp.getValue("filmstrip_asset" + curentItem) != null) {
					var additionalAssetID=SVComp.getValue("filmstrip_asset" + curentItem);
					var additionalAssetURL=SVComp.getAssetURL(additionalAssetID);
					contentArray[h] = [SVComp.getValue("filmstrip_label"+curentItem), additionalAssetURL];
				}else {
					return;
				}
			}
		}
		
		private function populateFirstTime(e:EBSmartVersioningEvent):void {
			createFilmstipArray();
			var myLoader:Loader	= new Loader();
			myLoader.name = "additionalAssetLoader";
			(getChildByName("main") as MovieClip).addChild(myLoader);
			if ((Number(stateNumber) < Number(contentArray.length - 1))) {
				setSharedObject(Number(stateNumber + 1));
				stateNumber ++;
			}
			myLoader.load(new URLRequest(contentArray[(stateNumber)][1]));
			populateFilmstrip();
		};
		
		
		private function populateFilmstrip():void {
			var prviousMC:Number	= (stateNumber >= 2)?(stateNumber - 1): -1;
			var currentMC:Number	= stateNumber;
			var nextMC:Number		= (stateNumber < (contentArray.length - 1))?(stateNumber + 1): -1;
			
			(button_up as MovieClip).visible = (prviousMC != -1);
			
			
			(button_down as MovieClip).visible = (nextMC != -1);
			scrollUpFlag	= (prviousMC != -1);
			scrollDownFlag	= (nextMC != -1);
			trace("scrollUpFlag = " + scrollUpFlag);
			trace("scrollDownFlag = " + scrollDownFlag);
			
			if (prviousMC != -1) {
				(button_up as MovieClip).label_txt.text =  contentArray[stateNumber - 1][0];
			}
			
			if (nextMC != -1) {
				(button_down as MovieClip).label_txt.text =  contentArray[stateNumber + 1][0];
			}
			
		};
		
		
		private function addNavigationButtonsListener():void {
			stage.addEventListener(MouseEvent.MOUSE_WHEEL, userScrolled);
			(button_up as MovieClip).addEventListener(MouseEvent.CLICK, scrollUp);
			(button_up as MovieClip).mouseChildren = false;
			(button_up as MovieClip).buttonMode = true;
			(button_up as MovieClip).useHandCursor = true;
			
			(button_down as MovieClip).addEventListener(MouseEvent.CLICK, scrollDown);
			(button_down as MovieClip).mouseChildren = false;
			(button_down as MovieClip).buttonMode = true;
			(button_down as MovieClip).useHandCursor = true;
		};
		
		
		private function removeNavigationButtonsListener():void {
			(button_up as MovieClip).label_txt.text = "";
			(button_down as MovieClip).label_txt.text = "";
			button_down.removeEventListener(MouseEvent.CLICK, scrollDown)
			button_up.removeEventListener(MouseEvent.CLICK, scrollUp);
			stage.removeEventListener(MouseEvent.MOUSE_WHEEL, userScrolled);
		};
		
		
		private function setupContainer(containerName:String = "main"):void {
			
			var mc_x = 0;
			var mc_y = 0;
			
			switch (containerName) 
			{
				case "down":
					mc_x = 0;
					mc_y = 600;
					
				break;
				case "main":
					mc_x = 0;
					mc_y = 0;
				break;
				case "up":
					mc_x = 0;
					mc_y = -600;
				break;
			}
			
			var myCurrentContainer:container_mc = new container_mc();
			myCurrentContainer.x = mc_x;
			myCurrentContainer.y = mc_y;
			myCurrentContainer.name = containerName;
			addChildAt(myCurrentContainer, 0);	
			var myLoader:Loader	= new Loader();
			myLoader.name = "additionalAssetLoader";
			if(containerName == "up"){
					(getChildByName(containerName) as MovieClip).addChild(myLoader);
					myLoader.load(new URLRequest(contentArray[stateNumber-1][1]));
			}
			if(containerName == "down"){
					(getChildByName(containerName) as MovieClip).addChild(myLoader);
					myLoader.load(new URLRequest(contentArray[stateNumber+1][1]));
			}
		};
		
		
		private function removeContainer(containerName:String):void {
			removeChild(getChildByName(containerName));
		};
		
		
		private function scrollUp(e:MouseEvent):void {
			SoundMixer.stopAll();
			reportCIbyLabel(button_up.label_txt.text);
			removeNavigationButtonsListener();
			direction = "up";
			setupContainer(direction);
			doScroll(1, 600);
			
		};
		
		private function reportCIbyLabel(label:String):void 
		{
			Config.reportCustomInteractionByLabel(label);
		}
		
		private function scrollDown(e:MouseEvent):void {
			SoundMixer.stopAll();
			reportCIbyLabel(button_down.label_txt.text);
			removeNavigationButtonsListener();
			direction = "down";
			setupContainer(direction);
			doScroll(1, -600);
		};
		
		private function doScroll(dur:Number, yPos:Number ):void {
			if(getChildByName("up")){
				TweenNano.to(getChildByName("up"), dur, { y:(yPos - 600), ease:EaseLookup} );
			}
			
			if(getChildByName("down")){
				TweenNano.to(getChildByName("down"), dur, { y:(yPos + 600), ease:EaseLookup} );
			}
			TweenNano.to(getChildByName("main"), dur, { y:yPos, ease:EaseLookup, onComplete:onFinishScroll} );
		};
		
		private function onFinishScroll():void{
			removeContainer("main");
			switch (direction) 
			{
				case "up":
					(getChildByName("up") as MovieClip).name = "main";
					if (stateNumber >= 1) {
						stateNumber --;
					}
				break;
				case "down":
					(getChildByName("down") as MovieClip).name = "main";
					if (stateNumber <= contentArray.length - 1) {
						stateNumber ++;
					}
				break;
			}
			setSharedObject(stateNumber);
			populateFilmstrip();
			addNavigationButtonsListener();
		};
		
		private function reg():void {
			// Do not delete the following line. The ad might malfunction if you do.
			import eyeblaster.*;
			Blocks.initBlock(173, 2, 'Filmstrip AS3');
		};
	}
}
