package tests.com.sophware.undoredo.commands
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.sophware.undoredo.commands.UndoCommand;
	import tests.com.sophware.undoredo.control.SampleAppendEvent;

	public class SampleStringCommand extends UndoCommand
	{
		private var _appendText:String;
		private var _data:Object;
		
		public override function undo():void
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
		}
	}
}
