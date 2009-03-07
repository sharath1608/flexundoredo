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
package tests.com.sophware.undoredo.control
{
	import flash.utils.Timer;
	import flash.events.TimerEvent;

	import flexunit.framework.TestCase;

	import com.adobe.cairngorm.control.CairngormEventDispatcher;
	import com.adobe.cairngorm.control.CairngormEvent;

	import com.sophware.undoredo.control.NamedUndoGroupFactory;
	import com.sophware.undoredo.control.UndoFrontController;
	import com.sophware.undoredo.control.UndoStackEvent;
	import com.sophware.undoredo.commands.UndoStackCommand;

	import tests.com.sophware.undoredo.control.SampleAppendEvent;
	import tests.com.sophware.undoredo.commands.SampleStringCommand;

	public class UndoFrontControllerTest extends TestCase
	{
		[Bindable] public var activeStackName:Object;
		
		private static var _controller:UndoFrontController;
		
		public function UndoFrontControllerTest() : void
		{
			super();
			if (_controller == null) {
				_controller = new UndoFrontController();
				_controller.addCommand(SampleAppendEvent.APPEND, SampleStringCommand);
				_controller.addCommand(UndoStackEvent.UNDO, UndoStackCommand);
				_controller.addCommand(UndoStackEvent.REDO, UndoStackCommand);
			}
		}
		
		public function testInvokesCommand():void
		{
			var event:SampleAppendEvent = invokeAppendCommand();
			
			// create a closure that will be used to test the object
			var f:Function = function(e:*):void
			{
				// make sure that it was actually called correctly
				assertEquals("firstsecond", event.data.value);
			}

			callbackHelper(f);
		}
		
		public function testUndoEventCausesUndo():void
		{
			var event:SampleAppendEvent = invokeAppendCommand();
			CairngormEventDispatcher.getInstance().dispatchEvent(
				new UndoStackEvent()
				);

			// create a closure that will be used to test the object
			var f:Function = function(e:*):void
			{
				// make sure that it was actually called correctly
				assertEquals("first", event.data.value);
			}
			callbackHelper(f);
		}
		
		public function testRedoEventCausesRedo():void
		{
			var event:SampleAppendEvent = invokeAppendCommand();
			
			// invoke an undo operation so I have something to redo
			CairngormEventDispatcher.getInstance().dispatchEvent(
				new UndoStackEvent()
				);

			// invoke a redo operation that I will test against
			var redo:UndoStackEvent = new UndoStackEvent(UndoStackEvent.REDO);
			CairngormEventDispatcher.getInstance().dispatchEvent( redo );

			// create a closure that will be used to test the object
			var f:Function = function(e:*):void
			{
				// make sure that it was actually called correctly
				assertEquals("firstsecond", event.data.value);
			}
			callbackHelper(f);
		}
	

		public function testActiveStackNameBinding():void
		{
			import mx.binding.utils.BindingUtils;
			
			BindingUtils.bindProperty(this, "activeStackName", _controller, "activeStackName");

			assertEquals(NamedUndoGroupFactory.UNDOSTACK_NAME, activeStackName);

			// addStack will automatically cause the active undo stack to be
			// changed
			_controller.addStack("NewStack");

			assertEquals("NewStack", activeStackName);
		}


		/**
		 * @private
		 *
		 * Takes the callback function and dispatches an event handler.
		 * 
		 * <p>
		 * <code>func</code> is a function (often a closure) that is used to test the results
		 * of a function.  This is _not_ the best way to test.  The correct implementation
		 * is based off the following blog:
		 * </p>
		 * 
		 * <a href="http://jharbs.com/blog/?p=96">
		 * http://jharbs.com/blog/?p=96
		 * </a>
		 * 
		 * <p>
		 * However, that would require that everybody this was distributed to be using
		 * a patched version of FlexUnit, which is certainly less than ideal.  Thus, I
		 * use a simple callback with a timeout by which the operations are expected to
		 * have completed.
		 * </p>
		 */
		private function callbackHelper(func:Function, runIn:uint=10, timeout:uint=50) : void
		{
			var t:Timer = new Timer(runIn, 1);
			t.addEventListener(TimerEvent.TIMER_COMPLETE, addAsync(func, timeout));
			t.start();
		}

		/**
		 * @private
		 * 
		 * Helper function that dispatches a <code>SampleAppendEvent</code>.
		 */
		private function invokeAppendCommand():SampleAppendEvent
		{
			var event:SampleAppendEvent = new SampleAppendEvent("first","second");

			// test the value beforehand (note that I should really be setting
			// data in a model rather than just manipulating data in the
			// event, but this serves as a quick test).
			assertEquals("first", event.data.value);

			CairngormEventDispatcher.getInstance().dispatchEvent( event );

			return event;
		}
	}
}
