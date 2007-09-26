package tests.com.sophware.undoredo.model
{
	import flexunit.framework.TestCase;

	import com.sophware.undoredo.model.UndoGroup;
	import com.sophware.undoredo.model.UndoStack;
	import com.sophware.undoredo.commands.UndoCommand;
	import com.sophware.undoredo.control.CairngormUndoEvent;
	
	import tests.com.sophware.undoredo.control.SampleAppendEvent;

	public class UndoGroupTest extends TestCase
	{
		private var ug:UndoGroup;

		public override function setUp():void
		{
			ug = new UndoGroup();
			ug.addStack("other");
			ug.addStack("default");
		}

		public function testUndoText():void
		{
			var cmd:UndoCommand = new UndoCommand();
			var cmd2:UndoCommand = new UndoCommand();
			var evt:SampleAppendEvent = new SampleAppendEvent("orig", "appended");
			evt.text = "event1";
			var evt2:SampleAppendEvent = new SampleAppendEvent("orig2", "appended2");
			evt2.text = "event2";
			
			ug.activeStack.push(cmd, evt);
			assertEquals("event1", ug.activeStack.undoText);
			ug.activeStack.undo();
			assertEquals("", ug.activeStack.undoText);
			ug.activeStack.redo();
			assertEquals("event1", ug.activeStack.undoText);

			ug.setActiveStack("other");

			assertEquals("", ug.activeStack.undoText);
			assertFalse(ug.activeStack.canUndo);
			
			ug.activeStack.push(cmd2, evt2);

			assertEquals("event2", ug.activeStack.undoText);
			assertTrue(ug.activeStack.canUndo);

			ug.setActiveStack("default");

			assertEquals("event1", ug.activeStack.undoText);
		}

		public function testRedoText():void
		{
			var cmd:UndoCommand = new UndoCommand();
			var cmd2:UndoCommand = new UndoCommand();
			var evt:SampleAppendEvent = new SampleAppendEvent("orig", "appended");
			evt.text = "event1";
			var evt2:SampleAppendEvent = new SampleAppendEvent("orig2", "appended2");
			evt2.text = "event2";
			
			ug.activeStack.push(cmd, evt);
			assertEquals("event1", ug.activeStack.undoText);
			ug.activeStack.undo();
			assertEquals("", ug.activeStack.undoText);
			assertEquals("event1", ug.activeStack.redoText);

			ug.setActiveStack("other");

			assertEquals("", ug.activeStack.redoText);
			assertFalse(ug.activeStack.canRedo);
			
			ug.activeStack.push(cmd2, evt2);

			assertEquals("", ug.activeStack.redoText);
			ug.activeStack.undo();
			assertEquals("event2", ug.activeStack.redoText);

			ug.setActiveStack("default");

			assertEquals("event1", ug.activeStack.redoText);
		}

		public function testCanUndo():void
		{
			var cmd:UndoCommand = new UndoCommand();
			var cmd2:UndoCommand = new UndoCommand();
			var evt:SampleAppendEvent = new SampleAppendEvent("orig", "appended");
			evt.text = "event1";
			var evt2:SampleAppendEvent = new SampleAppendEvent("orig2", "appended2");
			evt2.text = "event2";

			// verify on the default stack
			assertFalse(ug.activeStack.canUndo);
			ug.activeStack.push(cmd, evt);
			assertTrue(ug.activeStack.canUndo);

			// verify on the other stack
			ug.setActiveStack("other");
			assertFalse(ug.activeStack.canUndo);
			ug.activeStack.push(cmd2, evt2);
			assertTrue(ug.activeStack.canUndo);
		
			// make them different and verify
			ug.activeStack.undo();
			assertFalse(ug.activeStack.canUndo);
		
			// now change it
			ug.setActiveStack("default");
			assertTrue(ug.activeStack.canUndo);
			ug.activeStack.undo();
			assertFalse(ug.activeStack.canUndo);
		}

		public function testCanRedo():void
		{
			var cmd:UndoCommand = new UndoCommand();
			var cmd2:UndoCommand = new UndoCommand();
			var evt:SampleAppendEvent = new SampleAppendEvent("orig", "appended");
			evt.text = "event1";
			var evt2:SampleAppendEvent = new SampleAppendEvent("orig2", "appended2");
			evt2.text = "event2";

			assertFalse(ug.activeStack.canRedo);
			ug.activeStack.push(cmd, evt);
			assertFalse(ug.activeStack.canRedo);
			ug.activeStack.undo();
			assertTrue(ug.activeStack.canRedo);

			ug.setActiveStack("other");
			assertFalse(ug.activeStack.canRedo);
			ug.activeStack.push(cmd2, evt2);
			assertFalse(ug.activeStack.canRedo);
			ug.activeStack.undo();
			assertTrue(ug.activeStack.canRedo);

			ug.setActiveStack("default");
			assertTrue(ug.activeStack.canRedo);
			ug.activeStack.redo();
			assertFalse(ug.activeStack.canRedo);

			ug.setActiveStack("other");
			assertTrue(ug.activeStack.canRedo);
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
			var cmd:UndoCommand = new UndoCommand();
			var evt:SampleAppendEvent = new SampleAppendEvent("orig", "appended");
			evt.text = "event1";
			
			assertTrue(ug.clean);
			assertTrue(ug.activeStack.clean);
			
			ug.activeStack.push(cmd, evt);
			
			assertFalse(ug.clean);
			assertFalse(ug.activeStack.clean);
			
			ug.activeStack.undo();
			
			assertTrue(ug.clean);
			assertTrue(ug.activeStack.clean);
			
			ug.activeStack.redo();
			
			assertFalse(ug.clean);
			assertFalse(ug.activeStack.clean);
		}
	}
}
