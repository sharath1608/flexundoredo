package com.sophware.undoredo.control
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.FrontController;
	import com.adobe.cairngorm.CairngormError;
	import com.adobe.cairngorm.CairngormMessageCodes;
	
	import com.sophware.cairngorm.model.NamedObjectLocator;
	
	import com.sophware.undoredo.commands.IUndoCommand;
	import com.sophware.undoredo.commands.UndoCommand;
	import com.sophware.undoredo.model.UndoStack;
	import com.sophware.undoredo.model.UndoGroup;
	
	/**
	 * A FrontController with undo and redo support.
	 *
	 * <p>
	 * This controller checks the command associated with the event in
	 * question to see if it is an IUndoCommand or if it is a regular
	 * ICommand.  If it is an IUndoCommand, then the undoType property is
	 * checked to see whether this command should be ignored (as specified by
	 * UNDOTYPE_IGNORED), pushed onto the stack (as specified by
	 * UNDOTYPE_NORMAL), or if the stack should be reset (as specified by
	 * UNDOTYPE_RESET).
	 * </p>
	 *
	 * <p>
	 * A normal undo command will be pushed onto the stack and then executed.
	 * In most cases, this should be identical to executing the command and
	 * then pushing it onto the undo stack, although it's possible to create
	 * undo commands that affect this behavior.
	 * </p>
	 * 
	 * <p>
	 * An undo command that is ignored is peformed but not pushed onto the
	 * stack.  Thus, it does not affect what events can be undone or redone.
	 * </p>
	 * 
	 * <p>
	 * An undo command that specifies reset will be executed and then the undo
	 * stack will be reset, clearing all undoable and redoable events.
	 * </p>
	 */
	public class UndoFrontController extends FrontController
	{
		/**
		 * The name of the undo group as stored in the NamedObjectLocator class
		 */
		public static const UNDOGROUP_NAME:String = "undoGroup";
		
		/**
		 * The name of the undo stack to be added to the undo group
		 */
		public static const UNDOSTACK_NAME:String = "defaultStack";
	
		private var _undoGroup:UndoGroup;
		private var _activeStackName:Object;
		private var _locator:NamedObjectLocator;
	
		/**
		 * Creates a UndoFrontController.
		 *
		 * <p>
		 * This will create a default undo group called UNDOGROUP_NAME that may
		 * accessed or replaced, if necessary, in the NamedObjectLocator
		 * singleton.
		 * </p>
		 *
		 * <p>
		 * The activeStack within the UNDOGROUP_NAME undo group object will be
		 * used for all undo and redo operations, by default, this will be the
		 * UNDOSTACK_NAME undo stack, which is automatically added to the
		 * NamedObjectLocator.
		 * </p>
		 *
		 * <p>
		 * Additional undo stacks can be added to the undo group by using the
		 * addStack() and removeStack() accessors or by accessing the
		 * NamedObjectLocator class directly and referencing the UNDOGROUP_ANME
		 * undo group object.
		 * </p>
		 */
		public function UndoFrontController()
		{
			import mx.binding.utils.BindingUtils;
			
			super();
			_locator = NamedObjectLocator.getInstance();
			_locator.setObject(UNDOGROUP_NAME, new UndoGroup());	
			_undoGroup = _locator.getObject(UNDOGROUP_NAME) as UndoGroup;
			_undoGroup.addStack(UNDOSTACK_NAME);

			BindingUtils.bindProperty(this, "activeStackName", _undoGroup, "activeStackName");
		}
		
		/**
		 * Executes the command associated with the event being received.
		 *
		 * <p>
		 * The command may be an undo command or a normal cairngorm command
		 * that implements the ICommand interface.  For a full description of
		 * the behavior, see the class-level documentation.
		 * </p>
		 * 
		 * <p>
		 * If the command being executed is an undo command and the type is
		 * UNDOTYPE_NORMAL, then the event being passed must be a 
		 * CairngormUndoEvent since the undo and redo text will be pulled
		 * from the generating event.  If the event is not a CairngormUndoEvent
		 * then null will be passed instead of the event in question.
		 * </p>
		 */
		protected override function executeCommand( event : CairngormEvent ) : void 
		{
			var commandToInitialise : Class = getCommand( event.type );
			var commandToExecute : ICommand = new commandToInitialise();
			var undoGroup:UndoGroup = _locator.getObject(UNDOGROUP_NAME) as UndoGroup;

			if (commandToExecute is IUndoCommand) {
				var cmd:IUndoCommand = commandToExecute as IUndoCommand;
				switch (cmd.undoType) {
					case UndoCommand.UNDOTYPE_NORMAL:
						undoGroup.activeStack.push(cmd, event);
						break;
					case UndoCommand.UNDOTYPE_IGNORED:
						cmd.execute(event);
						break;
					case UndoCommand.UNDOTYPE_RESET:
						cmd.execute(event);
						undoGroup.activeStack.clear();
				}
			} else  {
				//
				// by default a command that doesn't implement the IUndoCommand interface
				// is a command that is non-undoable and, therefore, will cause the undo
				// stack to be reset.
				// 
				// if an event that is ignorable is really desired, implement the
				// IUndoCommand interface and set the undoType to:
				//
				// UndoCommand.UNDOTYPE_IGNORED
				//
				commandToExecute.execute( event );
				undoGroup.activeStack.clear();
	        }
		}
	
		/**
		 * Adds a new undo stack to the undo group.
		 *
		 * <p>
		 * The new undo stack automatically becomes the active undo stack.
		 * </p>
		 * 
		 * @param name The name of the undo stack to be added
		 * 
		 * @see com.sophware.cairngorm.model.UndoGroup
		 */
		public function addStack( name : Object ) : Boolean
		{
			return _locator.getObject(UNDOGROUP_NAME).addStack(name);
		}

		/**
		 * Removes the named undo stack from the undo group.
		 *
		 * <p>
		 * If the undo stack being removed from the undo group then the active
		 * undo stack will change.
		 * </p>
		 * 
		 * @param name The name of the undo stack to be removed
		 *
		 * @see com.sophware.cairngorm.model.UndoGroup
		 */
		public function removeStack( name : Object ) : Boolean
		{
			return _locator.getObject(UNDOGROUP_NAME).removeStack(name);
		}

		/**
		 * Sets the active undo stack to the named undo stack
		 *
		 * <p>
		 * If the named undo stack does not exist, the active undo stack will
		 * not be changed.
		 * </p>
		 */
		[Bindable]
		public function set activeStackName( name : Object ) : void
		{
			if (_locator.getObject(UNDOGROUP_NAME).activeStackName != name)
				 _locator.getObject(UNDOGROUP_NAME).activeStackName = name;
			_activeStackName = name;
		}

		/**
		 * Returns the name of the active undo stack in the undo group
		 */
		public function get activeStackName() : Object
		{
			return _activeStackName;
		}

		/**
		 * Returns the undo group that is used by the controller.
		 */
		public function get undoGroup() : UndoGroup
		{
			return _undoGroup;
		}
	}
}
