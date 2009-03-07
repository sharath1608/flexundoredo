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
	import com.sophware.undoredo.control.BaseUndoRedoEvent;
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
		
		public override function redo(event:BaseUndoRedoEvent = null):void
		{
			if (event != null) {
				_data = (event as SampleAppendEvent).data;
				_appendText = _data.appendText;
			}
			_data.value = _data.value.concat(_appendText);
		}
	}
}
