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
		 * The type of event
		 */
		public static const UNDOSTACK:String = "undostack"
		
		/**
		 * Indicates that an undo operation is to be performed
		 */
		public static const OPERATION_UNDO:String = "undo";
		
		/**
		 * Indicates that a redo operation is going to be performed
		 */
		public static const OPERATION_REDO:String = "redo";
		
		/**
		 * The operation being performed.  Should be either OPERATION_UNDO
		 * or OPERATION_REDO.
		 */
		public var operation:String;
		
		/**
		 * Creates an undo event that defaults to the undo operation
		 * 
		 * @param op Specifies the operation type
		 */
		public function UndoStackEvent(op:String = OPERATION_UNDO)
		{
			super("UNDO_STACK_EVENT");
			operation = op;
		}
	}
}