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
	import com.sophware.cairngorm.model.NamedObjectLocator;
	import com.sophware.undoredo.model.UndoGroup;
	
	/**
	 * A Factory that creates an UndoGroup for the UndoFrontController.
	 *
	 * <p>
	 * This factory creates an UndoGroup and places it in the
	 * NamedObjectLocator class under the name specified by UNDOGROUP_NAME at
	 * the time it is created.  At the time the UndoGroup is created, a stack
	 * is added to the UndoGroup with the name specified by UNDOSTACK_NAME.
	 * </p>
	 *
	 * <p>
	 * Only one instance (per <code>UNDOGROUP_NAME</code>) is created.
	 * Calling create a second time with the same name will return the same
	 * instance object.
	 * </p>
	 * 
	 * @see com.sophware.cairngorm.model.NamedObjectLocator
	 */
	public class NamedUndoGroupFactory implements IUndoGroupFactory
	{
		/**
		 * The name of the undo group that will be used to create or return
		 * the undo group returned by <code>getInstance()</code>.
		 */
		public static var UNDOGROUP_NAME:String = "undoGroup";

		/**
		 * The name of the undo stack that will be added to the undo group
		 * when it is created the first time <code>getInstance()</code> is
		 * called for the specified <code>UNDOGROUP_NAME</code>.
		 */
		public static var UNDOSTACK_NAME:String = "defaultStack";
		
		/**
		 * Returns the undo group instance that is created for or used by the
		 * specified <code>UNDOGROUP_NAME</code>.
		 */
		public function getInstance():UndoGroup
		{
			var ug:UndoGroup = NamedObjectLocator.getInstance().getObject(UNDOGROUP_NAME) as UndoGroup;
			if (ug == null) {
				ug = new UndoGroup();
				NamedObjectLocator.getInstance().setObject(UNDOGROUP_NAME, ug);
				ug.addStack(UNDOSTACK_NAME);
			}
			return ug;
		}

	}

}
