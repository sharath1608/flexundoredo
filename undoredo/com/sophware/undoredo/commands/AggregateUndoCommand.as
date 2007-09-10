package com.sophware.undoredo.commands
{
	/**
	 * 
	 * TODO: this does NOT handle asynchronous events
	 */
	public class AggregateUndoCommand extends UndoCommand
	{
		public static var FIFO:String = "FIFO";
		public static var LIFO:String = "LIFO";

		private var _order:String = LIFO;
		private var _commands:ArrayCollection = new ArrayCollection();

		public function AggregateUndoCommand( text : String ) : void {
			super(text);
		}

		public function get order():String {
			return _order;
		}

		public function set order(s:String):void {
			// FIXME: check the type
			_order = s;
		}

		public override function undo( event : CairngormEvent = null ) : void {
			
			var sz:Number = _commands.length;
			if (order == FIFO) {
				for (var i:Number=0; i<sz; i++) {
					_commands[i].undo( event );
				}
			} else {
				for (var i:Number=sz; i>0; i--) {
					_commands[i-1].undo( event );
				}
			}
		}

		public override function redo( event : CairngormEvent = null ) : void {
			// always apply redo in the same order
			var sz:Number = _commands.length;
			for (int i=0; i<sz; i++) {
				_commands[i].redo( event );
			}
		}
	}
}
