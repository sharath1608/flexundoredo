package com.sophware.undoredo.control
{
	import flash.events.Event;
	
	public class BaseUndoRedoEvent extends Event
	{
		public var data : *;
     
		public function BaseUndoRedoEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}

	}
}