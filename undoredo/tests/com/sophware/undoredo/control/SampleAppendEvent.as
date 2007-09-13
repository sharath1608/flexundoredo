package tests.com.sophware.undoredo.control
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.sophware.undoredo.control.CairngormUndoEvent;

	public class SampleAppendEvent extends CairngormUndoEvent
	{
		public static const APPEND:String = "sample_append_event";
		
		public function SampleAppendEvent(value:String, appendText:String):void
		{
			super(APPEND);
			text = "append";
			data = {
				value:value,
				appendText:appendText
				};
		}
	}
}
