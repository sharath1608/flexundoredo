/*
 * This file is a part of the Flex UndoRedo Framework
 *  
 * Copyright (C) 2007 Soph-Ware Associates, Inc.
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Library General Public
 * License as published by the Free Software Foundation; either
 * version 2 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Library General Public License for more details.
 *
 * You should have received a copy of the GNU Library General Public License
 * along with this library; see the file LICENSE.TXT.  If not, write to
 * the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
 * Boston, MA 02110-1301, USA.
 */
package com.sophware.undoredo.model
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import mx.collections.ArrayCollection;
	
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.sophware.undoredo.commands.UndoCommand;
	import com.sophware.undoredo.commands.IUndoCommand;
	
	/**
	 * Maintains a list of undoable and redoable operations.
	 * 
	 * <p>
	 * The UndoStack contains a list of undo commands.  Each command can be
	 * undone or be redone.  If after a series of undo operations, a new
	 * event is pushed onto the undo stack (thus invalidating the events that
	 * are left to be redone), all events that had not yet been redone are 
	 * deleted from the stack and the new operation is pushed onto the stack.
	 * </p>
	 * 
	 * <p>
	 * This UndoStack class is based on the QUndoStack class that comes with
	 * Qt 4.X.  See http://doc.trolltech.com/4.3/qundostack.html.  It is a well
	 * designed class that leverages the command design pattern for undo and
	 * redo events.
	 * </p>
	 *
	 */
	public class UndoStack extends EventDispatcher
	{
		// are used for internal operations
		private var _stack:ArrayCollection = new ArrayCollection();
		private var _cleanIndex:Number = -1;
		
		// should only be used by associated getter/setter 
		private var __stackIndex:Number = -1;

		/**
		 * Creates an UndoStack
		 */
		public function UndoStack():void
		{
			// nothing special
		}


		/**
		 * True if an undoable event is present on the stack
		 */
		[Bindable("indexChanged")]
		public function get canUndo():Boolean
		{
			return stackIndex >= 0;
		}


		/**
		 * True if a redo operation can be performed
		 */
		[Bindable("indexChanged")]
		public function get canRedo():Boolean
		{
			// note, if all undo events have been undone, than stackIndex
			// will be -1 but stack.length will be greater than zero.  If
			// there aren't yet any undo events, then stackIndex (-1) + 1
			// will be equal to the size of the stack, so this should work.
			return stackIndex + 1 < _stack.length;
		}
		

		/**
		 * Clears the undo stack
		 */
		public function clear():void
		{
			_stack = new ArrayCollection();
			stackIndex = -1; 
			setCleanIndex(-1);
			dispatchEvent( new Event("countChanged") );
		}

		/**
		 * Returns the size of the undo stack
		 */
		[Bindable("countChanged")]
		public function get count():Number
		{
			return _stack.length;
		}
		

		/**
		 * Returns the index of the current command.
		 *
		 * <p>
		 * The current command is the command that will be executed on the
		 * next call to redo().  If no commands are on the stack, then -1 will
		 * be returned.  The current command is not always the top-most
		 * command on the stack as other commands may have been undone.
		 * </p>
		 *
		 * <p>
		 * The index is a zero based index that should be between zero and
		 * count - 1, inclusive.  An index of -1 implies that no entries are
		 * available on the undo stack.
		 * </p>
		 */
		[Bindable("indexChanged")]
		public function get index():Number
		{
			return stackIndex;
		}
	
		
		/**
		 * Pushes \a cmd onto the UndoStack and executes the command.
		 * 
		 * <p>
		 * The command will be executed with its execute() method when pushed.
		 * The execute method should generally delegate to the redo() method
		 * which will be called for subsequent redo operations.
		 * </p>
		 * 
		 * <p>
		 * If the id for the cmd is non-negative and the id for the prior
		 * command and the command being pushed onto the stack are the same
		 * then OldCmd.mergeWith() will be called.  If OldCmd.mergeWith()
		 * returns true then the new command is deleted after it's associated
		 * action is performed.
		 * </p>
		 * 
		 * <p>
		 * If previous operations had been undone but not redone, all commands
		 * after the command at index() will be deleted.
		 * </p>
		 * 
		 * @param cmd The command being pushed onto the stack
		 * @param event The payload for the command being pushed onto the stack
		 */
		public function push(cmd:IUndoCommand, event:CairngormEvent = null):void
		{
			
			if (canRedo) {
				// clear the clean index if necessary
				if (_cleanIndex > stackIndex)
					setCleanIndex(-1);
				
				// delete all the currently redoable events
				removeCmds(stackIndex + 1, _stack.length);
			}
			
			// NOTE: I must execute the command before I attempt to merge it
			// or push it on the stack because if I don't, and I'm using the
			// standard UndoCommand class, the text information will not have
			// been picked up from the event.
			cmd.execute(event);
			
			// if there aren't any undoable events to merge with or I
			// can't merge, then push the command
			if (stackIndex < 0 || !_stack[stackIndex].mergeWith(cmd)) {
				addUndoCmd(cmd);
			}
		}


		/**
		 * Returns the text associated with the next redo command.
		 *
		 * <p>
		 * An empty string is returned if no no redoable events are available.
		 * </p>
		 */
		[Bindable("indexChanged")]
		public function get redoText():String
		{
			if (canRedo)
				return _stack[stackIndex+1].text;
			return "";
		}

		/**
		 * Returns the undo text associated with \a index
		 *
		 * <p>
		 * If \a index is valid, then the text associated with it is
		 * returned, otherwise the empty string is returned.
		 * </p>
		 * 
		 * @param index A non-negative index number
		 */
		public function text(index:Number):String
		{
			if (isValidIndex(index))
				return _stack[index].text;
			return "";
		}


		/**
		 * Returns the undo text for the next undo command
		 *
		 * <p>
		 * An empty string is returned if no no undoable events are available.
		 * </p>
		 */
		[Bindable("indexChanged")]
		public function get undoText():String
		{
			if (canUndo)
				return _stack[stackIndex].text;
			return "";
		}


		/**
		 * Performs an undo operation if one is available
		 */
		public function undo():void
		{
			if (!canUndo)
				return;
			_stack[stackIndex].undo();
			stackIndex--;
		}

		
		/**
		 * Performs a redo operation if one is available
		 */
		public function redo():void
		{
			if (!canRedo)
				return;
			_stack[stackIndex+1].redo();
			stackIndex++;
		}

		
		/**
		 * Repeatedly calls undo or redo to change change the state of the
		 * document.
		 * 
		 * @param index a non-negative index number
		 */
		public function set index(ix:Number):void
		{
			if (!isValidIndex(ix))
				return;

			if (ix < stackIndex) {
				// perform undoes
				do {
					undo();
				} while (ix < stackIndex && stackIndex >= 0);
			} else if (ix > stackIndex) {
				// perform redoes
				var cnt:Number = count;
				do {
					redo();
				} while (ix > stackIndex);
			} // else no change
		}


		/**
		 * Returns true if the stack is in a clean state.
		 * 
		 * <p>
		 * The stack is considered clean if the current index is the index at
		 * which clean = true was last called.  The stack is clean by default.
		 * </p>
		 */
		[Bindable("cleanChanged")]
		public function get clean():Boolean
		{
			return cleanIndex == index;
		}

		/**
		 * Sets the clean index to the current index if set to a true value.
		 *
		 * <p>
		 * The clean index will be reset if the clean index is higher than the
		 * current index and an event is pushed onto the stack.  (In other
		 * words, if there are events to be redone and an event is pushed onto
		 * the stack.)  The cleanIndex is set to -1 in the event of a reset.
		 * </p>
		 */
		public function set clean(b:Boolean):void
		{
			if (!b)
				return;

			setCleanIndex(index);
		}

		/**
		 * Returns the index at which setClean was last called, or -1
		 * if it has not been called or has been reset.
		 */
		[Bindable("cleanChanged")]
		public function get cleanIndex():Number
		{
			return _cleanIndex;
		}



		/**
		 * @internal
		 *
		 * Returns true if the index is valid
		 * 
		 * @param ix a non-negative index number
		 */
		protected function isValidIndex(ix:Number):Boolean
		{
			if (ix >=0 && ix < count)
				return true;
			return false;
		}

		/**
		 * @internal
		 *
		 * Adds an undo command to the top of the stack
		 * 
		 * @param cmd The undo command to add to the stack
		 */
		protected function addUndoCmd(cmd:IUndoCommand):void
		{
			_stack.addItem(cmd);
			stackIndex++;
			dispatchEvent( new Event("countChanged") );
		}

		/**
		 * @internal
		 * 
		 * Removes the top undo command from the stack
		 */
		protected function removeUndoCmd():void
		{
			_stack.removeItemAt(_stack.length - 1);
			stackIndex--;
			dispatchEvent( new Event("countChanged") );
		}

		/**
		 * @internal
		 *
		 * Removes the items between the first index (inclusive) and the last
		 * index (exclusive).
		 *
		 * <p>
 		 * It is assumed that stackIndex is already set to something
		 * lower than the entries being removed, thus it is safe to perform
		 * this operation.  It will normally be used after a series of undo
		 * events have been performed and then a new undo event is pushed onto
		 * the stack, thus removing all the entries that are currently after
		 * the current stackIndex
		 * </p>
		 * 
		 * @param start The starting index, included in removal
		 * @param end The ending index, excluded from removal
		 */
		protected function removeCmds(start:Number, end:Number):void
		{
			if (end >= start || start < 0)
				return;

			var ix:Number = start;
			while (ix < end) {
				_stack.removeItemAt(ix++);
			}
		}

		/**
		 * @internal
		 *
		 * Returns the current stack index.
		 *
		 * <p>
		 * The whole purpose of having stackIndex getters and setters is to
		 * allow the indexChanged event to be dispatched so that the getters
		 * for canUndo, canRedo, undoText, and redoText will be updated
		 * appropriately.
		 * </p>
		 */
		protected function get stackIndex():Number
		{
			return __stackIndex;
		}

		/**
		 * @internal
		 * 
		 * Updates the current stack index.
		 *
		 * <p>
		 * Updates the current stack index and dispatches the indexChanged
		 * event.
		 * </p>
		 */
		protected function set stackIndex(ix:Number):void
		{
			__stackIndex = ix;
			dispatchEvent(new Event("indexChanged"));
			dispatchEvent(new Event("cleanChanged"));
		}

		/**
		 * @internal
		 *
		 * Updates the clean index and dispatches the cleanChanged event.
		 *
		 * <p>
		 * It would be nice if ActionScript supported public getters with
		 * private setters as then I wouldn't need this helper function.
		 * </p>
		 */
		protected function setCleanIndex(ix:Number):void
		{
			_cleanIndex = ix;
			dispatchEvent(new Event("cleanChanged"));
		}
	}
}
