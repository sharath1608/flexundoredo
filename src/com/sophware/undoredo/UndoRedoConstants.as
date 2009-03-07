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
package com.sophware.undoredo
{
	/**
	 * Holds the constants that can be used to check command type.
	 *
	 * <p>
	 * Three different undo types currently exist. See <code>IUndoCommand</code>
	 * </p>
	 */
	public class UndoRedoConstants
	{
		/**
		 * The "normal" undoType as specified by <code>IUndoCommand</code>.
		 */
		public static const UNDOTYPE_NORMAL:String = "normal";
		
		/**
		 * The "ignored" undoType as specified by <code>IUndoCommand</code>.
		 */
		public static const UNDOTYPE_IGNORED:String = "ignored";
		
		/**
		 * The "reset" undoType as specified by <code>IUndoCommand</code>.
		 */
		public static const UNDOTYPE_RESET:String = "reset";
	}
}

