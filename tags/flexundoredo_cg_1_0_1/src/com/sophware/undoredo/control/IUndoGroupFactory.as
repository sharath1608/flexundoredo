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
package com.sophware.undoredo.control
{
	import com.sophware.undoredo.model.UndoGroup;

	/**
	 * The provided interface for creating an UndoGroup for the front
	 * controller.
	 *
	 * <p>
	 * The <code>getInstance</code> function should return an
	 * <code>UndoGroup</code> object that has an active stack that can be used
	 * by the <code>UndoFrontController</code>.
	 * </p>
	 * 
	 * <p>
	 * This factory interface is used by both the
	 * <code>FrontUndoController</code> as well as the
	 * <code>UndoStackCommand</code>.  The FrontUndoController is passed an
	 * object that implements this interface.  That object is then used to
	 * create the undo group used by the undo controller.  This interface is
	 * used by the <code>UndoStackCommand</code> through the
	 * <code>UndoStackEvent</code>'s factory property.
	 * </p>
	 *
	 * @see com.sophware.undoredo.control.UndoStackEvent
	 * @see com.sophware.undoredo.control.FrontUndoController
	 * @see com.sophware.undoredo.commands.UndoStackCommand
	 */
	public interface IUndoGroupFactory
	{
		function getInstance():UndoGroup;
	}
}
