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
	 * @see com.sophware.cairngorm.model.NamedObjectLocator
	 */
	public class NamedUndoGroupFactory implements IUndoGroupFactory
	{
		public static var UNDOGROUP_NAME:String = "undoGroup";
		public static var UNDOSTACK_NAME:String = "defaultStack";
		
		public function create():UndoGroup
		{
			var ug:UndoGroup = new UndoGroup();
			NamedObjectLocator.getInstance().setObject(UNDOGROUP_NAME, ug);
			ug.addStack(UNDOSTACK_NAME);
			return ug;
		}

	}

}
