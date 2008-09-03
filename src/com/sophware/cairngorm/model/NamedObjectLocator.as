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
package com.sophware.cairngorm.model
{
	import flash.utils.Dictionary;

	import com.adobe.cairngorm.model.IModelLocator;
	import com.adobe.cairngorm.CairngormError;
	import com.adobe.cairngorm.CairngormMessageCodes;
	
	/**
	 * Provides singleton like access to different named objects.
	 *
	 * <p>
	 * This class is a singleton that provides access to different named
	 * objects.  These are basically named singletons, or shared global
	 * objects.  It essentially supports the Multiton pattern (eg. one
	 * instance per keyword).
	 * </p>
	 */
	public class NamedObjectLocator implements IModelLocator
	{
		private static var _instance:NamedObjectLocator;
		
		private var _dict:Dictionary;
	
		/**
		 * Creates the NamedObjectLocator object.
		 *
		 * <p>
		 * As this is a singleton, only one instance is allowed.
		 * </p>
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
		 * Returns the only instance of this NamedObjectLocator class.
		 * 
		 * @return A NamedObjectLocator instance
		 */
		public static function getInstance() : NamedObjectLocator
		{
			if (_instance == null)
				_instance = new NamedObjectLocator();
			return _instance;
		}

		/**
		 * Returns an object by name, if it exists.
		 *
		 * @param name The name of the object to be returned
		 * @return The object specified by <code>name</code> or null
		 */
		public function getObject( name : Object ) : Object
		{
			return _dict[name];
		}

		/**
		 * Sets the name of an object and its corresponding value.
		 */
		public function setObject( name : Object, value : Object ) : void
		{
			_dict[name] = value;
		}
	}
}
