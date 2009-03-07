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
