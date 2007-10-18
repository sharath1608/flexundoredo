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
	 * A CairngormUndoEvent that contains a description of the undo/redo
	 * operation.
	 * 
	 * <p>The text property contains text that can be displayed to the user
	 */
	public class CairngormUndoEvent extends CairngormEvent
	{
		/**
		 * A String that may be used as the event type when working with the
		 * FrontController.
		 */
		public static const EVENT_TYPE:String = "cairngorm_undo_event";
		
		private var _text:String;
		
		/**
		 * Creates a CairngormUndoEvent
		 */
		public function CairngormUndoEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		/**
		 * Gets the text displayed describing the next event to be undone
		 * 
		 * <p>
		 * This menu is typically displayed in a menu or tooltip describing
		 * the next event to be undone.  Thus, you might see <tt>Edit-&gt;Undo
		 * TEXT</tt> where TEXT is the text describing the operation that would
		 * be undone.
		 * </p>
		 */
		public function get text() : String
		{
			return _text;
		}
		
		/**
		 * Sets the text displayed describing the next event to be undone
		 */
		public function set text( text : String ) : void 
		{
			_text = text;
		}
	}
}