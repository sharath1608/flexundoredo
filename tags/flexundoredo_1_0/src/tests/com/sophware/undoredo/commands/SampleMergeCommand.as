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

	import com.sophware.undoredo.commands.UndoCommand;
	import com.sophware.undoredo.commands.IUndoCommand;
	import com.adobe.cairngorm.control.CairngormEvent;

	public class SampleMergeCommand extends UndoCommand
	{
		
		private var _data:Object;
		private var _text:String;

		public function SampleMergeCommand( data:Object, text:String ) : void
		{
			_data = data;
			_text = text;
		}
		
		public override function redo( event : CairngormEvent = null ) : void
		{
			_data.data = _data.data + _text;
		}

		public override function undo() : void
		{
			_data.data = _data.data.slice(0, _data.data.length - _text.length);
		}

		public override function get id() : Number
		{
			return 1;
		}

		public override function mergeWith( cmd : IUndoCommand ) : Boolean
		{
			if (cmd.id == id) {
				var mc:SampleMergeCommand = cmd as SampleMergeCommand;
				// only merge if they represent the same data object.
				if (_data == mc._data) {
					_text = _text + mc._text;
					return true;
				}
			}
			return false;
		}
	}


}
