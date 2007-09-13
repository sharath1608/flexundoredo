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
		 * Performs a redo operation
		 *
		 * <p>
		 * event will often be a CairngormUndoEvent from which the text for
		 * the undo and redo operations will be pulled by the undo controller.
		 * </p>
		 *
		 * <p>
		 * redo() will be called when an command is pushed onto the stack, thus,
		 * it is the redo() function that will initially make changes to the
		 * model, etc.  redo() is expected to store the necessary data to be
		 * able to redo the operation after undo() is called.
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
		 */
		function redo( event : CairngormEvent = null) : void;

		/**
		 * Returns the id associated with this command type.  Each command type
		 * should return their own individual id number if they wish to allow
		 * command merging, see mergeWith(), or a negative number if no command
		 * merging is supported.
		 */
		function get id() : Number;
		
		/**
		 * Attempts to merge two undo/redo commands
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
