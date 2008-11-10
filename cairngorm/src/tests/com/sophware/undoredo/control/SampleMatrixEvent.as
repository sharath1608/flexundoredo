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
package tests.com.sophware.undoredo.control
{
	import com.adobe.cairngorm.control.CairngormEvent;

	public class SampleMatrixEvent extends CairngormEvent
	{
		public static const POINT:String = "sample_matrix_event";
		
		public function SampleMatrixEvent(data:Object) : void
		{
			super(POINT);
			this.data = data;
		}
	}
}
