package com.sophware.undoredo
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	
	public class UndoCommand implements IUndoCommand
	{
		public static var UNDOTYPE_NORMAL:String = "normal";
		public static var UNDOTYPE_IGNORED:String = "ignored";
		public static var UNDOTYPE_RESET:String = "reset";
				
		private var _text:String;
		private var _undoType:String;
		
		public function UndoCommand():void {
			_undoType = UNDOTYPE_NORMAL;
		}
		
		public function get id() : Number {
			return -1;
		}
		
		public function mergeWith( cmd : IUndoCommand ) : Boolean {
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
			redo(event);
		}
		
		[Bindable]
		public function get text() : String {
			return _text;
		}
		
		public function set text( text: String ) : void {
			_text = text;
		}
		
		[Bindable]
		public function get undoType() : String {
			return _undoType;
		}
		
		public function set undoType(type : String) : void {
			_undoType = type;
		}
	}
}
