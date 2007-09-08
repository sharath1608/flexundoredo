package com.sophware.undoredo.control
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.sophware.undoredo.UndoCommand;
	import com.sophware.undoredo.model.UndoModelLocator;
	
	public class UndoStackCommand extends UndoCommand
	{
		public function UndoStackCommand()
		{
			undoType = UndoCommand.UNDOTYPE_IGNORED;
		}
		
		public override function execute(event:CairngormEvent):void
		{
			var e:UndoStackEvent = event as UndoStackEvent;
			if (e == null)
				return;
			
			if (e.operation == UndoStackEvent.OPERATION_UNDO)
				UndoModelLocator.getInstance().stack.undo();
			else
				UndoModelLocator.getInstance().stack.redo();
		}
	}
}