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
package com.sophware.undoredo.commands
{
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
		 * <code>event</code> must be a <code>UndoStackEvent</code>.  If it is
		 * not an <code>UndoStackEvent</code>  or the factory property on the
		 * UndoStackEvent is null then no operation will be performed.  The
		 * operation is performed against the <code>undoGroup</code> that is
		 * returned by the <code>getInstance()</code> call to the factory
		 * property of the <code>UndoStackEvent</code>.
		 * </p>
		 */
		public override function execute(event:BaseUndoRedoEvent):void
		{
			var e:UndoStackEvent = event as UndoStackEvent;
			if (e == null || e.factory == null)
				return;
			
			var undoGroup:UndoGroup = e.factory.getInstance();
			if (undoGroup == null)
				return;
			if (e.type == UndoStackEvent.UNDO) {
				undoGroup.activeStack.undo();
			} else {
				undoGroup.activeStack.redo();
			}		
		}
	}
}
