package tests.com.sophware.undoredo.commands
{
	import flash.geom.Matrix;
	import flash.geom.Point;
	import mx.collections.ArrayCollection;

	import com.adobe.cairngorm.control.CairngormEvent;
	
	import com.sophware.undoredo.commands.UndoCommand;

	import tests.com.sophware.undoredo.control.SampleMatrixEvent;

	public class SampleMatrixCommand extends UndoCommand
	{
		private var _m:Matrix; // matrix
		private var _i:Matrix; // inverse
		private var o:Object;

		public function SampleMatrixCommand(m:Matrix):void
		{
			// assume the matrix is invertible
			_m = m;
			_i = m.clone();
			_i.invert();
		}

		public override function redo( event : CairngormEvent = null ) : void
		{
			if (!(event is SampleMatrixEvent))
				return;

			var e:SampleMatrixEvent = event as SampleMatrixEvent;
			
			// apply the matrix transformation to the point
			e.data.point = _m.transformPoint(e.data.point);
		
			// store it for the undo operation
			o = e.data;
		}

		public override function undo() : void
		{
			// apply the inverse of the matrix transformation to the point
			o.point = _i.transformPoint(o.point as Point);
		}
	}
}
