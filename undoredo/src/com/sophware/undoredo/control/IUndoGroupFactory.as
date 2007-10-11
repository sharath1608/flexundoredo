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
