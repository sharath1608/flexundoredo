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
package tests.com.sophware.undoredo.commands
{
	import flash.geom.Matrix;
	import flash.geom.Point;
	import mx.collections.ArrayCollection;

	import com.sophware.undoredo.commands.UndoCommand;
	import com.sophware.undoredo.control.BaseUndoRedoEvent;

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

		public override function redo( event : BaseUndoRedoEvent = null ) : void
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
