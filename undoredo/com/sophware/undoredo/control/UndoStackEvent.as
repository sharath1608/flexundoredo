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