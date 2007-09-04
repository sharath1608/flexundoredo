package com.sophware.undoredo
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	
	public class UndoCommand implements ICommand
	{
		private var _text:String;
		
		public function UndoCommand(text:String = null):void {
			_text = text;
		}
		
		public function get id() : Number {
			return -1;
		}
		
		public function mergeWith( cmd : UndoCommand ) : Boolean {
			return false;
		}
		
		public function undo( event : CairngormEvent = null ) : void {
			// must be overriden in derived class
		}
		
		public function redo( event : CairngormEvent = null ) : void {
			// must be overriden in derived class
		}
		
		public function execute( event : CairngormEvent ) : void {
			// doesn't need to be overridden, should always be equivalent to redo
			undo(event);
		}
		
		public function get text() : String {
			return _text;
		}
		
		public function set text( text: String ) : void {
			_text = text;
		}
	}
}
