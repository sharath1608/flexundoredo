/*
 * This file is a part of the Flex UndoRedo Framework
 *  
 * Copyright (C) 2007 Soph-Ware Associates, Inc.
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Library General Public
 * License as published by the Free Software Foundation; either
 * version 2 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Library General Public License for more details.
 *
 * You should have received a copy of the GNU Library General Public License
 * along with this library; see the file LICENSE.TXT.  If not, write to
 * the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
 * Boston, MA 02110-1301, USA.
 */
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
