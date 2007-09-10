package com.sophware.undoredo.model
{
	import flash.utils.Dictionary;

	public class UndoGroup
	{
		private var _stacks:Dictionary;
		private var _currentStack:Object;

		public function UndoGroup():void
		{
			_stacks = new Dictionary();	
		}

		public function get redoText() : String
		{
			return activeStack.redoText;
		}

		public function get undoText() : String
		{
			return activeStack.undoText;
		}

		public function get canUndo() : Boolean
		{
			return activeStack.canUndo;
		}

		public function get canRedo() : Boolean
		{
			return activeStack.canRedo;
		}


		/**
		 * Adds a new undo stack with the \a name as specified
		 * 
		 * <p>
		 * The new undo stack will become the active stack
		 * </p>
		 * 
		 * @param name The name of the new undo stack
		 * 
		 */
		public function addStack( name : Object ) : Boolean
		{
			if (hasStack(name))
				return false;
			_stacks[name] = new UndoStack();
			_currentStack = name;
			return true;
		}

		public function removeStack( name : Object ) : Boolean
		{
			if (!hasStack(name))
				return false;
			delete _stacks[name];
			return true;
		}

		public function hasStack( name : Object ) : Boolean
		{
			return _stacks[name] != undefined;
		}

		[Bindable]
		public function get activeStack() : UndoStack
		{
			return _stacks[_currentStack];
		}

		public function set activeStack( name : Object ) : void
		{
			if (hasStack(name))
				_currentStack = name;
		}

	}
}
