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
