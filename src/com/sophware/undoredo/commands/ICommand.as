package com.sophware.undoredo.commands
{
	import com.sophware.undoredo.control.BaseUndoRedoEvent;
	
	/**
	 * This interface represents a single command that cannot be undone.
	 */
	public interface ICommand
	{
		/**
		 * Performs a command.
		 * 
		 * <p>
		 * Performs the command, possibly using any information available in the
		 * <code>event</code> parameter.
		 * </p>
		 */
		function execute( event : BaseUndoRedoEvent ) : void;
	}
}
