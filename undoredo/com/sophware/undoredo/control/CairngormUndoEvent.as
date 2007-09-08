package com.sophware.undoredo.control
{
	import com.adobe.cairngorm.control.CairngormEvent;

	public class CairngormUndoEvent extends CairngormEvent
	{
		private var _undoText:String;
		
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
		public function get undoText() : String
		{
			return _undoText;
		}
		
		/**
		 * Sets the text displayed describing the next event to be undone
		 */
		public function set undoText( text : String ) : void 
		{
			_undoText = text;
		}
	}
}