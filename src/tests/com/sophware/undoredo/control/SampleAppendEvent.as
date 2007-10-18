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
package tests.com.sophware.undoredo.control
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.sophware.undoredo.control.CairngormUndoEvent;

	public class SampleAppendEvent extends CairngormUndoEvent
	{
		public static const APPEND:String = "sample_append_event";
		
		public function SampleAppendEvent(value:String, appendText:String):void
		{
			super(APPEND);
			text = "append";
			data = {
				value:value,
				appendText:appendText
				};
		}
	}
}
