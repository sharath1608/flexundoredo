package tests.com.sophware.undoredo.commands
{

	import com.sophware.undoredo.commands.UndoCommand;
	import com.sophware.undoredo.commands.IUndoCommand;
	import com.adobe.cairngorm.control.CairngormEvent;

	public class SampleMergeCommand extends UndoCommand
	{
		
		private var _data:Object;
		private var _text:String;

		public function SampleMergeCommand( data:Object, text:String ) : void
		{
			_data = data;
			_text = text;
		}
		
		public override function redo( event : CairngormEvent = null ) : void
		{
			_data.data = _data.data + _text;
		}

		public override function undo() : void
		{
			_data.data = _data.data.slice(0, _data.data.length - _text.length);
		}

		public override function get id() : Number
		{
			return 1;
		}

		public override function mergeWith( cmd : IUndoCommand ) : Boolean
		{
			if (cmd.id == id) {
				var mc:SampleMergeCommand = cmd as SampleMergeCommand;
				// only merge if they represent the same data object.
				if (_data == mc._data) {
					_text = _text + mc._text;
					return true;
				}
			}
			return false;
		}
	}


}
