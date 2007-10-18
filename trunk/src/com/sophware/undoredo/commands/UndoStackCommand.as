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
package com.sophware.undoredo.commands
{
	import com.adobe.cairngorm.control.CairngormEvent;

	import com.sophware.cairngorm.model.NamedObjectLocator;
	import com.sophware.undoredo.UndoRedoConstants;
	import com.sophware.undoredo.commands.UndoCommand;
	import com.sophware.undoredo.control.UndoStackEvent;
	import com.sophware.undoredo.model.UndoGroup;
	
	/**
	 * An command class that operates on the undo group used by the
	 * UndoFrontController.
	 * 
	 * <p>
	 * This command will perform an undo or a redo as determined from the
	 * event type, which can be either UNDO or REDO.
	 * </p>
	 */
	public class UndoStackCommand extends UndoCommand
	{
		public function UndoStackCommand()
		{
			undoType = UndoRedoConstants.UNDOTYPE_IGNORED;
		}
		
		/**
		 * Executes an undo or redo operation based on event.operation.
		 * 
		 * <p>
		 * event is assumed to be a UndoStackEvent.  If it is not an 
		 * UndoStackEvent then no operation will be performed.  The operation
		 * is performed against the active undo stack used by the undo front
		 * controller.
		 * </p>
		 */
		public override function execute(event:CairngormEvent):void
		{
			var e:UndoStackEvent = event as UndoStackEvent;
			if (e == null)
				return;
			
			var undoGroup:UndoGroup = NamedObjectLocator.getInstance().getObject("undoGroup") as UndoGroup
			if (e.type == UndoStackEvent.UNDO) {
				undoGroup.activeStack.undo();
			} else
				undoGroup.activeStack.redo();
		}
	}
}
