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
