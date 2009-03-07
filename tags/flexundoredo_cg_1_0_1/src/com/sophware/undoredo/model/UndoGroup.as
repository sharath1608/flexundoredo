/*
 * Copyright (C) 2007-2008 Soph-Ware Associates, Inc. 
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package com.sophware.undoredo.model
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	import mx.binding.utils.BindingUtils;

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
	 * that access information provided by the active stack, such as the undo
	 * text, the redo text, and whether or not undo and redo are available.
	 * </p>
	 * 
	 * @see com.sophware.undoredo.model.UndoStack
	 */
	public class UndoGroup extends EventDispatcher
	{
		private var _stacks:Dictionary;
		private var _currentStack:Object;

		private var _redoText:String = "";
		private var _undoText:String = "";
		private var _canUndo:Boolean;
		private var _canRedo:Boolean;
		private var _clean:Boolean;

		/**
		 * Creates an UndoGroup.
		 */
		public function UndoGroup():void
		{
			_stacks = new Dictionary();	
			_currentStack = null;
		
			// bind all the properties of the active stack to their corresponding read-only properties

			var self:Object = this;
			// hmm... I wonder if there is a better way to refactor this into a helper function/object?
			var setter:Function = function(arg:*):Boolean {
				var old:* = self._canUndo;
				self._canUndo = arg;
				return old != arg;
				}
			BindingHelper.readPropSetter(setter, "canUndoChanged", this, ["activeStack","canUndo"]);


			setter = function(arg:*):Boolean {
				var old:* = self._canRedo;
				self._canRedo = arg;
				return old != arg;
				}
			BindingHelper.readPropSetter(setter, "canRedoChanged", this, ["activeStack","canRedo"]);
		

			setter = function(arg:*):Boolean {
				var old:* = self._undoText;
				self._undoText = arg;
				return old != arg;
				}
			BindingHelper.readPropSetter(setter, "undoTextChanged", this, ["activeStack","undoText"]);


			setter = function(arg:*):Boolean {
				var old:* = self._redoText;
				self._redoText = arg;
				return old != arg;
				}
			BindingHelper.readPropSetter(setter, "redoTextChanged", this, ["activeStack","redoText"]);


			setter = function(arg:*):Boolean {
				var old:* = self._clean;
				self._clean = arg;
				return old != arg;
				}
			BindingHelper.readPropSetter(setter, "cleanChanged", this, ["activeStack","clean"]);
		}


		/**
		 * Returns the redo text associated with the active undo stack.
		 */
		[Bindable(event="redoTextChanged")]
		public function get redoText() : String
		{
			return _redoText; 
		}

		/**
		 * Returns the undo text associated with the active undo stack.
		 */
		[Bindable(event="undoTextChanged")]
		public function get undoText() : String
		{
			return _undoText;
		}

		/**
		 * Returns true if the active undo stack can perform an undo operation.
		 */
		[Bindable(event="canUndoChanged")]
		public function get canUndo() : Boolean
		{
			return _canUndo;
		}

		/**
		 * Returns true if the active undo stack can perform a redo operation.
		 */
		[Bindable(event="canRedoChanged")]
		public function get canRedo() : Boolean
		{
			return _canRedo;
		}


		/**
		 * Adds a new undo stack with the <code>name</code> as specified.
		 * 
		 * <p>
		 * The new undo stack will become the active stack
		 * </p>
		 * 
		 * @param name The name of the new undo stack
		 * @return True if the stack was added, false if it already exists.
		 * 
		 */
		public function addStack( name : Object ) : Boolean
		{
			if (hasStack(name))
				return false;
			_stacks[name] = new UndoStack();
			_currentStack = name;

			dispatchEvent( new Event("activeStackChanged") );
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
		 * @return True if the stack was removed, false if it did not exist
		 */
		public function removeStack( name : Object ) : Boolean
		{
			if (!hasStack(name))
				return false;
			delete _stacks[name];
			return true;
		}
		
		/**
		 * Returns true if a stack with <code>name</code> exists.
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
		[Bindable("activeStackChanged")]
		public function get activeStack() : UndoStack
		{
			return _stacks[_currentStack];
		}

		/**
		 * Sets the active undo stack to the stack associated with
		 * <code>name</code>.
		 * 
		 * <p>
		 * Note that <code>name</code> can be any object.  Thus, you might use
		 * the view that is being displayed as the name of the object, or you
		 * might use a string name that describes what the stack holds, such
		 * as as a filename, etc.
		 * </p>
		 *
		 * <p>
		 * If the undo group does not have a stack associated with
		 * <code>name</code> then the active undo stack will not be changed. 
		 * </p>
		 * 
		 * @param name The name of the undo stack to be made active
		 */
		[Bindable(event="activeStackChanged")]
		public function set activeStackName( name : Object ) : void
		{
			if (!hasStack(name))
				return;
			_currentStack = name;
			dispatchEvent( new Event("activeStackChanged") );
		}

		/**
		 * Returns the name of the new stack.
		 */
		[Bindable(event="activeStackChanged")]
		public function get activeStackName():Object
		{
			return _currentStack;
		}


		/**
		 * Returns true if the active stack is clean.
		 */
		[Bindable(event="cleanChanged")]
		public function get clean() : Boolean
		{
			return activeStack.clean;
		}

	}
}

import flash.events.Event;
import mx.binding.utils.BindingUtils;

/**
 * Helper class.
 */
class BindingHelper
{
	/**
	 * A slightly modified version of bindSetter.
	 *
	 * <p>
	 * Takes in a setter that accepts one argument, the new value of the
	 * argument in question, and dispatches <code>evt</code> if it has an
	 * undefined return value or returns something that evaluates to true.
	 * </p>
	 *
	 * @param setter The setter function, takes in a single argument and
	 * returns undefined (void) or something that can evaluate to true/false.
	 * @param evt The event that should be dispatched if the return value of
	 * <code>setter</code> is either undefined or true.
	 * @param self The EventDispatcher that contains the chain being
	 * monitored.
	 * @param chain The property chain to be monitored.  <code>chain</code>
	 * must meet the criteria described in
	 * mx.binding.utils.BindingUtils.bindProperty.  eg. It must contain one of
	 * the following:
	 * <ul>
	 * <li>a String containing the name of a bindable public property</li>
	 * <li>an Object of the form {name:property_name, getter:func} where func
	 * returns the value of the property</li>
	 * <li>a non-empty Array containing combinations of the first two
	 * options</li>
	 * </ul>
	 *
	 * @see mx.binding.utils.BindingUtils
	 */
	public static function readPropSetter(setter:Function, evt:String, self:Object, chain:Object):void
	{
		BindingUtils.bindSetter(
			function(arg:*):void {
				var res:* = setter(arg);
				if (res == undefined || res)
					self.dispatchEvent(new Event(evt));
				},
			self,
			chain
			);
	}

}
