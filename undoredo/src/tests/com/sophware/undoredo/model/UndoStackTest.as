package tests.com.sophware.undoredo.model
{
	import mx.binding.utils.BindingUtils;
	
	import flexunit.framework.TestCase;
	
	import com.sophware.undoredo.model.UndoStack;
	import com.sophware.undoredo.commands.UndoCommand;

	import tests.com.sophware.undoredo.commands.SampleMergeCommand;


	public class UndoStackTest extends TestCase
	{
		private var us:UndoStack;

		[Bindable] public var bool:Boolean;
		[Bindable] public var text:String;
		[Bindable] public var index:Number;
		[Bindable] public var count:Number;
		
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
		
		public function testCanUndoBinding():void
		{
			BindingUtils.bindProperty(this, "bool", us, "canUndo");

			assertFalse(us.canUndo);
			assertFalse(bool);

			us.push(new UndoCommand());
			
			assertTrue(us.canUndo);
			assertTrue(bool);
		}

	
		public function testCanRedo():void
		{
			BindingUtils.bindProperty(this, "bool", us, "canRedo");
			
			assertFalse(us.canRedo);
			assertFalse(bool);

			us.push(new UndoCommand());
			us.undo();
			
			assertTrue(us.canRedo);
			assertTrue(bool);
		}

		public function testCanRedoBinding():void
		{
			// make canRedo notify about all changes 
			BindingUtils.bindProperty(this, "bool", us, "canRedo");
			
			assertFalse(us.canRedo);
			assertFalse(bool);

			us.push(new UndoCommand());
			us.undo();

			assertTrue(us.canRedo);
			assertTrue(bool);
		}
		
		public function testClear():void
		{
			// make canUndo notify about all changes 
			BindingUtils.bindProperty(this, "bool", us, "canUndo");

			us.push(new UndoCommand());

			assertEquals( 1, us.count );
			assertTrue(us.canUndo);
			assertTrue(bool);

			us.clear();
			
			assertEquals( 0, us.count );
			assertFalse(us.canUndo);
			assertFalse(bool);
		}
		
		public function testCount():void
		{
			BindingUtils.bindProperty(this, "count", us, "count");
			
			assertEquals( 0, us.count );
			assertEquals( 0, count); 
			us.push(new UndoCommand());
			assertEquals( 1, us.count );
			assertEquals( 1, count );
		}
		
		public function testGetIndex():void
		{
			BindingUtils.bindProperty(this, "index", us, "index");

			var cmd:UndoCommand = new UndoCommand();
			cmd.text = "testCmd";
			assertEquals( -1, us.index );
			assertEquals( -1, index );
			us.push(cmd);
			assertEquals( 0, us.index );
			assertEquals( 0, index );
		}

		public function testTooManyUndos():void
		{
			var cmd:UndoCommand = new UndoCommand();
			assertFalse(us.canRedo);
			assertFalse(us.canUndo);
			us.push(cmd);
			assertFalse(us.canRedo);
			assertTrue(us.canUndo);
			us.undo();
			assertFalse(us.canUndo);
			assertTrue(us.canRedo);
			
			// this shouldn't change the ability to undo/redo
			us.undo();
			us.undo();
			assertFalse(us.canUndo);
			assertTrue(us.canRedo);
	
			us.redo();
			
			assertFalse(us.canRedo);
			assertTrue(us.canUndo);
		}

		public function testTooManyRedos():void
		{
			var cmd:UndoCommand = new UndoCommand();
			us.push(cmd);
			assertFalse(us.canRedo);
			assertTrue(us.canUndo);
			us.undo();
			assertFalse(us.canUndo);
			assertTrue(us.canRedo);
			
			us.redo();
			
			assertFalse(us.canRedo);
			assertTrue(us.canUndo);

			// these shouldn't affect the undo/redo status and should not cause
			// a crash of any sort
			us.redo();
			us.redo();
			
			assertFalse(us.canRedo);
			assertTrue(us.canUndo);

			us.undo();
			
			assertFalse(us.canUndo);
			assertTrue(us.canRedo);
		}

		public function testSetIndex():void
		{
			BindingUtils.bindProperty(this, "bool", us, "canRedo");

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
			assertFalse(bool);

			// undo events as necessary
			us.index = 1;
			
			assertEquals( 1, us.index );
			assertTrue(us.canRedo);
			assertTrue(bool);

			us.redo();
			assertTrue(us.canRedo);
			assertTrue(bool);
			us.redo();
			assertFalse(us.canRedo);
			assertFalse(bool);
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
			BindingUtils.bindProperty(this, "text", us, "undoText");
			
			var cmd1:UndoCommand = new UndoCommand();
			var cmd2:UndoCommand = new UndoCommand();
			cmd1.text = "testCmd";
			cmd2.text = "otherCmd";
		
			assertEquals( "", us.undoText );
			assertEquals( "", text);
			us.push(cmd1);
			assertEquals( "testCmd", us.undoText );
			assertEquals( "testCmd", text );
			us.push(cmd2);
			assertEquals( "otherCmd", us.undoText );
			assertEquals( "otherCmd", text );
			us.undo();
			assertEquals( "testCmd", us.undoText );
			assertEquals( "testCmd", text );
		}
		
		public function testRedoText():void
		{
			BindingUtils.bindProperty(this, "text", us, "redoText");
			
			var cmd1:UndoCommand = new UndoCommand();
			var cmd2:UndoCommand = new UndoCommand();
			cmd1.text = "testCmd";
			cmd2.text = "otherCmd";
			
			assertEquals( "", us.redoText );
			assertEquals( "", text );
			
			us.push(cmd1);
			us.push(cmd2);

			assertEquals( "", us.redoText );
			assertEquals( "", text );
			
			us.undo();
			assertEquals( "otherCmd", us.redoText );
			assertEquals( "otherCmd", text );
			us.undo();
			assertEquals( "testCmd", us.redoText );
			assertEquals( "testCmd", text );
		}
		
		public function testIsClean():void
		{
			BindingUtils.bindProperty(this, "bool", us, "clean");

			var cmd1:UndoCommand = new UndoCommand();
			var cmd2:UndoCommand = new UndoCommand();
			cmd1.text = "testCmd";
			cmd2.text = "otherCmd";
			
			// make sure it's clean by default
			assertTrue(us.clean);
			assertTrue(bool);

			// push something, make sure it's no longer clean
			us.push(cmd1);
			assertFalse(us.clean);
			assertFalse(bool);
			
			us.undo();
			assertTrue(us.clean);
			assertTrue(bool);
			
			us.redo();
			assertFalse(us.clean);
			assertFalse(bool);
			
			// make the new index clean
			us.clean = true;
			assertTrue(us.clean);
			assertTrue(bool);
			
			us.push(cmd2);
			assertFalse(us.clean);
			assertFalse(bool);
			
			us.undo();
			assertTrue(us.clean);
			assertTrue(bool);
		
			us.undo();
			assertFalse(us.clean);
			assertFalse(bool);

			// now that I have a couple redo actions pending, make sure that
			// the clean status is reset when a command is pushed onto the
			// stack
			us.push(cmd2);
			assertFalse(us.clean);
			assertFalse(bool);
		}
		
		public function testCleanIndex():void
		{
			BindingUtils.bindProperty(this, "index", us, "cleanIndex");

			var cmd:UndoCommand = new UndoCommand();
			
			assertEquals(-1, us.cleanIndex);
			assertEquals(-1, index);
			
			us.push(cmd);

			// make sure the clean index is really representative of the value
			// when I call clean = true
			us.clean = true;
			assertEquals(0, us.cleanIndex);
			assertEquals(0, index);

			cmd = new UndoCommand();

			us.push(cmd);

			// the clean index shouldn't change when I push an event and no
			// pending redo events were waiting... so the index should be the
			// same
			assertEquals(0, us.cleanIndex);
			assertEquals(0, index);

			us.undo();
			us.undo();
			assertEquals(0, us.cleanIndex);
			assertEquals(0, index);
			
			cmd = new UndoCommand();
			
			// since I have pending redo events, this should cause a reset of
			// the cleanIndex
			us.push(cmd);
			assertEquals(-1, us.cleanIndex);
			assertEquals(-1, index);
		}

		public function testMergeWith():void
		{
			var data:Object = {data:"The "};

			// because this is a mergeable command, no additional items should
			// be pushed onto the stack, instead the undo will now encompass
			// all the changes
			us.push(new SampleMergeCommand(data, "cow "));
			assertEquals(1, us.count);
			assertEquals("The cow ", data.data);

			// undo should undo everything, redo should redo everything
			us.undo();
			assertEquals("The ", data.data);
			us.redo();
			assertEquals("The cow ", data.data);

			// undo should undo everything, redo should redo everything
			us.push(new SampleMergeCommand(data, "jumped "));
			assertEquals(1, us.count);
			assertEquals("The cow jumped ", data.data);
			us.undo();
			assertEquals("The ", data.data);
			us.redo();
			assertEquals("The cow jumped ", data.data);

			us.push(new SampleMergeCommand(data, "over "));
			assertEquals(1, us.count);
			us.push(new SampleMergeCommand(data, "the "));
			assertEquals(1, us.count);
			us.push(new SampleMergeCommand(data, "moon!"));
			assertEquals(1, us.count);
			assertEquals("The cow jumped over the moon!", data.data);
			us.undo();
			assertEquals("The ", data.data);
			us.redo();
			assertEquals("The cow jumped over the moon!", data.data);

			// this shouldn't merge because it houses a different data object
			var data2:Object = {data:"Something else"};
			us.push(new SampleMergeCommand(data2, " not"));
			assertEquals(2, us.count);
			assertEquals("Something else not", data2.data);

			// my data shouldn't have changed
			assertEquals("The cow jumped over the moon!", data.data);
		}
	}
}

