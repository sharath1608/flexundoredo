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
	import flexunit.framework.TestCase;
	import com.sophware.undoredo.model.UndoStack;
	import tests.com.sophware.undoredo.control.SampleAppendEvent;

	public class UndoCommandTest extends TestCase
	{
		private var _data:Object; 
		private var _stack:UndoStack;
		
		public override function setUp():void {
			_data = {value:"Some String"};
			_stack = new UndoStack();
		}
		
		public function testUndo():void {
			var cmd:SampleStringCommand = new SampleStringCommand();
			var event:SampleAppendEvent = new SampleAppendEvent("Some String", " appended text");

			assertEquals("Some String", event.data.value);
			_stack.push(cmd, event);
			assertEquals("Some String appended text", event.data.value);
			_stack.undo();
			assertEquals("Some String", event.data.value);
		}
		
		public function  testRedo():void {
			var cmd:SampleStringCommand = new SampleStringCommand();
			var event:SampleAppendEvent = new SampleAppendEvent("Some String", " appended text");

			assertEquals("Some String", event.data.value);
			_stack.push(cmd, event);
			assertEquals("Some String appended text", event.data.value);
			_stack.undo();
			assertEquals("Some String", event.data.value);
			_stack.redo();
			assertEquals("Some String appended text", event.data.value);
		}
		
		
	}
}
