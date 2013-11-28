
import eyeblaster.videoPlayer.*;
import flash.display.*;
import flash.net.*;
import flash.events.*;
import flash.geom.*;
import com.greensock.TweenLite;
import eyeblaster.events.EBVideoEvent;

var debug:Boolean = false;

var video_playing = true;
var xml_loader:URLLoader = new URLLoader();
var xml_path:String = "files/video_gallery.xml";
var xml:XML;
var more_pages:Boolean = false;

EB.Init(this);


var path:String = "http://112.124.45.116/jerry/vpaidtest/files/mm.flv";
var video_screen:VideoScreen = new VideoScreen();

video_screen.onClickArr = [0,0,1];
video_screen.onRolloverArr = [0,0,1];
video_screen.name = "_videoScreenInst";
video_screen.visible = false;

video_screen.addEventListener(EBVideoEvent.MOVIE_END, movieEnd);
video_screen.addEventListener(EBVideoEvent.MOVIE_START, movieStart);

video_screen_mc.addChild(video_screen);
video_screen.width = video_screen_mc.width - 2;
video_screen.height = video_screen_mc.height - 3;
video_screen.x = 0;
video_screen.y = 0;
//video_screen.loadAndPlayExt(path);

play_btn.addEventListener(MouseEvent.CLICK, screenClicked);
play_btn.addEventListener(MouseEvent.MOUSE_OVER, screenMouseOver);
play_btn.addEventListener(MouseEvent.MOUSE_OUT, screenMouseOut);

/*xml_loader.load(new URLRequest(xml_path));
xml_loader.addEventListener(Event.COMPLETE, xmlLoaded);*/


//set volumn

var volumn_on = false;
volumn_button.is_off.visible = true;
volumn_button.is_on.visible = false;
volumn_button.addEventListener(MouseEvent.CLICK, volumnClicked);



var videos:Array = new Array();
var total_videos:int = 4;
var thumbs:Array = new Array();
var loaders:Array = new Array();
var thumb_width:Number = 64;
var thumb_height:Number = 40;
var current_index = 0;
var current_path;
var current_title;
var current_loader;
var thumbs_total_length:Number;


var thumbs_mc:MovieClip = new MovieClip();
thumbs_holder.addChild(thumbs_mc);


video_btn_mc.visible = false;
video_btn_mc.btn.over.visible = false;
video_btn_mc.mouseEnabled = false;
video_btn_mc.btn.mouseEnabled = false;
video_btn_mc.btn.out.mouseEnabled = false;
video_btn_mc.btn.over.mouseEnabled = false;

var thumbs_mask:Shape = new Shape();
thumbs_mask.graphics.beginFill(0x000);
thumbs_mask.graphics.drawRect(0, 0, 271, 43);
thumbs_mask.graphics.endFill();
thumbs_holder.addChild(thumbs_mask);
thumbs_mc.mask = thumbs_mask;

//loadBg();
createXML();

function loadBg():void{
	
	var path:String = "files/images/bg.png";
	var loader:Loader = new Loader();
	loader.load(new URLRequest(path));
	bg.addChild(loader);
	
	}




function xmlLoaded(e:Event):void{
	
	xml = new XML(e.target.data);
	
	processXML();
	
	}
	
	
	
function createXML():void{
	
	xml = <video_gallery>

	<video>
		<thumb>10</thumb>
		<extthumb>files/images/video1.png</extthumb>
		<title>Test 1</title>
		<path>9</path>
		<extpath>http://test.jerry.com/hyundai/files/video/hyundai.flv</extpath>
	</video>

	<video>
		<thumb>10</thumb>
		<extthumb>files/images/video2.png</extthumb>
		<title>Test 2</title>
		<path>9</path>
		<extpath>http://test.jerry.com/hyundai/files/video/hyundai.flv</extpath>
	</video>

	<video>
		<thumb>10</thumb>
		<extthumb>files/images/video3.png</extthumb>
		<title>Test 3</title>
		<path>9</path>
		<extpath>http://112.124.45.116/jerry/vpaidtest/files/mm.flv</extpath>
	</video>

	<video>
		<thumb>10</thumb>
		<extthumb>files/images/video4.png</extthumb>
		<title>Test 4</title>
		<path>9</path>
		<extpath>http://112.124.45.116/jerry/vpaidtest/files/mm.flv</extpath>
	</video>



</video_gallery>

	processXML();
	
	}
	
	
function processXML():void{
	
	total_videos = xml.video.length();
	
	if(total_videos > 4){
		more_pages = true;
		}
	
	for(var i = 0; i < total_videos; i++){
		
		videos[i] = new Object();
		videos[i]._index = i; 
		
		videos[i]._title = xml.video[i].title;
		
		
		if(debug){
			videos[i]._thumb = xml.video[i].extthumb;
			videos[i]._path = xml.video[i].extpath;
			}
		else{
			
			videos[i]._thumb = EB.GetAdditionalAsset(xml.video[i].thumb);
			videos[i]._path = xml.video[i].path;
			
			}
		
		loaders[i] = new Loader();
		loaders[i].load(new URLRequest(videos[i]._thumb));
		loaders[i].contentLoaderInfo.addEventListener(Event.COMPLETE, thumbImageLoaded);
		
		thumbs[i] = new Thumb();
		thumbs_mc.addChild(thumbs[i]);
		thumbs[i].x = 3 + i * (thumbs[i].width + 3);
		thumbs[i]._index = i;
		
		thumbs[i].image.addChild(loaders[i]);
		
		thumbs[i]._child = loaders[i];
		thumbs[i]._title = videos[i]._title;
		thumbs[i]._path = videos[i]._path;
		
		//thumbs[j].title.text = videos[j]._title;
		thumbs[i].buttonMode = true;
		
		thumbs[i].image._index = i;
		thumbs[i].addEventListener(MouseEvent.CLICK, thumbClicked);
		
		}
		
	
		
		
	thumbs_total_length = 3 + total_videos * 67;
		
	current_path = videos[0]._path;
	current_title = videos[0]._title;
	current_loader = loaders[0];
	current_index = 0;
	
	//video_btn_mc.visible = true;
	
	video_screen.visible = false;
		
	if(debug){
		video_screen.loadAndPlayExt(current_path);
		}
	else{
		video_screen.loadAndPlay(current_path);
		}
	
	enableRightLeftClick();
	
	}
	
	
function thumbImageLoaded(e:Event):void{
	
	
	var w:Number = e.target.width;
	var h:Number = e.target.height;
	var pos_x:Number;
	var pos_y:Number;
	
	var prop:Number = w / h;
	
	if(w > h){
		w = thumb_width;
		h = w * (1 / prop);
		pos_x = 0;
		pos_y = (thumb_height - h) / 2;
		}
	else{
		h = thumb_height;
		w = h * prop;
		pos_y = 0;
		pos_x = (thumb_width - w) / 2;
		}
		
	e.target.content.width = w;
	e.target.content.height = h;
	e.target.content.x = pos_x;
	e.target.content.y = pos_y;
	
	
	}
	
	
function thumbClicked(e:MouseEvent):void{
	
	video_btn_mc.visible = false;
	
	var index:int = e.currentTarget._index;
	
	if(index !== current_index){
		
		if(debug){
			video_screen.loadAndPlayExt(thumbs[index]._path);
			}
		else{
		
			if(thumbs[index]._path == current_path){
				video_screen.replay();
				} 
			else{
				video_screen.stopAndClear();
				video_screen.loadAndPlay(thumbs[index]._path);
				}
			
			/*video_screen.stopAndClear();
			video_screen.loadAndPlay(thumbs[index]._path);*/
		
			}
		
		}
	
	if(volumn_on){
		video_screen.unmute();
		}
	else{
		video_screen.mute();
		}
	
	current_path = thumbs[index]._path;
	current_index = index;
	
	}
	

thumbs_holder.btn_left.buttonMode = true;
thumbs_holder.btn_right.buttonMode = true;
	
thumbs_holder.btn_left.over.visible = false;
thumbs_holder.btn_right.over.visible = false;



function leftOver(e:MouseEvent):void{
	
	thumbs_holder.btn_left.over.visible = true;
	thumbs_holder.btn_left.out.visible = false;
	
	}
	
function leftOut(e:MouseEvent):void{
	
	thumbs_holder.btn_left.over.visible = false;
	thumbs_holder.btn_left.out.visible = true;
	
	}
	


function rightOver(e:MouseEvent):void{
	
	thumbs_holder.btn_right.over.visible = true;
	thumbs_holder.btn_right.out.visible = false;
	
	}
	
function rightOut(e:MouseEvent):void{
	
	thumbs_holder.btn_right.over.visible = false;
	thumbs_holder.btn_right.out.visible = true;
	
	}
	

var left_edge:Number;
var right_edge:Number;
	
	
function enableRightLeftClick():void{
	
	left_edge = 271 - thumbs_total_length;
	right_edge = 0;
	
	if(more_pages){
		
		thumbs_holder.btn_left.addEventListener(MouseEvent.MOUSE_OVER, leftOver);
		thumbs_holder.btn_left.addEventListener(MouseEvent.MOUSE_OUT, leftOut);
	
		thumbs_holder.btn_right.addEventListener(MouseEvent.MOUSE_OVER, rightOver);
		thumbs_holder.btn_right.addEventListener(MouseEvent.MOUSE_OUT, rightOut);
		
		thumbs_holder.btn_left.addEventListener(MouseEvent.CLICK, leftClicked);
		thumbs_holder.btn_right.addEventListener(MouseEvent.CLICK, rightClicked);
		
		}
	else{
		
		thumbs_holder.btn_left.alpha = 0.3;
		thumbs_holder.btn_right.alpha = 0.3;
		
		}
	
	}
	

function leftClicked(e:MouseEvent):void{
	
	var pos_x:Number = thumbs_mc.x - 67;
	
	if(pos_x >= left_edge){
		TweenLite.to(thumbs_mc, 0.5, {x : pos_x});
		}
	
	}
	
	
function rightClicked(e:MouseEvent):void{
	
	var pos_x:Number = thumbs_mc.x + 67;
	
	if(pos_x <= right_edge){
		TweenLite.to(thumbs_mc, 0.5, {x : pos_x});
		}
	
	}
	
	
function movieEnd(e:EBVideoEvent):void{
	
	video_screen.replay();
	
	}
	
	
function movieStart(e:EBVideoEvent):void{
	
	trace("start");
	video_screen.visible = true;
	
	}


//================================================//
//    MediaMind - Video Loader event handlers    //
//================================================//
//    The following functions are event handlers for the 
//    MediaMind VideoLoader component. 
//    The behavior of the following events can be determined 
//    by the custom code that you can add to each function. 
//    The Event handlers are for a specific instance of the 
//    Video Loader which is the prefix of the function name. 
//
//==========================================================//
//    NOTE: the names of the functions must not be changed, //
//          otherwise the function will not be called when  //
//          it should.                                      //
//==========================================================//


//+++++++++++++++++++++++++++++++++++++++++++++//
// 	   	   _videoScreenInst instance
//+++++++++++++++++++++++++++++++++++++++++++++//

//===========================================
// 	  	    Advanced Event handlers			 
//===========================================
//	  The following functions are used for the
//	  component advanced Events any special 
//	  handling should be added to these functions. 
//===========================================

var clicked_index = 0;

//--------_videoScreenInst_OnClick--------
function _videoScreenInst_OnClick()
{
	//TODO:  add your code for click handling.
	
	clicked_index ++;
	txt.text = "screen clicked: " + clicked_index;
	
	videoPlayPause();
	
	
}


function screenClicked(e:MouseEvent):void{
	
	clicked_index ++;
	txt.text = "screen clicked: " + clicked_index;
	
	videoPlayPause();
	
	}
	
	
function videoPlayPause():void{
	
	if(video_playing){
		video_screen.pause();
		video_playing = false;
		video_btn_mc.visible = true;
		}
	else{
		video_screen.play();
		video_playing = true;
		video_btn_mc.visible = false;
		}
	
	}
	
	
function screenMouseOver(e:MouseEvent):void{
	
	//trace("mouse over");
	
	video_btn_mc.btn.out.visible = false;
	video_btn_mc.btn.over.visible = true;
	
	}
	
function screenMouseOut(e:MouseEvent):void{
	
	//trace("out");
	
	video_btn_mc.btn.out.visible = true;
	video_btn_mc.btn.over.visible = false;
	
	}
	
	
function volumnClicked(e:MouseEvent):void{
	
	video_screen.audioToggle();
	
	if(volumn_on){
		
		volumn_button.is_off.visible = true;
		volumn_button.is_on.visible = false;
		
		volumn_on = false;
		
		}
	else{
		
		volumn_button.is_off.visible = false;
		volumn_button.is_on.visible = true;
		
		volumn_on = true;
		
		}
	
	}
	

//--------_videoScreenInst_OnRollover--------
function _videoScreenInst_OnRollover(fIsOver:Boolean)
{
	//TODO:  add your code for rollover handling.
	
	
	if(fIsOver){
		video_btn_mc.btn.out.visible = false;
		video_btn_mc.btn.over.visible = true;
		}
	else{
		video_btn_mc.btn.out.visible = true;
		video_btn_mc.btn.over.visible = false;
		}
	
	
	
}

//--------_videoScreenInst_OnMovieEnd--------
function _videoScreenInst_OnMovieEnd()
{
	//TODO:  add your code for the movieEnd event handling.
	
	trace("movie ends");
	
}

//===========================================
// 	 	    "Custom" Event handlers 
//===========================================
//    The following functions are handlers for 
//    the events that can be configured through 
//    the component inspector and  have several 
//    built in behaviors. these functions will 
//    be called just for cases that the "custom" 
//    option was chosen for these events. 
//===========================================

//--------_videoScreenInst_OnError--------
function _videoScreenInst_OnError(strInfo:String)
{
	//TODO:  add your code for error handling.
}

//--------_videoScreenInst_OnStatusChanged--------
function _videoScreenInst_OnStatusChanged(strStatus:String)
{
	//TODO:  add your code for the statusChanged event handling.
}

//--------_videoScreenInst_OnPlayProgress--------
function _videoScreenInst_OnPlayProgress(nProgress:Number)
{
	//TODO:  add your code for the playProgress event handling.
}

//--------_videoScreenInst_OnBufferProgress--------
function _videoScreenInst_OnBufferProgress(nProgress:Number)
{
	//TODO:  add your code for the bufferProgress event handling.
}

//--------_videoScreenInst_OnLoadProgress--------
function _videoScreenInst_OnLoadProgress(nProgress:Number)
{
	//TODO:  add your code for the loadProgress event handling.
}

//--------_videoScreenInst_OnBufferLoaded--------
function _videoScreenInst_OnBufferLoaded()
{
	//TODO:  add your code for the bufferLoaded event handling.
}

//--------_videoScreenInst_OnCuePoint--------
function _videoScreenInst_OnCuePoint(info)
{
	//TODO:  add your code for the cuePoint event handling.
}

//--------_videoScreenInst_OnMetaData--------
function _videoScreenInst_OnMetaData(info)
{
	//TODO:  add your code for the metaData event handling.
}
