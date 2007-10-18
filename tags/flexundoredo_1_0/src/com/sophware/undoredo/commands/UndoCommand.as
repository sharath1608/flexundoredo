/*
 * This file is a part of the Flex UndoRedo Framework
 *  
 * Copyright (C) 2007 Soph-Ware Associates, Inc.
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Library General Public
 * License as published by the Free Software Foundation; either
 * version 2 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Library General Public License for more details.
 *
 * You should have received a copy of the GNU Library General Public License
 * along with this library; see the file LICENSE.TXT.  If not, write to
 * the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
 * Boston, MA 02110-1301, USA.
 */
package com.sophware.undoredo.commands
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.sophware.undoredo.UndoRedoConstants;
	import com.sophware.undoredo.control.CairngormUndoEvent;
	
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
		public function redo( event : CairngormEvent = null ) : void
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
		 * is CairngormUndoEvent, before calling redo, it will set the text of
		 * the undo command to the text property of the event.
		 * </p>
		 */
		public function execute( event : CairngormEvent ) : void
		{
			// doesn't need to be overridden, should always be equivalent to redo
			if (event is CairngormUndoEvent)
				text = (event as CairngormUndoEvent).text;
			
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
