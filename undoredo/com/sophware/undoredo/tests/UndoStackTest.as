package com.sophware.undoredo.tests
{
	import flexunit.framework.TestCase;
	import com.sophware.undoredo.UndoStack;
	import com.sophware.undoredo.UndoCommand;
	import com.sophware.undoredo.UndoCommand;

	public class UndoStackTest extends TestCase
	{
		private var us:UndoStack;
		
		public override function setUp():void {
			us = new UndoStack();
		}
		
		public function testCanUndo():void {
			assertFalse(us.canUndo);
			us.push(new UndoCommand());
			assertTrue(us.canUndo);
		}
		
		public function testCanRedo():void {
			us.push(new UndoCommand());
			us.undo();
			assertTrue(us.canRedo);
		}
		
		public function testClear():void {
			us.push(new UndoCommand());
			assertEquals( 1, us.count );
			assertTrue(us.canUndo);
			us.clear();
			assertEquals( 0, us.count );
			assertFalse(us.canUndo);
		}
		
		public function testCount():void {
			assertEquals( 0, us.count );
			us.push(new UndoCommand());
			assertEquals( 1, us.count );
		}
		
		public function testIndex():void {
			assertEquals( -1, us.index );
			us.push(new UndoCommand());
			assertEquals( 0, us.index );
		}
		
		public function testText():void {
			us.push(new UndoCommand("testCmd"));
			us.push(new UndoCommand("otherCmd"));
			assertEquals("testCmd", us.text(0) );
			assertEquals("otherCmd", us.text(1) );
		}
		
		public function testUndoText():void {
			us.push(new UndoCommand("testCmd"));
			assertEquals( "testCmd", us.undoText );
			us.push(new UndoCommand("otherCmd"));
			assertEquals( "otherCmd", us.undoText );
			us.undo();
			assertEquals( "testCmd", us.undoText );
		}
		
		public function testRedoText():void {
			us.push(new UndoCommand("testCmd"));
			us.push(new UndoCommand("otherCmd"));
			us.undo();
			assertEquals( "otherCmd", us.redoText );
			us.undo();
			assertEquals( "testCmd", us.redoText );
		}
		
	}
}
