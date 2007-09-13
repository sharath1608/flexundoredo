package com.sophware.undoredo.commands
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.sophware.undoredo.control.CairngormUndoEvent;
	
	/**
	 * A suitable base class that implements the IUndoCommand interface.
	 *
	 * @see com.sophware.undoredo.commands.IUndoCommand
	 */
	public class UndoCommand implements IUndoCommand
	{
		/**
		 * The "normal" undoType as specified by IUndoCommand
		 */
		public static const UNDOTYPE_NORMAL:String = "normal";
		
		/**
		 * The "ignored" undoType as specified by IUndoCommand
		 */
		public static const UNDOTYPE_IGNORED:String = "ignored";
		
		/**
		 * The "reset" undoType as specified by IUndoCommand
		 */
		public static const UNDOTYPE_RESET:String = "reset";
		
		
		private var _text:String;
		private var _undoType:String;
		
		
		/**
		 * Creates an UndoCommand with no text specified
		 */
		public function UndoCommand():void
		{
			_undoType = UNDOTYPE_NORMAL;
			_text = "";
		}
		

		/**
		 * The id associated with the specific IUndoCommand type
		 */
		public function get id() : Number
		{
			return -1;
		}
		

		/**
		 * Attempts to merge two distinct undo commands into a single
		 * operation.
		 */
		public function mergeWith( cmd : IUndoCommand ) : Boolean
		{
			return false;
		}

	
		/**
		 * Performs an undo operation
		 */
		public function undo() : void
		{
			// must be overriden in derived class
		}
		

		/**
		 * Performs the initial modifications, as well as the redo operation
		 * after an undo event.  Note that these operations should be
		 * equivalent.
		 */
		public function redo( event : CairngormEvent = null ) : void
		{
			// must be overriden in derived class
		}
		

		/**
		 * Execute is called by the front controller and is only used for the
		 * initial set of modifications.  This normally does not need to be
		 * overridden as it calls redo() which generally performs the necessary
		 * changes.  If the event type is CairngormUndoEvent, before calling
		 * redo, it will set the text of the undo command based on the text
		 * property of the event.
		 */
		public function execute( event : CairngormEvent ) : void
		{
			// doesn't need to be overridden, should always be equivalent to redo
			if (event is CairngormUndoEvent)
				text = (event as CairngormUndoEvent).text;
			
			redo(event);
		}
	

		/**
		 * Returns the text description of this command
		 */
		[Bindable]
		public function get text() : String
		{
			return _text;
		}
		

		/**
		 * Sets the text description of this command
		 */
		public function set text( text: String ) : void
		{
			_text = text;
		}
		

		/**
		 * Returns the undo type associated with the command
		 */
		[Bindable]
		public function get undoType() : String
		{
			return _undoType;
		}
		

		/**
		 * Sets the undo type associated with the command
		 */
		public function set undoType(type : String) : void
		{
			_undoType = type;
		}
	}
}
