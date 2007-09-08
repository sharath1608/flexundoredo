package com.sophware.undoredo.control
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.FrontController;
	import com.adobe.cairngorm.CairngormError;
	import com.adobe.cairngorm.CairngormMessageCodes;
	
	import com.sophware.undoredo.model.UndoModelLocator;
	import com.sophware.undoredo.IUndoCommand;
	import com.sophware.undoredo.UndoCommand;
	import com.sophware.undoredo.UndoStack;
	
	/**
	 * 
	 * TODO: implement support for macros
	 */
	public class UndoFrontController extends FrontController
	{
		private var undoStack:UndoStack;
		
		public function UndoFrontController()
		{
			super();
			undoStack = UndoModelLocator.getInstance().stack;
		}
		
		protected override function executeCommand( event : CairngormEvent ) : void 
		{
			var commandToInitialise : Class = getCommand( event.type );
			var commandToExecute : ICommand = new commandToInitialise();
			
			if (commandToExecute is IUndoCommand) {
				var cmd:IUndoCommand = commandToExecute as IUndoCommand;
				switch (cmd.undoType) {
					case UndoCommand.UNDOTYPE_NORMAL:
						undoStack.push(cmd, event);
						break;
					case UndoCommand.UNDOTYPE_IGNORED:
						cmd.execute(event);
						break;
					case UndoCommand.UNDOTYPE_RESET:
						cmd.execute(event);
						undoStack.clear();
					default:
						trace("Unknown undo type");
				}
			} else  {
				// by default a non-undoable command causes the stack to be reset.
				// if an event that is ignorable is really desired, implement the
				// IUndoCommand interface and set the undoType to:
				// UndoCommand.UNDOTYPE_IGNORED
				commandToExecute.execute( event );
				undoStack.clear();
	        }
		}
	}
}