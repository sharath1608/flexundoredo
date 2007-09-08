package com.sophware.undoredo
{
	import mx.collections.ArrayCollection;
	import com.sophware.undoredo.UndoCommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	
	/**
	 * @class UndoStack
	 * 
	 * This UndoStack class is based on the QUndoStack class that comes with
	 * Qt 4.X.  See http://doc.trolltech.com/4.3/qundostack.html.  It is a well
	 * designed class that leverages the command design pattern for undo and
	 * redo events.
	 */
	public class UndoStack
	{
		private var _stack:ArrayCollection = new ArrayCollection();
		private var _stackIndex:Number = -1;
		private var _undoLimit:Number = 0;


		/**
		 * True if an undoable event is present on the stack
		 */
		public function get canUndo():Boolean {
			return _stackIndex >= 0;
		}
		

		/**
		 * True if a redo operation can be performed
		 */
		public function get canRedo():Boolean {
			// note, if all undo events have been undone, than _stackIndex
			// will be -1 but stack.length will be greater than zero.  If
			// there aren't yet any undo events, then _stackIndex (-1) + 1
			// will be equal to the size of the stack, so this should work.
			return _stackIndex + 1 < _stack.length;
		}
		

		/**
		 * Clears the undo stack
		 */
		public function clear():void {
			_stack = new ArrayCollection();
			_stackIndex = -1;
		}

		/**
		 * Returns the size of the undo stack
		 */
		public function get count():Number {
			return _stack.length;
		}
		

		/**
		 * Returns the current index
		 */
		public function get index():Number {
			return _stackIndex;
		}
	
		
		/**
		 * Pushes \a cmd onto the UndoStack and executes the command.  The
		 * command will attempt to be merged with the prior command.
		 * 
		 * If the id for the cmd is non-negative and the id for the prior
		 * command and the command being pushed onto the stack are the same
		 * then OldCmd.mergeWith() will be called.  If OldCmd.mergeWith()
		 * returns true then the new command is deleted after it's associated
		 * action is performed.
		 *
		 * If previous operations had been undone but not redone, all commands
		 * after the command at index() will be deleted.
		 * 
		 * @param cmd The command being pushed onto the stack
		 * @param event The payload for the command being pushed onto the stack
		 */
		public function push(cmd:IUndoCommand, event:CairngormEvent = null):void {
			if (canRedo) {
				// delete all the currently redoable events
				removeCmds(_stackIndex + 1, _stack.length);
			}
			
			if (_stackIndex < 0 || !_stack[_stackIndex].mergeWith(cmd)) {
				addUndoCmd(cmd);
			}
			
			cmd.redo(event);
		}


		/**
		 * Returns the text associated with the next redo command
		 */
		public function get redoText():String {
			if (canRedo)
				return _stack[_stackIndex+1].text;
			return null;
		}


		/**
		 * Limits he number of commands that can be undone 
		 * param limit The number of commands that can be undone
		 */
		public function set undoLimit(limit:Number):void {
			if (limit > 0)
				_undoLimit = limit;
		}
	

		/**
		 * Returns the number of commands that can be undone
		 */
		public function get undoLimit():Number {
			return _undoLimit;
		}

		
		/**
		 * Returns the text associated with a specific index
		 */
		public function text(index:Number):String {
			if (isValidIndex(index))
				return _stack[index].text;
			return null;
		}


		/**
		 * Returns the undo text for the next undo command
		 */
		public function get undoText():String {
			if (_stack.length)
				return _stack[_stackIndex].text;
			return null;
		}


		/**
		 * Performs an undo operation
		 */
		public function undo():void {
			if (!_stack.length)
				return;
			_stack[_stackIndex].undo();
			_stackIndex--;
		}

		
		/**
		 * Performs a redo operation
		 */
		public function redo():void {
			if (!canRedo)
				return;
			_stack[_stackIndex+1].redo();
			_stackIndex++;
		}

		
		/**
		 * Repeatedly calls undo or redo to change change the state of the
		 * document.
		 */
		public function set index(index:Number):void {
			if (!isValidIndex(index))
				return;

			if (index < _stackIndex) {
				// perform undoes
				do {
					undo();
				} while (index < _stackIndex && _stackIndex >= 0);
			} else if (index > _stackIndex) {
				// perform redoes
				var cnt:Number = count;
				do {
					redo();
				} while (index > _stackIndex && _stackIndex);
			} // else no change
		}


		/**
		 * Returns true if the index is valid
		 */
		protected function isValidIndex(ix:Number):Boolean {
			if (ix >=0 && ix < count)
				return true;
			return false;
		}

		/**
		 * Adds an item to the top of the stack
		 */
		protected function addUndoCmd(cmd:IUndoCommand):void {
			_stack.addItem(cmd);
			_stackIndex++;
		}

		/**
		 * Removes the top item from the stack
		 */
		protected function removeUndoCmd():void {
			_stack.removeItemAt(_stack.length - 1);
			_stackIndex--;
		}

		/**
		 * Removes the items between the first index (inclusive) and the last
		 * index (exclusive).
		 * @param start The starting index, included in removal
		 * @param end The ending index, excluded from removal
		 *
 		 * @note It is assumed that _stackIndex is already set to something
		 * lower than the entries being removed, thus it is safe to perform
		 * this operation.  It will normally be used after a series of undo
		 * events have been performed and then a new undo event is pushed onto
		 * the stack, thus removing all the entries that are currently after
		 * the current _stackIndex;
		 */
		protected function removeCmds(start:Number, end:Number):void {
			if (end >= start || start < 0)
				return;

			var ix:Number = start;
			while (ix < end) {
				_stack.removeItemAt(ix++);
			}
		}
	}
}
