package com.sophware.undoredo.control
{
	import flash.events.Event;
	
	/**
	 * The base event for all events that can be undone or redone.
	 *
	 * <p>
	 * By extending this class, an event may be used with the undo stack.  The
	 * <code>data</code> property can contain information necessary for the
	 * command to be performed, or may be ignored by the command.
	 * </p>
	 */
	public class BaseUndoRedoEvent extends Event
	{
		/**
		 * Any event specific data that may be needed by the command.
		 */
		public var data : *;
     
		/**
		 * Base constructor.
		 *
		 * <p>
		 * The parameters to this constructor are the same as those for
		 * <code>Event</code>.
		 */
		public function BaseUndoRedoEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}

	}
}
