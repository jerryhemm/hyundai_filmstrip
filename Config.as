//************************************************************************************** 
// This ActionScript code is part of the Filmstrip block 
// ALL RIGHTS RESERVED TO MediaMind. INC. (C) 
//**************************************************************************************
package com.mediamind.filmstrip 
{
	public class Config 
	{
		public static function reportCustomInteractionByLabel(label:String):void {
			switch(label) {
				case "Segment one label":
					EB.UserActionCounter("Segment one clicked");
				break;
				case "Segment two label":
					EB.UserActionCounter("Segment two clicked");
				break;
				case "Segment three label":
					EB.UserActionCounter("Segment three clicked");
				break;
				case "Segment four label":
					EB.UserActionCounter("Segment four clicked");
				break;
				case "Segment five label":
					EB.UserActionCounter("Segment five clicked");
				break;
			}
		};
	}
}
