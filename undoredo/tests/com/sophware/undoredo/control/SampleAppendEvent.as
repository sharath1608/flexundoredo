package tests.com.sophware.undoredo.control
{
	import com.adobe.cairngorm.control.CairngormEvent;

	public class SampleAppendEvent extends CairngormEvent
	{
		public static var EVENT_NAME:String = "append";
		
		public function SampleAppendEvent(value:String, appendText:String):void
		{
			super(EVENT_NAME);
			data = {
				value:value,
				appendText:appendText
				};
		}
	}
}
