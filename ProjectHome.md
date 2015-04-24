# Flex UndoRedo Framework #

We at [Soph-Ware Associates](http://www.soph-ware.com/) would like to announce the first release of the Flex UndoRedo Framework. The Flex UndoRedo Framework provides all the facilities that you need for implementing undo and redo within your applications.

The Flex UndoRedo Framework was built with the following goals in mind:

  * Provide a robust, extensible framework that would work without modification for basic needs
  * Support for different groups of undo events (one group per flexMdi window for example)
  * Allow undo and redo of an unlimited number of events
  * Integrate cleanly and transparently into applications with or without Cairngorm

The Flex UndoRedo Framework is an open source project available for all to use. For more information, please see the links in the sidebar.

## With Cairngorm ##

The Cairngorm release builds provides a lightweight but extensible framework for handling undo and redo.

As we have now been through a few iterations with the undo framework, we believe that it provides a solid 1.0 release. If you have thoughts or suggestions, we would love to hear about them.

## Without Cairngorm ##

We have recently created a fork of the UndoRedo Framework that does **NOT** use Cairngorm.  Rather, it provides the same undo stack and undo group facilities but uses a different base class and a separate (but identical) interface so that it can easily be integrated into non-Cairngorm projects.

You can download the most recent version of the Flex UndoRedo Framework not requiring Cairngorm from the downloads area or the featured downloads sidebar.

## Commercial Friendly ##

Although we started out with a GPL license, we've changed our license to the Apache License in order to be friendly to our commercial users.  A sincere thank you to everyone who requested this change.

Please let us know how of your successes, failures or of anything relevant you think we should know.