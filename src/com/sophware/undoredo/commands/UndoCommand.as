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
	import com.sophware.undoredo.commands.ICommand;
	import com.sophware.undoredo.control.BaseUndoRedoEvent;
	import com.sophware.undoredo.UndoRedoConstants;
	import com.sophware.undoredo.control.UndoEvent;
	
	/**
	 * A suitable base class that implements the IUndoCommand interface.
	 *
	 * @see com.sophware.undoredo.commands.IUndoCommand
	 */
	public class UndoCommand implements IUndoCommand
	{
		
		private var _text:String;
		private var _undoType:String;
		
		/**
		 * Creates an UndoCommand with no text specified.
		 */
		public function UndoCommand():void
		{
			_undoType = UndoRedoConstants.UNDOTYPE_NORMAL;
			_text = "";
		}
		

		/**
		 * The id associated with the specific IUndoCommand type.
		 */
		public function get id() : Number
		{
			return -1;
		}
		

		/**
		 * Attempts to merge two distinct undo commands into a single
		 * operation.
		 *
		 * @param cmd The command to attempt to merge with the current command
		 * @return True if the merge was successful, false otherwise
		 */
		public function mergeWith( cmd : IUndoCommand ) : Boolean
		{
			return false;
		}

	
		/**
		 * Performs an undo operation
		 */
		public function undo() : void
		{
			// must be overriden in derived class
		}
		

		/**
		 * Performs the initial modifications, as well as the redo operation
		 * after an undo event.
		 * 
		 * <p>
		 * By default, the event will be non-null the first time that an event
		 * is pushed onto the stack.  On subsequent redo events, the event
		 * will be null.
		 * </p>
		 */
		public function redo( event : BaseUndoRedoEvent = null ) : void
		{
			// must be overriden in derived class
		}
		

		/**
		 * Execute is called by the front controller and is only used for the
		 * initial set of modifications.
		 * 
		 * <p>
		 * This normally does not need to be overridden as it calls redo()
		 * which generally performs the necessary changes.  If the event type
		 * is BaseUndoRedoEvent, before calling redo, it will set the text of
		 * the undo command to the text property of the event.
		 * </p>
		 */
		public function execute( event : BaseUndoRedoEvent ) : void
		{
			// doesn't need to be overridden, should always be equivalent to redo
			if (event is UndoEvent)
				text = (event as UndoEvent).text;
			
			redo(event);
		}
	

		/**
		 * Returns the text description of this command.
		 */
		[Bindable]
		public function get text() : String
		{
			return _text;
		}
		

		/**
		 * Sets the text description of this command.
		 */
		public function set text( text: String ) : void
		{
			_text = text;
		}
		

		/**
		 * Returns the undo type associated with the command.
		 */
		[Bindable]
		public function get undoType() : String
		{
			return _undoType;
		}
		

		/**
		 * Sets the undo type associated with the command.
		 */
		public function set undoType(type : String) : void
		{
			_undoType = type;
		}
	}
}
