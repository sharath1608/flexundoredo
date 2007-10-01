package tests.com.sophware.undoredo.model
{
	import mx.binding.utils.BindingUtils;
	
	import flexunit.framework.TestCase;

	import com.sophware.undoredo.model.UndoGroup;
	import com.sophware.undoredo.model.UndoStack;
	import com.sophware.undoredo.commands.UndoCommand;
	import com.sophware.undoredo.control.CairngormUndoEvent;
	
	import tests.com.sophware.undoredo.control.SampleAppendEvent;

	public class UndoGroupTest extends TestCase
	{
		private var ug:UndoGroup;

		// for testing the bindings
		[Bindable] public var text:String;
		[Bindable] public var bool:Boolean;
		[Bindable] public var us:UndoStack;

		public override function setUp():void
		{
			ug = new UndoGroup();
			ug.addStack("other");
			ug.addStack("default");
		}

		public function testActiveStack():void
		{
			// if this test doesn't work, almost every test below will fail
			BindingUtils.bindProperty(this, "us", ug, "activeStack");
			
			// No matter which active stack I have specified, my bound
			// variable should be the same
			assertTrue(us == ug.activeStack);
			ug.setActiveStack("other");
			assertTrue(us == ug.activeStack);
			ug.setActiveStack("default");
			assertTrue(us == ug.activeStack);

			// just to verify...
			ug.activeStack.push(new UndoCommand());
			assertTrue(ug.activeStack.canUndo);
			assertTrue(us.canUndo);

			ug.setActiveStack("other");
			assertFalse(ug.activeStack.canUndo);
			assertFalse(us.canUndo);
		}

		public function testUndoText():void
		{
			BindingUtils.bindProperty(this, "text", ug, "undoText");
			
			var cmd:UndoCommand = new UndoCommand();
			var cmd2:UndoCommand = new UndoCommand();
			var evt:SampleAppendEvent = new SampleAppendEvent("orig", "appended");
			evt.text = "event1";
			var evt2:SampleAppendEvent = new SampleAppendEvent("orig2", "appended2");
			evt2.text = "event2";
			
			ug.activeStack.push(cmd, evt)
			
			assertEquals("event1", ug.undoText);
			assertEquals("event1", text);

			ug.activeStack.undo();
			assertEquals("", ug.undoText);
			assertEquals("", text);
			ug.activeStack.redo();
			assertEquals("event1", ug.undoText);
			assertEquals("event1", text);

			ug.setActiveStack("other");

			assertEquals("", ug.undoText);
			assertEquals("", text);
			assertFalse(ug.activeStack.canUndo);
			
			ug.activeStack.push(cmd2, evt2);

			assertEquals("event2", ug.undoText);
			assertEquals("event2", text);
			assertTrue(ug.activeStack.canUndo);

			ug.setActiveStack("default");

			assertEquals("event1", ug.undoText);
			assertEquals("event1", text);
		}

		public function testRedoText():void
		{
			BindingUtils.bindProperty(this, "text", ug, "redoText");
			
			var cmd:UndoCommand = new UndoCommand();
			var cmd2:UndoCommand = new UndoCommand();
			var evt:SampleAppendEvent = new SampleAppendEvent("orig", "appended");
			evt.text = "event1";
			var evt2:SampleAppendEvent = new SampleAppendEvent("orig2", "appended2");
			evt2.text = "event2";
			
			ug.activeStack.push(cmd, evt);
			ug.activeStack.undo();
			assertEquals("event1", ug.redoText);
			assertEquals("event1", text);

			ug.setActiveStack("other");

			assertEquals("", ug.redoText);
			assertEquals("", text);
			assertFalse(ug.canRedo);
			
			ug.activeStack.push(cmd2, evt2);

			assertEquals("", ug.redoText);
			assertEquals("", text);
			ug.activeStack.undo();
			assertEquals("event2", ug.redoText);
			assertEquals("event2", text);

			ug.setActiveStack("default");

			assertEquals("event1", ug.redoText);
			assertEquals("event1", text);
		}

		public function testCanUndo():void
		{
			BindingUtils.bindProperty(this, "bool", ug, "canUndo");

			var cmd:UndoCommand = new UndoCommand();
			var cmd2:UndoCommand = new UndoCommand();
			var evt:SampleAppendEvent = new SampleAppendEvent("orig", "appended");
			evt.text = "event1";
			var evt2:SampleAppendEvent = new SampleAppendEvent("orig2", "appended2");
			evt2.text = "event2";

			// verify on the default stack
			assertFalse(ug.canUndo);
			assertFalse(bool);
			ug.activeStack.push(cmd, evt);
			assertTrue(ug.canUndo);
			assertTrue(bool);

			// verify on the other stack
			ug.setActiveStack("other");
			assertFalse(ug.canUndo);
			assertFalse(bool);
			ug.activeStack.push(cmd2, evt2);
			assertTrue(ug.canUndo);
			assertTrue(bool);
		
			// make them different and verify
			ug.activeStack.undo();
			assertFalse(ug.canUndo);
			assertFalse(bool);
		
			// now change it
			ug.setActiveStack("default");
			assertTrue(ug.canUndo);
			assertTrue(bool);
			ug.activeStack.undo();
			assertFalse(ug.canUndo);
			assertFalse(bool);
		}

		public function testCanRedo():void
		{
			BindingUtils.bindProperty(this, "bool", ug, "canRedo");
			
			var cmd:UndoCommand = new UndoCommand();
			var cmd2:UndoCommand = new UndoCommand();
			var evt:SampleAppendEvent = new SampleAppendEvent("orig", "appended");
			evt.text = "event1";
			var evt2:SampleAppendEvent = new SampleAppendEvent("orig2", "appended2");
			evt2.text = "event2";

			assertFalse(ug.canRedo);
			assertFalse(bool);
			ug.activeStack.push(cmd, evt);
			assertFalse(ug.canRedo);
			assertFalse(bool);
			ug.activeStack.undo();
			assertTrue(ug.canRedo);
			assertTrue(bool);

			ug.setActiveStack("other");
			assertFalse(ug.canRedo);
			assertFalse(bool);
			ug.activeStack.push(cmd2, evt2);
			assertFalse(ug.canRedo);
			assertFalse(bool);
			ug.activeStack.undo();
			assertTrue(ug.canRedo);
			assertTrue(bool);

			ug.setActiveStack("default");
			assertTrue(ug.canRedo);
			assertTrue(bool);
			ug.activeStack.redo();
			assertFalse(ug.canRedo);
			assertFalse(bool);

			ug.setActiveStack("other");
			assertTrue(ug.canRedo);
			assertTrue(bool);
		}

		public function testRemoveStack():void
		{
			assertFalse(ug.removeStack("does not exist"));
			assertTrue(ug.removeStack("other"));
			assertFalse(ug.removeStack("other"));
		}

		public function testHasStack():void
		{
			assertFalse(ug.hasStack("does not exist"));
			assertTrue(ug.hasStack("default"));
			assertTrue(ug.hasStack("other"));
			assertFalse(ug.hasStack("blah"));
		}

		public function testAddStack():void
		{
			assertFalse(ug.addStack("default"));
			assertTrue(ug.addStack("test"));
			assertTrue(ug.hasStack("test"));
		}

		public function testIsClean():void
		{
			BindingUtils.bindProperty(this, "bool", ug, "clean");
			
			var cmd:UndoCommand = new UndoCommand();
			var evt:SampleAppendEvent = new SampleAppendEvent("orig", "appended");
			evt.text = "event1";
			
			assertTrue(ug.clean);
			assertTrue(bool);
			
			ug.activeStack.push(cmd, evt);
			
			assertFalse(ug.clean);
			assertFalse(bool);
			
			ug.activeStack.undo();
			
			assertTrue(ug.clean);
			assertTrue(bool);
			
			ug.activeStack.redo();
			
			assertFalse(ug.clean);
			assertFalse(bool);
		}
	}
}
