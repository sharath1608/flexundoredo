package tests.com.sophware.undoredo.control
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.sophware.undoredo.control.CairngormUndoEvent;

	public class SampleAppendEvent extends CairngormUndoEvent
	{
		public static var EVENT_NAME:String = "append";
		
		public function SampleAppendEvent(text:String, value:String, appendText:String):void
		{
			super(text, EVENT_NAME);
			data = {
				value:value,
				appendText:appendText
				};
		}
	}
}
