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
	 * The create function should return an UndoGroup object that has an
	 * active stack that can be used by the UndoFrontController.
	 * </p>
	 */
	public interface IUndoGroupFactory
	{
		function create():UndoGroup;
	}
}
