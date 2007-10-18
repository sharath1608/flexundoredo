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
