package com.sophware.undoredo.tests
{
	import flexunit.framework.TestCase;
	import com.sophware.undoredo.AggregateUndoCommand;
	import com.sophware.undoredo.UndoStack;

	public class AggregateUndoCommandTest extends TestCase
	{
		private var us:UndoStack;
		private var uc:AggregateUndoCommand;
		
		public override function setUp():void {
			us = new UndoStack();
		}
		
		public function testFifoOrder():void {
			
		}
		
		public function testLifoOrder():void {
			
		}
		
		
	}
}