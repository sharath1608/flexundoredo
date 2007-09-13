package com.sophware.undoredo.commands
{
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import com.sophware.cairngorm.model.NamedObjectLocator;
	import com.sophware.undoredo.commands.UndoCommand;
	import com.sophware.undoredo.control.UndoStackEvent;
	import com.sophware.undoredo.model.UndoGroup;
	
	/**
	 * An command class that operates on the undo group used by the
	 * UndoFrontController.
	 * 
	 * <p>
	 * This command will perform an undo or a redo as determined from the
	 * event type, which can be either UNDO or REDO.
	 * </p>
	 */
	public class UndoStackCommand extends UndoCommand
	{
		public function UndoStackCommand()
		{
			undoType = UndoCommand.UNDOTYPE_IGNORED;
		}
		
		/**
		 * Executes an undo or redo operation based on event.operation.
		 * 
		 * <p>
		 * event is assumed to be a UndoStackEvent.  If it is not an 
		 * UndoStackEvent then no operation will be performed.  The operation
		 * is performed against the active undo stack used by the undo front
		 * controller.
		 * </p>
		 */
		public override function execute(event:CairngormEvent):void
		{
			var e:UndoStackEvent = event as UndoStackEvent;
			if (e == null)
				return;
			
			var undoGroup:UndoGroup = NamedObjectLocator.getInstance().getObject("undoGroup") as UndoGroup
			if (e.type == UndoStackEvent.UNDO) {
				undoGroup.activeStack.undo();
			} else
				undoGroup.activeStack.redo();
		}
	}
}