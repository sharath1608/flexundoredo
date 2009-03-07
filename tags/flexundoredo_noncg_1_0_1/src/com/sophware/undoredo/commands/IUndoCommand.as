/*
 * Copyright (C) 2007-2008 Soph-Ware Associates, Inc. 
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package com.sophware.undoredo.commands
{
	import com.sophware.undoredo.control.BaseUndoRedoEvent;
	
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
		 * The first time an event is pushed onto the UndoStack, the
		 * <code>execute()</code> method will be called with the generating
		 * event as a parameter.  The provided UndoFrontController will then
		 * delegate the functionality to the <code>redo()</code> function.  As
		 * <code>redo()</code> provides most of the desired behavior, redo is
		 * expected to store data sufficient for the operation to be undone
		 * and/or redone.  The redo operation will typically operate on the
		 * model or call delegates that will operate on the module.
		 * </p>
		 *
		 * <p>
		 * If the command wishes to use the text associated with a
		 * UndoEvent as its text then the redo event is responsible
		 * for pulling the data out of the event and placing it into the text
		 * property of the command.  This is the default behavior in
		 * UndoCommand, but overriding functions will need to call the
		 * parent's <code>redo()</code> function to have this behavior.
		 * </p>
		 *
		 * <p>
		 * By default, if <code>event</code> is of type
		 * <code>BaseUndoRedoEvent</code> the provided
		 * <code>UndoFrontController</code> will pull the text property of
		 * <code>event</code> into the text property of the command.
		 * </p>
		 * 
		 * @see com.sophware.undoredo.model.UndoStack
		 * @see com.sophware.undoredo.control.BaseUndoRedoEvent
		 * @see com.sophware.undoredo.control.UndoFrontController
		 */
		function redo( event : BaseUndoRedoEvent = null) : void;

		/**
		 * Returns the id associated with this command type.
		 *
		 * <p>
		 * Each command type should return their own individual id number if
		 * they wish to allow command merging, see <code>mergeWith()</code>,
		 * or a negative number if no command merging is supported.
		 * </p>
		 */
		function get id() : Number;
		
		/**
		 * Attempts to merge two undo/redo commands.
		 *
		 * <p>
		 * If <code>cmd.id()</code> is non-negative and has the same id as the
		 * current command, then a merge of the two commands is attempted,
		 * If the merge succeeds, <code>cmd</code> will be merged into this
		 * command and will become equivalent to calling both
		 * <code>this.redo()</code> and <code>cmd.redo()</code> on the
		 * non-merged command.
		 * </p>
		 *
		 * <p>
		 * This merging idea is based on the undo/redo implementation provided
		 * by Qt: <a
		 * href="http://doc.trolltech.com/4.3/qundocommand.html#mergeWith">http://doc.trolltech.com/4.3/qundocommand.html#mergeWith</a>
		 * </p>
		 *
		 * @param cmd The cmd to attempt to merge into this command
		 * @return true if the merge was successful, false otherwise
		 */
		function mergeWith( cmd : IUndoCommand ) : Boolean;

		/**
		 * The type of undo operation.
		 *
		 * <p>
		 * An operation can be <code>"normal"</code>, <code>"ignored"</code>,
		 * or <code>"reset"</code>.
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
		 *
		 * @return The current undoType
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
