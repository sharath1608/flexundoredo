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
