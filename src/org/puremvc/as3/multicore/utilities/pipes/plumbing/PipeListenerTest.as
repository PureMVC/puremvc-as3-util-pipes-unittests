/*
 PureMVC AS3/MultiCore Pipes Utility Unit Tests
 Copyright (c) 2008 Cliff Hall<cliff.hall@puremvc.org>
 Your reuse is governed by the Creative Commons Attribution 3.0 License
*/
package org.puremvc.as3.multicore.utilities.pipes.plumbing
{
	import flexunit.framework.TestCase;
	import flexunit.framework.TestSuite;
	
	import org.puremvc.as3.multicore.utilities.pipes.interfaces.IPipeFitting;
	import org.puremvc.as3.multicore.utilities.pipes.interfaces.IPipeMessage;
	
 	/**
	 * Test the PipeListener class.
	 */
	public class PipeListenerTest extends TestCase 
	{
  		
   		/**
  		 * Constructor.
  		 * 
  		 * @param methodName the name of the test method an instance to run
  		 */
 	    public function PipeListenerTest( methodName:String ) 
 	    {
   			super( methodName );
        }
  	
 		/**
		 * Create the TestSuite.
		 */
 		public static function suite():TestSuite 
 		{
   			var ts:TestSuite = new TestSuite();
   			
   			ts.addTest( new PipeListenerTest( "testConnectingToAPipe" ) );
   			ts.addTest( new PipeListenerTest( "testReceiveMessageViaPipeListener" ) );
   			return ts;
   		}
  		
  		/**
  		 * Test connecting a pipe listener to a pipe. 
  		 */
  		public function testConnectingToAPipe():void 
  		{
  			// create pipe and listener
   			var pipe:IPipeFitting = new Pipe();
   			var listener:PipeListener = new PipeListener( this,callBackMethod );
   			
   			// connect the listener to the pipe
   			var success:Boolean = pipe.connect(listener);
   			
   			// test assertions
   			assertTrue( "Expecting pipe is Pipe", pipe is Pipe );
   			assertTrue( "Expecting successfully connected listener to pipe", success );
   		}

  		/**
  		 * Test receiving a message from a pipe using a PipeListener.
  		 */
  		public function testReceiveMessageViaPipeListener():void 
  		{
			// create a message
   			var messageToSend:IPipeMessage = new Message( Message.TYPE_NORMAL, 
   													      { testProp:'testval' },
   														  new XML(<testMessage testAtt='Hello'/>),
   													      Message.PRIORITY_HIGH );
  			// create pipe and listener
   			var pipe:IPipeFitting = new Pipe();
   			var listener:PipeListener = new PipeListener( this,callBackMethod );
   			
   			// connect the listener to the pipe and write the message
   			var connected:Boolean = pipe.connect(listener);
   			var written:Boolean = pipe.write( messageToSend );
   			
   			// test assertions
			assertTrue( "Expecting pipe is Pipe", pipe is Pipe );
   			assertTrue( "Expecting connected listener to pipe", connected );
   			assertTrue( "Expecting wrote message to pipe", written );
   			assertTrue( "Expecting messageReceived is Message", messageReceived is Message );
   			assertTrue( "Expecting messageReceived.getType() == Message.TYPE_NORMAL", messageReceived.getType() == Message.TYPE_NORMAL );
   			assertTrue( "Expecting messageReceived.getHeader().testProp == 'testval'", messageReceived.getHeader().testProp == 'testval');
   			assertTrue( "Expecting messageReceived.getBody().@testAtt == 'Hello'",  messageReceived.getBody().@testAtt == 'Hello');
   			assertTrue( "Expecting messageReceived.getPriority() == Message.PRIORITY_HIGH",  messageReceived.getPriority() == Message.PRIORITY_HIGH);
  			
   		}
   		
		/**
		 * Recipient of message.
		 * <P>
		 * Used by <code>callBackMedhod</code> as a place to store
		 * the recieved message.</P>
		 */     		
   		private var messageReceived:IPipeMessage;
   		
   		/**
   		 * Callback given to <code>PipeListener</code> for incoming message.
   		 * <P>
   		 * Used by <code>testReceiveMessageViaPipeListener</code> 
   		 * to get the output of pipe back into this  test to see 
   		 * that a message passes through the pipe.</P>
   		 */
   		private function callBackMethod(message:IPipeMessage):void
   		{
   			this.messageReceived = message;
   		}
   		
	}
}