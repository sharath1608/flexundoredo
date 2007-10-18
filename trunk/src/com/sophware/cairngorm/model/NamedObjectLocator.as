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
