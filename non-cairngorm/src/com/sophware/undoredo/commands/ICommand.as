package com.sophware.undoredo.commands
{
	import com.sophware.undoredo.control.BaseUndoRedoEvent;
	
	public interface ICommand
	{
		function execute( event : BaseUndoRedoEvent ) : void;
	}
}