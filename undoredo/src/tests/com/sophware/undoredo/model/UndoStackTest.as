package tests.com.sophware.undoredo.model
{
	import flexunit.framework.TestCase;
	import com.sophware.undoredo.model.UndoStack;
	import com.sophware.undoredo.commands.UndoCommand;
	
	public class UndoStackTest extends TestCase
	{
		private var us:UndoStack;
		
		public override function setUp():void
		{
			us = new UndoStack();
		}
		
		public function testCanUndo():void
		{
			assertFalse(us.canUndo);
			us.push(new UndoCommand());
			assertTrue(us.canUndo);
		}
		
		public function testCanRedo():void
		{
			assertFalse(us.canRedo);
			us.push(new UndoCommand());
			us.undo();
			assertTrue(us.canRedo);
		}
		
		public function testClear():void
		{
			us.push(new UndoCommand());
			assertEquals( 1, us.count );
			assertTrue(us.canUndo);
			us.clear();
			assertEquals( 0, us.count );
			assertFalse(us.canUndo);
		}
		
		public function testCount():void
		{
			assertEquals( 0, us.count );
			us.push(new UndoCommand());
			assertEquals( 1, us.count );
		}
		
		public function testGetIndex():void
		{
			var cmd:UndoCommand = new UndoCommand();
			cmd.text = "testCmd";
			assertEquals( -1, us.index );
			us.push(cmd);
			assertEquals( 0, us.index );
		}

		public function testSetIndex():void
		{
			var cmd:UndoCommand = new UndoCommand();
			cmd.text = "testCmd";
			assertEquals( -1, us.index );
			us.push(cmd);
			assertEquals( 0, us.index );
			us.push(cmd);
			assertEquals( 1, us.index );
			us.push(cmd);
			assertEquals( 2, us.index );
			us.push(cmd);
			assertEquals( 3, us.index );
			
			assertFalse(us.canRedo);

			// undo events as necessary
			us.index = 1;
			
			assertEquals( 1, us.index );
			assertTrue(us.canRedo);

			us.redo();
			assertTrue(us.canRedo);
			us.redo();
			assertFalse(us.canRedo);
		}
		
		public function testText():void
		{
			var cmd1:UndoCommand = new UndoCommand();
			var cmd2:UndoCommand = new UndoCommand();
			cmd1.text = "testCmd";
			cmd2.text = "otherCmd";
			
			us.push(cmd1);
			us.push(cmd2);
			assertEquals("testCmd", us.text(0) );
			assertEquals("otherCmd", us.text(1) );
		}
		
		public function testUndoText():void
		{
			var cmd1:UndoCommand = new UndoCommand();
			var cmd2:UndoCommand = new UndoCommand();
			cmd1.text = "testCmd";
			cmd2.text = "otherCmd";
			
			assertEquals( "", us.undoText );
			us.push(cmd1);
			assertEquals( "testCmd", us.undoText );
			us.push(cmd2);
			assertEquals( "otherCmd", us.undoText );
			us.undo();
			assertEquals( "testCmd", us.undoText );
		}
		
		public function testRedoText():void
		{
			var cmd1:UndoCommand = new UndoCommand();
			var cmd2:UndoCommand = new UndoCommand();
			cmd1.text = "testCmd";
			cmd2.text = "otherCmd";
			
			assertEquals( "", us.redoText );
			
			us.push(cmd1);
			us.push(cmd2);

			assertEquals( "", us.redoText );
			
			us.undo();
			assertEquals( "otherCmd", us.redoText );
			us.undo();
			assertEquals( "testCmd", us.redoText );
		}
		
		public function testIsClean():void
		{
			var cmd1:UndoCommand = new UndoCommand();
			var cmd2:UndoCommand = new UndoCommand();
			cmd1.text = "testCmd";
			cmd2.text = "otherCmd";
			
			// make sure it's clean by default
			assertTrue(us.isClean);
			
			// push something, make sure it's no longer clean
			us.push(cmd1);
			assertFalse(us.isClean);
			
			us.undo();
			assertTrue(us.isClean);
			
			us.redo();
			assertFalse(us.isClean);
			
			// make the new index clean
			us.setClean();
			assertTrue(us.isClean);
			
			us.push(cmd2);
			assertFalse(us.isClean);
			
			us.undo();
			assertTrue(us.isClean);
		
			us.undo();
			assertFalse(us.isClean);

			// now that I have a couple redo actions pending, make sure that
			// the clean status is reset when a command is pushed onto the
			// stack
			us.push(cmd2);
			assertFalse(us.isClean);
		}
		
		public function testCleanIndex():void
		{
			var cmd:UndoCommand = new UndoCommand();
			
			assertEquals(-1, us.cleanIndex);
			
			us.push(cmd);

			// make sure the clean index is really representative of the value
			// when I call setClean()
			us.setClean();
			assertEquals(0, us.cleanIndex);

			cmd = new UndoCommand();

			us.push(cmd);

			// the clean index shouldn't change when I push an event and no
			// pending redo events were waiting... so the index should be the
			// same
			assertEquals(0, us.cleanIndex);

			us.undo();
			us.undo();
			assertEquals(0, us.cleanIndex);
			
			cmd = new UndoCommand();
			
			// since I have pending redo events, this should cause a reset of
			// the cleanIndex
			us.push(cmd);
			assertEquals(-1, us.cleanIndex);

		}
	}
}
