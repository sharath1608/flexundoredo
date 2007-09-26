package com.sophware.undoredo.commands
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;

	/**
	 * The Undo/Redo interface used by the undo/redo stack
	 */
	public interface IUndoCommand extends ICommand
	{
		/**
		 * Performs an undo operation.
		 * 
		 * <p>
		 * All data specific to the undo operation should have been stored at
		 * the time redo() was called with the initial event, as no
		 * information is passed to the undo event function directly.
		 * </p>
		 */
		function undo() : void;

		/**
		 * Performs a redo operation.
		 *
		 * <p>
		 * The first time an event is pushed onto the UndoStack, the execute()
		 * method will be called with the generating event as a parameter.
		 * The provided UndoFrontController will then delegate the
		 * functionality to the redo() function.  As redo() provides most of
		 * the desired behavior, redo is expected to store data sufficient for
		 * the operation to be undone and/or redone.  The redo operation will
		 * typically operate on the model or call delegates that will operate
		 * on the module.
		 * </p>
		 *
		 * <p>
		 * If the command wishes to use the text associated with a
		 * CairngormUndoEvent as its text then the redo event is responsible
		 * for pulling the data out of the event and placing it into the text
		 * property of the command.  This is the default behavior in
		 * UndoCommand, but overriding functions will need to call the parent's
		 * redo() function to have this behavior.
		 * </p>
		 *
		 * <p>
		 * By default, if \a event is of type CairngormUndoEvent the provided
		 * UndoFrontController will pull the text property of \a event into
		 * the text property of the command.
		 * </p>
		 * 
		 * @see com.sophware.undoredo.model.UndoStack
		 * @see com.sophware.undoredo.control.CairngormUndoEvent
		 * @see com.sophware.undoredo.control.UndoFrontController
		 */
		function redo( event : CairngormEvent = null) : void;

		/**
		 * Returns the id associated with this command type.
		 *
		 * <p>
		 * Each command type should return their own individual id number if
		 * they wish to allow command merging, see mergeWith(), or a negative
		 * number if no command merging is supported.
		 * </p>
		 */
		function get id() : Number;
		
		/**
		 * Attempts to merge two undo/redo commands.
		 *
		 * <p>
		 * If cmd.id() is non-negative and has the same id as the current
		 * command, then a merge of the two commands is attempted, with the
		 * 'this' command becoming equivalent to calling both this.redo() and
		 * cmd.redo() on the non-merged command.
		 * </p>
		 *
		 * <p>
		 * This merging idea is based on the undo/redo implementation provided
		 * by Qt: http://doc.trolltech.com/4.3/qundocommand.html#mergeWith
		 * </p>
		 */
		function mergeWith( cmd : IUndoCommand ) : Boolean;

		/**
		 * The type of undo operation.
		 *
		 * <p>
		 * An operation can be "normal", "ignored", or "reset".
		 * </p>
		 *
		 * <p>
		 * normal - Appends the command onto the undo stack, calls redo()
		 * </p>
		 *
		 * <p>
		 * ignored - Calls redo(), does not affect the undo stack
		 * </p>
		 *
		 * <p>
		 * reset - Calls redo(), clears the undo stack.
		 * </p>
		 */
		function get undoType() : String;

		/**
		 * Returns the text associated with this undo command
		 */
		function get text() : String;

		/**
		 * Sets the text associated with this undo command
		 */
		function set text( txt : String ) : void;
	}
}
