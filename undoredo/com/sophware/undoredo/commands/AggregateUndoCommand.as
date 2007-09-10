package com.sophware.undoredo.commands
{
	/**
	 * Handles a set of synchronous commands as a single undoable operation.
	 *
	 * <p>
	 * Applies undo() or redo() on a set of commands, one after another.  Note
	 * that this assumes that everything is performed synchronously, so if the
	 * order in which the commands returns or the commands use delegates to
	 * perform the operation, a set of SequenceCommands might work better.
	 * </p>
	 *
	 * <p>
	 * Working with asynchronous commands is quite a bit more complicated,
	 * especially if they are to be treated as a single undoable operation.
	 * Specifically, this will need to be integrated at the undo controller
	 * level.
	 * </p>
	 *
	 * <p>
	 * The order in which the undo operation happens can be controlled by
	 * setting the order property to either FIFO or LIFO.  The order defaults
	 * to LIFO which is the usual order of undo operations.
	 * </p>
	 */
	public class AggregateUndoCommand extends UndoCommand
	{
		/**
		 * FIFO - First In First Out - The first operation applied will also
		 * be the first operation undone.
		 */
		public static const FIFO:String = "FIFO";

		/**
		 * LIFO - Last In First Out - The last operation applied will be the
		 * first operation undone.
		 */
		public static const LIFO:String = "LIFO";


		private var _order:String = LIFO;


		/**
		 * FIXME: how should I make this public?
		 */
		protected var _commands:ArrayCollection = new ArrayCollection();



		/**
		 * Creates an AggregateUndoCommand
		 */
		public function AggregateUndoCommand() : void
		{
		}


		/**
		 * Returns the order in which the undo operations will be applied
		 */
		public function get order():String
		{
			return _order;
		}

		/**
		 * Sets the order in which the undo operations will be applied
		 */
		public function set order(s:String):void
		{
			// FIXME: check the type
			_order = s;
		}

		/**
		 * Performs the undo operations in the order specified by \a order
		 */
		public override function undo() : void
		{
			
			var sz:Number = _commands.length;
			if (order == FIFO) {
				for (var i:Number=0; i<sz; i++) {
					_commands[i].undo();
				}
			} else {
				for (var i:Number=sz; i>0; i--) {
					_commands[i-1].undo();
				}
			}
		}

		/**
		 * Performs the redo operations in the order in which they were
		 * provided to the AggregateUndoCommand.
		 */
		public override function redo( event : CairngormEvent = null ) : void {
			// always apply redo in the same order
			var sz:Number = _commands.length;
			for (int i=0; i<sz; i++) {
				_commands[i].redo( event );
			}
		}
	}
}
