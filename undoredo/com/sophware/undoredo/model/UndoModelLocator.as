package com.sophware.undoredo.model
{
	import com.adobe.cairngorm.model.IModelLocator;
	import com.adobe.cairngorm.CairngormError;
	import com.adobe.cairngorm.CairngormMessageCodes;
	
	import com.sophware.undoredo.UndoStack;

	public class UndoModelLocator implements IModelLocator
	{
		private static var instance:UndoModelLocator  = null;
		
		public var stack:UndoStack = null;
		
		public function UndoModelLocator():void {
			
			if (instance != null)
				throw new CairngormError(
					CairngormMessageCodes.SINGLETON_EXCEPTION, "UndoModelLocator"
					);
			instance = this;
			stack = new UndoStack();
		}
		
		public static function getInstance():UndoModelLocator
		{
			if (instance == null)
				instance == new UndoModelLocator();
			return instance;
		}
	}
}