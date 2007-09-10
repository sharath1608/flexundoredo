package com.sophware.cairngorm.model
{
	import flash.utils.Dictionary;

	import com.adobe.cairngorm.model.IModelLocator;
	import com.adobe.cairngorm.CairngormError;
	import com.adobe.cairngorm.CairngormMessageCodes;
	
	/**
	 * Provides singleton like access to different named objects
	 *
	 * <p>
	 * This class is a singleton that provides access to different named
	 * objects.  These are basically named singletons, or shared global
	 * objects.
	 * </p>
	 */
	public class NamedObjectLocator implements IModelLocator
	{
		private static var _instance:NamedObjectLocator;
		
		private var _dict:Dictionary;
	
		/**
		 * Creates the NamedObjectLocator object.  As this is a singleton,
		 * only one instance is allowed.
		 */
		public function NamedObjectLocator():void
		{
			if (_instance != null)
				throw new CairngormError(
					CairngormMessageCodes.SINGLETON_EXCEPTION, "NamedObjectLocator"
					);
			_dict = new Dictionary();
		}

		/**
		 * Returns the only instance of this NamedObjectLocator class
		 */
		public static function getInstance() : NamedObjectLocator
		{
			if (_instance == null)
				_instance = new NamedObjectLocator();
			return _instance;
		}

		/**
		 * Returns an object by name, if it exists
		 *
		 * @param The name of the object to be returned
		 */
		public function getObject( name : Object ) : Object
		{
			return _dict[name];
		}

		/**
		 * Sets the name of an object and its corresponding value
		 */
		public function setObject( name : Object, value : Object ) : void
		{
			_dict[name] = value;
		}
	}
}
