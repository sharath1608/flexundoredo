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
package com.sophware.undoredo.control
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.FrontController;
	import com.adobe.cairngorm.CairngormError;
	import com.adobe.cairngorm.CairngormMessageCodes;
	
	import com.sophware.undoredo.UndoRedoConstants;
	import com.sophware.undoredo.commands.IUndoCommand;
	import com.sophware.undoredo.commands.UndoCommand;
	import com.sophware.undoredo.model.UndoStack;
	import com.sophware.undoredo.model.UndoGroup;
	
	/**
	 * A FrontController with undo and redo support.
	 *
	 * <p>
	 * This controller checks the command associated with the event in
	 * question to see if it is an IUndoCommand or if it is a regular
	 * ICommand.  If it is an IUndoCommand, then the undoType property is
	 * checked to see whether this command should be ignored (as specified by
	 * UNDOTYPE_IGNORED), pushed onto the stack (as specified by
	 * UNDOTYPE_NORMAL), or if the stack should be reset (as specified by
	 * UNDOTYPE_RESET).
	 * </p>
	 *
	 * <p>
	 * A normal undo command will be pushed onto the stack and then executed.
	 * In most cases, this should be identical to executing the command and
	 * then pushing it onto the undo stack, although it's possible to create
	 * undo commands that affect this behavior.
	 * </p>
	 * 
	 * <p>
	 * An undo command that is ignored is peformed but not pushed onto the
	 * stack.  Thus, it does not affect what events can be undone or redone.
	 * </p>
	 * 
	 * <p>
	 * An undo command that specifies reset will be executed and then the undo
	 * stack will be reset, clearing all undoable and redoable events.
	 * </p>
	 * 
	 * <p>
	 * If an event is pushed onto the stack that does not implement the
	 * IUndoCommand interface, then the event will be treated as either a
	 * ignored command or a reset undo command, depending on the value of the
	 * <code>nonUndoCommandUndoType</code> variable.
	 * </p>
	 *
	 * @see com.sophware.undoredo.UndoRedoConstants
	 */
	public class UndoFrontController extends FrontController
	{
		private var _undoGroup:UndoGroup;
		private var _activeStackName:Object;

		/**
		 * Specifies the undoType for non IUndoCommands that are executed.
		 */
		[Bindable] public var nonUndoCommandUndoType:String = UndoRedoConstants.UNDOTYPE_RESET;

		/**
		 * Creates a UndoFrontController.
		 *
		 * <p>
		 * This will create a default undo group as specified by the
		 * <code>factory</code> passed in.  If no factory is passed in, then
		 * the default NamedUndoGroupFactory is used to create the undo group
		 * that will be used by the front controller.
		 * </p>
		 *
		 * <p>
		 * Additional undo stacks can be added to the undo group by using the
		 * <code>addStack()</code> and <code>removeStack()</code> accessors,
		 * or by referencing the undo group directly.
		 * </p>
		 *
		 * @see com.sophware.undoredo.control.NamedUndoGroupFactory
		 */
		public function UndoFrontController(factory:IUndoGroupFactory = null)
		{
			import mx.binding.utils.BindingUtils;
			
			super();

			if (factory == null)
				factory = new NamedUndoGroupFactory();

			_undoGroup = factory.getInstance();

			BindingUtils.bindProperty(this, "activeStackName", _undoGroup, "activeStackName");
		}
		
		/**
		 * Executes the command associated with the event being received.
		 *
		 * <p>
		 * The command may be an undo command or a normal cairngorm command
		 * that implements the ICommand interface.  For a full description of
		 * the behavior, see the class-level documentation.
		 * </p>
		 * 
		 * <p>
		 * If the command being executed is an undo command and the type is
		 * <code>UNDOTYPE_NORMAL</code>, then the event being passed must be a 
		 * CairngormUndoEvent since the undo and redo text will be pulled
		 * from the generating event.  If the event is not a CairngormUndoEvent
		 * then null will be passed instead of the event in question.
		 * </p>
		 */
		protected override function executeCommand( event : CairngormEvent ) : void 
		{
			var commandToInitialise : Class = getCommand( event.type );
			var commandToExecute : ICommand = new commandToInitialise();

			// the commands that handle undo and redo (UndoStackCommand) are
			// no different than any other commands, they simply have
			// knowledge of the undo group and call undo or redo on the group.
			// They are typically (and should be) ignorable events.
			if (commandToExecute is IUndoCommand) {
				var cmd:IUndoCommand = commandToExecute as IUndoCommand;
				switch (cmd.undoType) {
					case UndoRedoConstants.UNDOTYPE_NORMAL:
						_undoGroup.activeStack.push(cmd, event);
						break;
					case UndoRedoConstants.UNDOTYPE_IGNORED:
						cmd.execute(event);
						break;
					case UndoRedoConstants.UNDOTYPE_RESET:
						cmd.execute(event);
						_undoGroup.activeStack.clear();
				}
			} else  {
				//
				// by default a command that doesn't implement the IUndoCommand interface
				// is a command that is non-undoable and, therefore, will cause the undo
				// stack to either be reset or be ignored.
				//
				
				// either way, execute the event
				commandToExecute.execute( event );
				
				if (nonUndoCommandUndoType == UndoRedoConstants.UNDOTYPE_RESET) {
					_undoGroup.activeStack.clear();
				}
	        }
		}
	
		/**
		 * Adds a new undo stack to the undo group.
		 *
		 * <p>
		 * The new undo stack automatically becomes the active undo stack.
		 * </p>
		 * 
		 * @param name The name of the undo stack to be added
		 * 
		 * @see com.sophware.cairngorm.model.UndoGroup
		 */
		public function addStack( name : Object ) : Boolean
		{
			return _undoGroup.addStack(name);
		}

		/**
		 * Removes the named undo stack from the undo group.
		 *
		 * <p>
		 * If the undo stack being removed from the undo group then the active
		 * undo stack will change.
		 * </p>
		 * 
		 * @param name The name of the undo stack to be removed
		 *
		 * @see com.sophware.cairngorm.model.UndoGroup
		 */
		public function removeStack( name : Object ) : Boolean
		{
			return _undoGroup.removeStack(name);
		}

		/**
		 * Sets the active undo stack to the named undo stack.
		 *
		 * <p>
		 * If the named undo stack does not exist, the active undo stack will
		 * not be changed.
		 * </p>
		 */
		[Bindable]
		public function set activeStackName( name : Object ) : void
		{
			if (_undoGroup.activeStackName != name)
				 _undoGroup.activeStackName = name;
			_activeStackName = name;
		}

		/**
		 * Returns the name of the active undo stack in the undo group.
		 */
		public function get activeStackName() : Object
		{
			return _activeStackName;
		}

		/**
		 * Returns the undo group that is used by the controller.
		 */
		public function get undoGroup() : UndoGroup
		{
			return _undoGroup;
		}
	}
}
