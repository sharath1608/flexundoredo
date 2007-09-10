package com.sophware.undoredo.control
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.FrontController;
	import com.adobe.cairngorm.CairngormError;
	import com.adobe.cairngorm.CairngormMessageCodes;
	
	import com.sophware.undoredo.commands.IUndoCommand;
	import com.sophware.undoredo.commands.UndoCommand;
	import com.sophware.undoredo.model.UndoStack;
	import com.sophware.cairngorm.model.NamedObjectLocator;
	import com.sophware.undoredo.model.UndoGroup;
	
	/**
	 * 
	 * TODO: implement support for macros
	 */
	public class UndoFrontController extends FrontController
	{
		private var _locator:NamedObjectLocator;
		private var _undoGroup:UndoGroup;
		
		public function UndoFrontController()
		{
			super();
			_locator = NamedObjectLocator.getInstance();
			_locator.setObject("undoGroup", new UndoGroup());	
			_undoGroup = _locator.getObject("undoGroup") as UndoGroup;
			_undoGroup.addStack("defaultStack");
		}
		
		protected override function executeCommand( event : CairngormEvent ) : void 
		{
			var commandToInitialise : Class = getCommand( event.type );
			var commandToExecute : ICommand = new commandToInitialise();
			
			if (commandToExecute is IUndoCommand) {
				var cmd:IUndoCommand = commandToExecute as IUndoCommand;
				switch (cmd.undoType) {
					case UndoCommand.UNDOTYPE_NORMAL:
						_undoGroup.activeStack.push(cmd, event);
						break;
					case UndoCommand.UNDOTYPE_IGNORED:
						cmd.execute(event);
						break;
					case UndoCommand.UNDOTYPE_RESET:
						cmd.execute(event);
						_undoGroup.activeStack.clear();
					default:
						trace("Unknown undo type");
				}
			} else  {
				//
				// by default a command that doesn't implement the IUndoCommand interface
				// is a command that is non-undoable and, therefore, will cause the undo
				// stack to be reset.
				// 
				// if an event that is ignorable is really desired, implement the
				// IUndoCommand interface and set the undoType to:
				//
				// UndoCommand.UNDOTYPE_IGNORED
				//
				commandToExecute.execute( event );
				_undoGroup.activeStack.clear();
	        }
		}
	}
}