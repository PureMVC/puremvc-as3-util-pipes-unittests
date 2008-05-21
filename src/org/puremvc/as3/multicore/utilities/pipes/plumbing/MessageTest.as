/*
 PureMVC AS3/MultiCore Pipes Utility Unit Tests
 Copyright (c) 2008 Cliff Hall<cliff.hall@puremvc.org>
 Your reuse is governed by the Creative Commons Attribution 3.0 License
*/
package org.puremvc.as3.multicore.utilities.pipes.plumbing
{
	import flexunit.framework.TestCase;
	import flexunit.framework.TestSuite;
	
	import org.puremvc.as3.multicore.utilities.pipes.interfaces.IPipeMessage;
	
 	/**
	 * Test the Message class.
	 */
	public class MessageTest extends TestCase {
  		
   		/**
  		 * Constructor.
  		 * 
  		 * @param methodName the name of the test method an instance to run
  		 */
 	    public function MessageTest( methodName:String ) {
   			super( methodName );
           }
  	
 		/**
		 * Create the TestSuite.
		 */
 		public static function suite():TestSuite {
   			var ts:TestSuite = new TestSuite();
   			
   			ts.addTest( new MessageTest( "testConstructorAndGetters" ) );
   			ts.addTest( new MessageTest( "testDefaultPriority" ) );
   			ts.addTest( new MessageTest( "testSettersAndGetters" ) );
   			return ts;
   		}

  		/**
  		 * Tests the constructor parameters and getters
  		 */
  		public function testConstructorAndGetters():void {
   			var message:IPipeMessage = new Message( Message.TYPE_NORMAL, 
   													{ testProp:'testval' },
   													new XML(<testMessage testAtt='Hello'/>),
   													Message.PRIORITY_HIGH);
   			
   			// test assertions
   			assertTrue( "Expecting message is Message", message is Message );
   			assertTrue( "Expecting message.getType() == Message.TYPE_NORMAL", message.getType() == Message.TYPE_NORMAL );
   			assertTrue( "Expecting message.getHeader().testProp == 'testval'", message.getHeader().testProp == 'testval');
   			assertTrue( "Expecting message.getBody().@testAtt == 'Hello'",  message.getBody().@testAtt == 'Hello');
   			assertTrue( "Expecting message.getPriority() == Message.PRIORITY_HIGH",  message.getPriority() == Message.PRIORITY_HIGH);
   			
   		}

  		/**
  		 * Tests message default priority
  		 */
  		public function testDefaultPriority():void {
   			var message:IPipeMessage = new Message( Message.TYPE_NORMAL, null );
   			
   			// test assertions
   			assertTrue( "Expecting message.getPriority() == Message.PRIORITY_MED",  message.getPriority() == Message.PRIORITY_MED);
   			
   		}

  		/**
  		 * Tests the setters and getters
  		 */
  		public function testSettersAndGetters():void {
   			var message:IPipeMessage = new Message( Message.TYPE_NORMAL, null );
   			
   			message.setHeader( { testProp:'testval' } );
   			message.setBody( new XML(<testMessage testAtt='Hello'/>) );
   			message.setPriority( Message.PRIORITY_LOW );
   			
   			// test assertions
   			assertTrue( "Expecting message is Message", message is Message );
   			assertTrue( "Expecting message.getType() == Message.TYPE_NORMAL", message.getType() == Message.TYPE_NORMAL );
   			assertTrue( "Expecting message.getHeader().testProp == 'testval'", message.getHeader().testProp == 'testval');
   			assertTrue( "Expecting message.getBody().@testAtt == 'Hello'",  message.getBody().@testAtt == 'Hello');
   			assertTrue( "Expecting message.getPriority() == Message.PRIORITY_LOW",  message.getPriority() == Message.PRIORITY_LOW);
   			
   		}
	}
}