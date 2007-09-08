package com.sophware.undoredo
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.sophware.undoredo.IUndoCommand;
	import com.adobe.cairngorm.control.CairngormEvent;

	public interface IUndoCommand extends ICommand
	{
		function undo( event : CairngormEvent = null) : void;
		function redo( event : CairngormEvent = null) : void;
		function mergeWith( cmd : IUndoCommand ) : Boolean; 
		function get undoType() : String;
		function get text() : String;
	}
}