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
	 * An event that stores information about a undo or redo request
	 * 
	 * <p>
	 * The UndoStack has two different operations, undo and redo, specified by
	 * OPERATION_UNDO or OPERATION_REDO.  OPERATION_UNDO is the default
	 * operation.
	 * </p>
	 */
	public class UndoStackEvent extends CairngormEvent
	{
		/**
		 * Event type for an undo operation
		 */
		public static const UNDO:String = "undo_stack_event_undo";
		
		/**
		 * Event type for a redo operation
		 */
		public static const REDO:String = "undo_stack_event_redo";
		
		/**
		 * Creates an undo/redo event that defaults to the undo operation
		 * 
		 * @param op Specifies the operation type
		 */
		public function UndoStackEvent(op:String = UNDO)
		{
			super(op);
		}
	}
}