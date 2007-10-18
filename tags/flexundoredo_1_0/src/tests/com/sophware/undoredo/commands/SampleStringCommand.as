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
package tests.com.sophware.undoredo.commands
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.sophware.undoredo.commands.UndoCommand;
	import tests.com.sophware.undoredo.control.SampleAppendEvent;

	public class SampleStringCommand extends UndoCommand
	{
		private var _appendText:String;
		private var _data:Object;
		
		public override function undo():void
		{
			_data.value = _data.value.slice( 0, _data.value.length - _appendText.length );
		}
		
		public override function redo(event:CairngormEvent = null):void
		{
			if (event != null) {
				_data = (event as SampleAppendEvent).data;
				_appendText = _data.appendText;
			}
			_data.value = _data.value.concat(_appendText);
		}
	}
}
