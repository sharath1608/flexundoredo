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
