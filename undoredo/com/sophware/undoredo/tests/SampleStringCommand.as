package com.sophware.undoredo.tests
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.sophware.undoredo.UndoCommand;


	public class SampleStringCommand extends UndoCommand
	{
		private var _appendText:String;
		private var _data:Object;
		
		public override function undo(event:CairngormEvent = null):void
		{
			_data.value = _data.value.slice( 0, _data.value.length - _appendText.length );
		}
		
		public override function redo(event:CairngormEvent = null):void
		{
			if (event != null) {
				_data = (event as SampleAppendEvent).data;
				_appendText = _data.appendText;
			}
			_data.value = _data.value.concat(_appendText);
			trace("-- event:",event);
			trace("-- event.data:",_data);
			trace("-- event.data.value:", _data.value);
		}
	}
}
