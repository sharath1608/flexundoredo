package com.sophware.undoredo.control
{
	public class UndoStackEvent extends CairngormUndoEvent
	{
		public static var OPERATION_UNDO:String = "undo";
		public static var OPERATION_REDO:String = "redo";
		
		// set to OPERATION_UNDO if this should cause an undo event, otherwise
		// it will cause a REDO event.
		public var operation:String = OPERATION_UNDO;
		
		public function UndoStackEvent()
		{
			super("UNDO_STACK_EVENT");
		}
	}
}