package com.sophware.undoredo.commands
{
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import com.sophware.cairngorm.model.NamedObjectLocator;
	import com.sophware.undoredo.commands.UndoCommand;
	import com.sophware.undoredo.control.UndoStackEvent;
	import com.sophware.undoredo.model.UndoGroup;
	
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
			
			var undoGroup:UndoGroup = NamedObjectLocator.getInstance().getObject("undoGroup") as UndoGroup
			if (e.operation == UndoStackEvent.OPERATION_UNDO) {
				undoGroup.activeStack.undo();
			} else
				undoGroup.activeStack.redo();
		}
	}
}