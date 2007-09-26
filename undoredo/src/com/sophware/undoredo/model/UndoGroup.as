package com.sophware.undoredo.model
{
	import flash.utils.Dictionary;

	/**
	 * A Group of UndoStacks.
	 * 
	 * <p>
	 * The UndoGroup class maintains a list of undo stacks.  Each stack might
	 * represent different tabs that are displayed on an interface, different
	 * documents that are available in a MDI interface, or something similar.
	 * </p>
	 * 
	 * <p>
	 * One UndoStack will be active at any time and accessors are provided
	 * that access information provided by thea active stack, such as the undo
	 * text, the redo text, and whether or not undo and redo are available.
	 * </p>
	 * 
	 * @see com.sophware.undoredo.model.UndoStack;
	 */
	public class UndoGroup
	{
		private var _stacks:Dictionary;
		
		[Bindable]
		private var _currentStack:Object;

		/**
		 * Creates an UndoGroup.
		 */
		public function UndoGroup():void
		{
			_stacks = new Dictionary();	
			_currentStack = null;
		}


		/**
		 * Returns the redo text associated with the active undo stack.
		 */
		public function get redoText() : String
		{
			return activeStack.redoText;
		}

		/**
		 * Returns the undo text associated with the active undo stack.
		 */
		public function get undoText() : String
		{
			return activeStack.undoText;
		}

		/**
		 * Returns true if the active undo stack can perform an undo operation.
		 */
		public function get canUndo() : Boolean
		{
			return activeStack.canUndo;
		}

		/**
		 * Returns true if the active undo stack can perform a redo operation.
		 */
		public function get canRedo() : Boolean
		{
			return activeStack.canRedo;
		}


		/**
		 * Adds a new undo stack with the \a name as specified.
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


		/**
		 * Removes the named undo stack from the undo group.
		 *
		 * <p>
		 * Removes the named undo stack from the undo group.  If the named
		 * undo stack is the active undo stack, a different active undo stack
		 * should be set to avoid errors.
		 * </p>
		 *
		 * @param name The name of the undo stack being removed
		 */
		public function removeStack( name : Object ) : Boolean
		{
			if (!hasStack(name))
				return false;
			delete _stacks[name];
			return true;
		}
		
		/**
		 * Returns true if a stack with \a name exists
		 * 
		 * @param name The name of the undo stack we are checking existance of
		 */
		public function hasStack( name : Object ) : Boolean
		{
			return _stacks[name] != undefined;
		}

		/**
		 * Returns the active undo stack as long as one stack has been added.
		 *
		 * <p>
		 * An error will occur if a stack has not yet been added to the undo
		 * group.
		 * </p>
		 */
		public function get activeStack() : UndoStack
		{
			return _stacks[_currentStack];
		}

		/**
		 * Sets the active undo stack to the stack associated with \a name.
		 * 
		 * <p>
		 * Note that \a name can be any object.  Thus, you might use the view
		 * that is being displayed as the name of the object, or you might use
		 * a string name that describes what the stack holds, such as as a
		 * filename, etc.
		 * </p>
		 * 
		 * @param name The name of the undo stack to be made active
		 * @return True if a new active stack has been set
		 */
		public function setActiveStack( name : Object ) : Boolean
		{
			if (!hasStack(name))
				return false;
			_currentStack = name;
			return true;
			
		}

		/**
		 * Returns true if the active stack is clean.
		 */
		public function get clean() : Boolean
		{
			return activeStack.clean;
		}

	}
}
