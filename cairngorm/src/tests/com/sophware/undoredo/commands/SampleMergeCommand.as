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
			// this must return a non-negative number in order for the merge
			// to be considered
			return 1;
		}

		public override function mergeWith( cmd : IUndoCommand ) : Boolean
		{
			// the merge is considered if the id's match
			if (cmd.id == id) {
				var mc:SampleMergeCommand = cmd as SampleMergeCommand;
				// only merge if they represent the same data object.
				if (mc != null && _data == mc._data) {
					_text = _text + mc._text;
					return true;
				}
			}
			return false;
		}
	}


}
