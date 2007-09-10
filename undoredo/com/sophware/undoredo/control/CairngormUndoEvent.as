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
		private var _text:String;
		
		/**
		 * Creates a CairngormUndoEvent
		 */
		public function CairngormUndoEvent(text:String, type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			_text = text;
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