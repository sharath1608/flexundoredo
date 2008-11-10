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
	import mx.collections.ArrayCollection;
	import com.sophware.undoredo.control.BaseUndoRedoEvent;
	
	/**
	 * Handles a set of synchronous commands as a single undoable operation.
	 *
	 * <p>
	 * Applies <code>undo()</code> or <code>redo()</code> on a set of commands, one after another.  Note
	 * that this assumes that everything is performed synchronously, so if the
	 * order in which the commands returns or the commands use delegates to
	 * perform the operation, a set of SequenceCommands might work better.
	 * </p>
	 *
	 * <p>
	 * Working with asynchronous commands is quite a bit more complicated,
	 * especially if they are to be treated as a single undoable operation.
	 * This might need to be integrated into the front controller later.
	 * </p>
	 *
	 * <p>
	 * The order in which the undo operation happens can be controlled by
	 * setting the order property to either FIFO or LIFO.  This is needed for
	 * operations that are not transitive.  The default order is LIFO.
	 * </p>
	 */
	public class AggregateUndoCommand extends UndoCommand
	{
		/**
		 * FIFO - First In First Out - The first operation applied will also
		 * be the first operation undone.
		 */
		public static const FIFO:String = "FIFO";

		/**
		 * LIFO - Last In First Out - The last operation applied will be the
		 * first operation undone.
		 */
		public static const LIFO:String = "LIFO";


		private var _order:String = LIFO;

		[Bindable]
		private var _commands:ArrayCollection = new ArrayCollection();


		/**
		 * Creates an AggregateUndoCommand.
		 */
		public function AggregateUndoCommand( cmds : ArrayCollection = null) : void
		{
			if (cmds != null)
				commands = cmds;
		}


		/**
		 * Returns the order in which the undo operations will be applied.
		 *
		 * @return The String representing the order of undo operations.
		 */
		public function get order():String
		{
			return _order;
		}

		/**
		 * Sets the order in which the undo operations will be applied.
		 * 
		 * @param s The order in which the operations will be undone.  This
		 * should be either <code>"LIFO"</code> or <code>"FIFO"</code>.
		 */
		public function set order(s:String):void
		{
			_order = s;
		}

		/**
		 * Performs the undo operations in the order specified by the
		 * <code>order</code> property.
		 */
		public override function undo() : void
		{
			
			var sz:Number = _commands.length;
			if (order == FIFO) {
				for (var i:Number=0; i<sz; i++) {
					_commands[i].undo();
				}
			} else {
				for (i=sz; i>0; i--) {
					_commands[i-1].undo();
				}
			}
		}

		/**
		 * Performs the redo operations in the order in which they were
		 * provided to the AggregateUndoCommand.
		 *
		 * @param event The parameter will be null for redo events and may be
		 * null the first time the command is executed.
		 */
		public override function redo( event : BaseUndoRedoEvent = null ) : void
		{
			// always apply redo in the same order
			var sz:Number = _commands.length;
			for (var i:Number=0; i<sz; i++) {
				_commands[i].redo( event );
			}
		}

		/**
		 * Returns the commands associated with this AggregateUndoCommand
		 */
		public function get commands():ArrayCollection
		{
			return _commands;
		}

		/**
		 * Sets the commands associated with this AggregateUndoCommand
		 */
		public function set commands( cmds: ArrayCollection ) : void
		{
			_commands = cmds;
		}
	}
}
