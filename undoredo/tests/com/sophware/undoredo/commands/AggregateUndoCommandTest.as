package tests.com.sophware.undoredo.commands
{
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	import mx.collections.ArrayCollection;

	import flexunit.framework.TestCase;
	
	import com.sophware.undoredo.commands.AggregateUndoCommand;
	import com.sophware.undoredo.model.UndoStack;
	
	import tests.com.sophware.undoredo.commands.SampleMatrixCommand;
	import tests.com.sophware.undoredo.control.SampleMatrixEvent;

	public class AggregateUndoCommandTest extends TestCase
	{
		private var us:UndoStack;
		private var agg:AggregateUndoCommand;
		private var m:Matrix;

		public override function setUp():void
		{
			us = new UndoStack();
			agg = new AggregateUndoCommand();
			m = new Matrix(); // default to identity
		}
		
		public function testLifoOrder():void
		{
			var coll:ArrayCollection = new ArrayCollection();
			
			
			// create data to operate on
			var d:Object = {point:new Point(4,6)};
			var e:SampleMatrixEvent = new SampleMatrixEvent(d);
			
			// first translate by (3,5)
			m.translate(3,5);
			var cmd1:SampleMatrixCommand = new SampleMatrixCommand(m);
			
			// then rotate by 30 degrees
			m = new Matrix();
			m.rotate(30/180*Math.PI);
			var cmd2:SampleMatrixCommand = new SampleMatrixCommand(m);
			
			coll.addItem(cmd1);
			coll.addItem(cmd2);
			
			agg.commands = coll;
			
			us.push(agg, e);
			
			assertEquals(1, Math.round(d.point.x));
			assertEquals(13, Math.round(d.point.y));
			
			us.undo();
			
			assertEquals(4, Math.round(d.point.x));
			assertEquals(6, Math.round(d.point.y));
			
			
		}
		
		public function testFifoOrder():void
		{
			var coll:ArrayCollection = new ArrayCollection();
			
			// create data to operate on
			var d:Object = {point:new Point(4,6)};
			var e:SampleMatrixEvent = new SampleMatrixEvent(d);
			
			// first translate by (3,5)
			m.translate(3,5);
			var cmd1:SampleMatrixCommand = new SampleMatrixCommand(m);
			
			// then rotate by 30 degrees
			m = new Matrix();
			m.rotate(30/180*Math.PI);
			var cmd2:SampleMatrixCommand = new SampleMatrixCommand(m);
			
			coll.addItem(cmd1);
			coll.addItem(cmd2);
			
			agg.commands = coll;
			agg.order = AggregateUndoCommand.FIFO;
			
			us.push(agg, e);
			
			assertEquals(1, Math.round(d.point.x));
			assertEquals(13, Math.round(d.point.y));
			
			us.undo();
			
			assertEquals(2, Math.round(d.point.x));
			assertEquals(8, Math.round(d.point.y));
		}
		
		
	}
}
