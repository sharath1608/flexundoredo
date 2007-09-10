package com.sophware.cairngorm.model
{
	import flash.utils.Dictionary;

	import com.adobe.cairngorm.model.IModelLocator;
	import com.adobe.cairngorm.CairngormError;
	import com.adobe.cairngorm.CairngormMessageCodes;
	
	public class NamedObjectLocator implements IModelLocator
	{
		private static var _instance:NamedObjectLocator;
		
		private var _dict:Dictionary;
	
		public function NamedObjectLocator():void
		{
			if (_instance != null)
				throw new CairngormError(
					CairngormMessageCodes.SINGLETON_EXCEPTION, "NamedObjectLocator"
					);
			_dict = new Dictionary();
		}

		public static function getInstance() : NamedObjectLocator
		{
			if (_instance == null)
				_instance = new NamedObjectLocator();
			return _instance;
		}

		public function getObject( name : Object ) : Object
		{
			return _dict[name];
		}

		public function setObject( name : Object, obj : Object ) : void
		{
			_dict[name] = obj;
		}
	}
}
