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
package com.sophware.undoredo.control
{
	import com.adobe.cairngorm.control.CairngormEvent;
	
	/**
	 * An event that stores information about a undo or redo request.
	 * 
	 * <p>
	 * The <code>UndoStack</code> has two different operations, undo and redo,
	 * specified by <code>OPERATION_UNDO</code> or
	 * <code>OPERATION_REDO.</code> <code>OPERATION_UNDO</code> is the default
	 * operation.
	 * </p>
	 */
	public class UndoStackEvent extends CairngormEvent
	{
		/**
		 * Event type for an undo operation.
		 */
		public static const UNDO:String = "undo_stack_event_undo";
		
		/**
		 * Event type for a redo operation.
		 */
		public static const REDO:String = "undo_stack_event_redo";
		
		/**
		 * The factory which returns the undo group that's in use.
		 */
		public var factory:IUndoGroupFactory;

		/**
		 * Creates an undo/redo event that defaults to the undo operation.
		 * 
		 * <p>
		 * The <code>factory</code> should be the same factory that is passed
		 * to the front controller or, at minimum, return the same undo group
		 * that is used by the front controller.  The operation undone (or
		 * redone) by the <code>UndoStackCommand</code> will be performed on
		 * the undo group that is returned by the factory.
		 * 
		 * </p>
		 * 
		 * @param factory The factory that returns the undogroup that is in use
		 * @param operation Specifies the operation type which should be
		 * either the <code>UNDO</code> or <code>REDO</code> constants
		 * specified above.
		 */
		public function UndoStackEvent(op:String = UNDO, factory:IUndoGroupFactory = null)
		{
			this.factory = factory;
			if (this.factory == null) {
				this.factory = new NamedUndoGroupFactory();
			}
			super(op);
		}
	}
}
